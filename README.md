# terraform-azurerm-vnetpeering

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-vnetpeering.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-vnetpeering)

## Create Virtual Network Peerings between two Virtual Networks
This module helps create virtual network peering across same region, different region and different subscriptions too. Virtual network peering enables you to seamlessly connect two Azure virtual networks. Once peered, the virtual networks appear as one, for connectivity purposes. The traffic between virtual machines in the peered virtual networks is routed through the Microsoft backbone infrastructure, much like traffic is routed between virtual machines in the same virtual network, through private IP addresses only. Azure supports:

- VNet peering - connecting VNets within the same Azure region
- Global VNet peering - connecting VNets across Azure regions
- Cross Subscription peering - connecting VNets across different subscriptions

## Usage


```hcl
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

# First VNET
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

# Second VNET
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

# Creates VNET peerings from First VNET to Second VNET and also from Second VNET to First VNET
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


```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native (Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install
$ rake build
$ rake e2e
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `microsoft/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-vnetpeering .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-vnetpeering /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-vnetpeering /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-vnetpeering /bin/bash -c "bundle install && rake full"
```

## Authors

Originally created by [Vaijanath Angadihiremath](http://github.com/VaijanathB)

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
