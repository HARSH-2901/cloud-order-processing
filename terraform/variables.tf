variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-cloud_order_processing"
}

variable "resource_group_location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "centralindia"
}

variable "service_bus_name" {
  description = "Name of the Service Bus namespace"
  type        = string
  default     = "sb-cloud-order-processing"
}

variable "service_bus_location" {
  description = "Azure region for the Service Bus namespace"
  type        = string
  default     = "uaenorth"
}

variable "service_bus_queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "orders"
}
variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string
  default     = "fn-order-processor"
}

variable "function_storage_name" {
  description = "Name of the storage account used by the Function App"
  type        = string
  default     = "storderprocessor2026"
}

variable "function_location" {
  description = "Azure region for the Function App"
  type        = string
  default     = "uaenorth"
}