provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "sub1"
  subscription_id = local.subscription_id_1
  features {}
}

provider "azurerm" {
  alias           = "sub2"
  subscription_id = local.subscription_id_2
  features {}
}