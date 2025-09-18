provider "azurerm" {
  features {}
  subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}
module "rg" {
  source   = "./modules/rg"
  name     = var.rg_name
  location = var.location
}
module "vnet" {
  source              = "./modules/vnet"
  name                = var.vnet_name
  location            = var.location
  resource_group_name = module.rg.name
}

module "subnet" {
  source              = "./modules/subnet"
  name                = "${var.vnet_name}-subnet"
  vnet_name           = module.vnet.name
  resource_group_name = module.rg.name
  nsg_id	      = module.nsg.id
}
module "nsg" {
  source              = "./modules/nsg"
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = module.rg.name
}
data "azurerm_key_vault" "kv" {
  name                = "prmyKeyVaulttfstate1"
  resource_group_name = "tfstate-rg1"
}
data "azurerm_key_vault_secret" "vm_username" {
  name         = "vm-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}
module "vm" {
  source              = "./modules/vm"
  name                = var.vm_name
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = module.subnet.id
  admin_username      = data.azurerm_key_vault_secret.vm_username.value
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
}