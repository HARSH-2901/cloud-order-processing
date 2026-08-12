terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_servicebus_namespace" "main" {
  name                = var.service_bus_name
  location            = var.service_bus_location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "orders" {
  name         = var.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.main.id
}
resource "azurerm_storage_account" "function" {
  name                     = var.function_storage_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.function_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_service_plan" "function" {
  name                = "${var.function_app_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.function_location
  os_type             = "Linux"
  sku_name            = "FC1"
}
resource "azurerm_storage_container" "function_deployment" {
  name                  = "function-deployment"
  storage_account_id    = azurerm_storage_account.function.id
  container_access_type = "private"
}
resource "azurerm_function_app_flex_consumption" "order_processor" {
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.function_location
  service_plan_id     = azurerm_service_plan.function.id

  storage_container_type     = "blobContainer"
  storage_container_endpoint = "${azurerm_storage_account.function.primary_blob_endpoint}${azurerm_storage_container.function_deployment.name}"

  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.function.primary_access_key

  runtime_name    = "dotnet-isolated"
  runtime_version = "10.0"

  maximum_instance_count = 10

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.function.id]
  }

  app_settings = {
    "ServiceBusConnectionString__fullyQualifiedNamespace" = "${azurerm_servicebus_namespace.main.name}.servicebus.windows.net"
    "ServiceBusConnectionString__credential"              = "managedidentity"
    "ServiceBusConnectionString__clientId"                = azurerm_user_assigned_identity.function.client_id
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.function.connection_string
  }
}
resource "azurerm_application_insights" "function" {
  name                = "${var.function_app_name}-insights"
  location            = var.function_location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}
resource "azurerm_role_assignment" "function_servicebus_receiver" {
  scope                = azurerm_servicebus_queue.orders.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.function.principal_id
}
resource "azurerm_user_assigned_identity" "function" {
  name                = "${var.function_app_name}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.function_location
}