variable "resource_group_name" {
    default = "myTFResourceGroup"
}

variable "location" {
    default = "centralindia"
}

variable "virtual_network_name" {
    default = "myTFVirtualNetwork"
}

variable "virtual_network_address_space" {
    default = ["10.0.0.0/16"]
}

variable "subnet_name_1" {
    default = "myTFSubnet1"
}

variable "subnet_name_1_address_space" {
    default = ["10.0.1.0/24"]
}

variable "public_ip_name" {
    default = "vm_public_ip"
}

variable "public_ip_allocation" {
    default = "Static"
}

variable "network_interface_name" {
    default = "networkInterface"
}

variable "network_interface_ip_config_name" {
    default = "networkInterfaceIPConfig"
}

variable "private_ip_address_allocation" {
    default = "Dynamic"
}

variable "nsg_name" {
    default = "myTFNSG"
}

variable "virtual_machine_name" {
    default = "myTFVM"
}

variable "virtual_machine_size" {
    default = "Standard_F2"
}

variable "virtual_machine_user_name" {
    default = "adminuser"
}

variable "virtual_machine_password" {
    default = "Password1234!"
}

variable "os_disk_caching" {
    default = "ReadWrite"
}   

variable "os_disk_storage_account_type" {
    default = "Standard_LRS"
}

variable "source_image_reference_publisher" {
    default = "Canonical"
}

variable "source_image_reference_offer" {
    default = "UbuntuServer"
}

variable "source_image_reference_sku" {
    default = "18.04-LTS"
}

variable "source_image_reference_version" {
    default = "latest"
}

variable "admin_ssh_key_username" {
    default = "adminuser"
}