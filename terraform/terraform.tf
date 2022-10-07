terraform {
  required_version = ">= 1.3.1"

  backend "azurerm" {
    container_name = "aytp-tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.25.0"
    }
  }
}