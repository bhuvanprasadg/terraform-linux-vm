# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = {
      Environment = "Terraform Getting Started"
      Team        = "DevOps"
  }
}

#create a virtual network in that resource group
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

#create a subnet in that virtual network
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name_1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_name_1_address_space
}

#Create a public IP
resource "azurerm_public_ip" "publicip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation
}

#create an NIC
resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.network_interface_ip_config_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation

    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#Create Network Security Groups
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    access                      = "Allow"
    destination_address_prefix  = "*"
    destination_port_range      = "22"
    direction                   = "Inbound"
    name                        = "SSH"
    priority                    = 100
    protocol                    = "Tcp"
    source_address_prefix       = "*"
    source_port_range           = "*"
  }

  security_rule {
    access                      = "Allow"
    destination_address_prefix  = "*"
    destination_port_range      = "80"
    direction                   = "Inbound"
    name                        = "HTTP"
    priority                    = 150
    protocol                    = "Tcp"
    source_address_prefix       = "*"
    source_port_range           = "*"
  }
  
}

#Integrate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#create and display an SSH key
resource "tls_private_key" "pemkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create a linux virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.virtual_machine_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_ssh_key_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  admin_ssh_key {
    username   = var.admin_ssh_key_username
    public_key = tls_private_key.pemkey.public_key_openssh
  }
}