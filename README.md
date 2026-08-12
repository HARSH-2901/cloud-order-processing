# ☁️ Cloud Order Processing System

A cloud-native, event-driven order processing system built using **.NET 10, Azure Service Bus, Azure Functions, Terraform, GitHub Actions, Managed Identity, and Azure RBAC**.

The system demonstrates how an order can be submitted through a REST API, published asynchronously to an Azure Service Bus queue, and automatically processed by an Azure Function.

The Azure infrastructure is provisioned using **Terraform**, while application deployment is automated using **GitHub Actions CI/CD with OIDC authentication**.

---

## 🏗️ Architecture

```mermaid
flowchart TD
    A[Developer] -->|git push| B[GitHub Actions]

    B -->|OIDC Authentication| C[Microsoft Azure]

    C --> D[Order API<br/>.NET 10]
    C --> E[Azure Function<br/>.NET 10<br/>ProcessOrder]

    D -->|Send Order| F[Azure Service Bus<br/>orders queue]

    F -->|Service Bus Trigger| E

    E -->|User-Assigned Managed Identity| G[Microsoft Entra ID]

    G -->|RBAC Authorization<br/>Data Receiver| F



## 🔄 Order Processing Flow
```text
    Client
  │
  │ HTTP POST
  ▼
Order API
  │
  │ JSON message
  ▼
Azure Service Bus
  │
  │ orders queue
  ▼
Azure Function
  │
  │ ProcessOrder
  ▼
Order processed


## 🛠️ Technologies Used

Backend

* C#
* .NET 10
* ASP.NET Core Web API
* Azure Functions .NET Isolated Worker

Messaging

* Azure Service Bus
* Service Bus Queue
* Azure.Messaging.ServiceBus

Cloud

* Microsoft Azure
* Azure Functions
* Azure Service Bus
* Azure Storage Account
* Azure Service Plan
* Application Insights
* Microsoft Entra ID
* Managed Identity
* Azure RBAC

Infrastructure as Code

* Terraform
* AzureRM Terraform Provider

CI/CD

* GitHub Actions
* GitHub OIDC
* Azure Workload Identity Federation

Monitoring

* Application Insights
* OpenTelemetry
* Azure Monitor


## ☁️ Azure Infrastructure

Azure Resource Group
│
├── Azure Function App
│
├── Azure Service Plan
│
├── Azure Storage Account
│
├── Azure Service Bus Namespace
│   └── orders queue
│
├── User-Assigned Managed Identity
│
├── Azure RBAC Role Assignment
│
└── Application Insights



## 🔐 Security Architecture


Azure Function
      │
      │ User-Assigned Managed Identity
      ▼
Microsoft Entra ID
      │
      │ Access Token
      ▼
Azure Service Bus
      │
      │ Azure RBAC
      ▼
orders queue


## 🏗️ Terraform
Terraform is used to provision and manage the Azure infrastructure as code.


```bash
terraform init
terraform validate
terraform plan
terraform apply


A clean check should show


```markdown
No changes. Your infrastructure matches the configuration.



## 🔄 CI/CD

GitHub Actions automatically builds and deploys the application to Azure.

Git Push
   ↓
GitHub Actions
   ↓
OIDC Authentication
   ↓
Azure
   ↓
Application Deployment




## 🔑 Managed Identity & RBAC

The Azure Function uses a User-Assigned Managed Identity to authenticate with Azure Service Bus.

The identity is assigned:
Azure Service Bus Data Receiver


## 🧪 End-to-End Testing

Initial queue state:
Active    DeadLetter
--------  ------------
1         0

After processing:
Active    DeadLetter
--------  ------------
0         0

complete Flow:

Order API
   ↓
Azure Service Bus
   ↓
orders queue
   ↓
Azure Function
   ↓
Managed Identity + RBAC
   ↓
Order processed successfully

```markdown
##📌 Future Improvements

* Persistent order database
* Retry and dead-letter handling
* Idempotent message processing
* Automated unit and integration tests
* API authentication
* Production and staging environments
* Application Insights dashboards