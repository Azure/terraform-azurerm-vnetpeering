resource "random_id" "rg_name1" {
  byte_length = 8
}

resource "random_id" "rg_name2" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg1" {
  name     = random_id.rg_name1.hex
  location = var.location1
}

resource "azurerm_resource_group" "rg2" {
  name     = random_id.rg_name2.hex
  location = var.location2
}

module "network1" {
  source              = "Azure/network/azurerm"
  resource_group_name = random_id.rg_name1.hex
  location            = var.location1
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}

module "network2" {
  source              = "Azure/network/azurerm"
  resource_group_name = random_id.rg_name2.hex
  location            = var.location2
  address_space       = "10.2.0.0/16"
  subnet_prefixes     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}

module "vnetpeering" {
  source               = "../.."
  vnet_peering_names   = ["vnetpeering1", "vnetpeering2"]
  vnet_names           = [module.network1.vnet_name, module.network2.vnet_name]
  resource_group_names = [random_id.rg_name1.hex, random_id.rg_name2.hex]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
