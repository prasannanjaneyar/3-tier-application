terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg1"
    storage_account_name = "prstoragetfstate1" 
    container_name       = "tfstate" 
    key                  = "3tier/dev.terraform.tfstate"
  }
}