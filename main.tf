provider "azurerm" {
    //version = "2.5.0"
    //version = "2.78.0"
    features {}

    subscription_id = "46f20b79-9fea-4656-a373-a64451d8ce86"
    client_id       = "f42fb729-f563-4794-ada0-8e93663042c2"
    client_secret   = var.client_secret
    tenant_id       = "c63ce2df-d365-478d-9667-2d7b2ddbd810"
}

terraform {
    backend "azurerm" {
        resource_group_name  = "TERRAFORM-RGP"
        storage_account_name = "stterraformtester"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

variable "client_secret" {
  type = string
}


resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "East US"
}

resource "azurerm_container_group" "tfcg_test" {
  name                      = "weatherapi"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name

  ip_address_type     = "public"
  dns_name_label      = "venusiianweatherapi"
  os_type             = "Linux"

  container {
      name            = "weatherapi"
      image           = "venusiian/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}