
# Resources required to create a virtual machine in Azure
# 1. Os disk
# 2. Data disk
# 3. VNET 
# 4. Subnet
# 5. vNIC
# 6. Public IP
# 7. NSG (Network Security Group)

# Provider
provider "azurerm" {
  skip_provider_registration = true 
  features {}
}

# Resource Group
resource "azurerm_resource_group" "lightcrackpass" {
  name     = "lightcrackpass-resource-group"
  location = "West Europe"
}

# Virtual Network
resource "azurerm_virtual_network" "lightcrackpass" {
  name                = "lightcrackpass-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name
}

# Subnet
resource "azurerm_subnet" "lightcrackpass" {
  name                 = "lightcrackpass-subnet"
  resource_group_name  = azurerm_resource_group.lightcrackpass.name
  virtual_network_name = azurerm_virtual_network.lightcrackpass.name
  address_prefixes    = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "lightcrackpass" {
  name                = "lightcrackpass-public-ip"
  resource_group_name = azurerm_resource_group.lightcrackpass.name
  location            = azurerm_resource_group.lightcrackpass.location
  allocation_method   = "Dynamic"
}

# Network interface Card
resource "azurerm_network_interface" "lightcrackpass" {
  name                = "lightcrackpass-nic"
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lightcrackpass.id
    private_ip_address_allocation = "Dynamic"
    # Associate the public IP address with the NIC
    public_ip_address_id = azurerm_public_ip.lightcrackpass.id
  }
}

# Network security group
resource "azurerm_network_security_group" "lightcrackpass" {
  name                = "lightcrackpass-nsg"
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Virtual Machine + OS Disk 
resource "azurerm_linux_virtual_machine" "lightcrackpass" {
  name                = "lightcrackpass_debian11"
  resource_group_name = azurerm_resource_group.lightcrackpass.name
  location            = azurerm_resource_group.lightcrackpass.location
  size                = "Standard ND6s v2"

  network_interface_ids = [azurerm_network_interface.lightcrackpass.id]

  admin_username = "rootty"
  admin_password = "jYPi:V]4Pm!0*?,GDX%i"  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  computer_name  = "lightcrackpass"
  disable_password_authentication = false
}

output "resource_group_name" {
  value = azurerm_resource_group.lightcrackpass.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.lightcrackpass.public_ip_address
}
