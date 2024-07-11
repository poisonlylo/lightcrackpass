import subprocess
import json
import random
import string

######################################
############## FUNCTIONS #############
######################################

############## FUNCTION : Generate password #############
def generate_password():
  # Define the pool of characters to choose from
    characters = string.ascii_letters + string.digits
    
    # Generate the password by randomly choosing characters from the pool
    password = ''.join(random.choice(characters) for _ in range(20))
    
    return password

############## FUNCTION : Azure Login #############
def az_login():
    try:
        # Check if there are any existing subscriptions
        check_command = ['az', 'account', 'list', '--output', 'json']
        check_result = subprocess.run(check_command, capture_output=True, text=True, check=True)

        # Load the JSON output
        subscriptions = json.loads(check_result.stdout)

        if subscriptions:
            print("You are already logged in to Azure. No need to run 'az login'.")
            return

        # If there are no subscriptions, execute 'az login'
        login_command = ['az', 'login', '--output', 'json']
        result = subprocess.run(login_command, capture_output=True, text=True, check=True)

        # Load the JSON output
        output_json = json.loads(result.stdout)

        # Extract the session_id if present
        session_id = output_json.get('sessionId')

        if session_id:
            print(f"Azure CLI login successful. Session ID: {session_id}")
        else:
            print("Session ID not found in the login response.")

    except subprocess.CalledProcessError as e:
        print(f"Azure CLI login failed. Error: {e}")

############## FUNCTION : Generate Terraform file #############
def generate_terraform_file(machine_type, password):
    tf_content = f'''
# Resources required to create a virtual machine in Azure
# 1. Os disk
# 2. Data disk
# 3. VNET 
# 4. Subnet
# 5. vNIC
# 6. Public IP
# 7. NSG (Network Security Group)

# Provider
provider "azurerm" {{
  skip_provider_registration = true 
  features {{}}
}}

# Resource Group
resource "azurerm_resource_group" "lightcrackpass" {{
  name     = "lightcrackpass-resource-group"
  location = "West Europe"
}}

# Virtual Network
resource "azurerm_virtual_network" "lightcrackpass" {{
  name                = "lightcrackpass-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name
}}

# Subnet
resource "azurerm_subnet" "lightcrackpass" {{
  name                 = "lightcrackpass-subnet"
  resource_group_name  = azurerm_resource_group.lightcrackpass.name
  virtual_network_name = azurerm_virtual_network.lightcrackpass.name
  address_prefixes    = ["10.0.1.0/24"]
}}

# Public IP
resource "azurerm_public_ip" "lightcrackpass" {{
  name                = "lightcrackpass-public-ip"
  resource_group_name = azurerm_resource_group.lightcrackpass.name
  location            = azurerm_resource_group.lightcrackpass.location
  allocation_method   = "Dynamic"
}}

# Network interface Card
resource "azurerm_network_interface" "lightcrackpass" {{
  name                = "lightcrackpass-nic"
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name

  ip_configuration {{
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lightcrackpass.id
    private_ip_address_allocation = "Dynamic"
    # Associate the public IP address with the NIC
    public_ip_address_id = azurerm_public_ip.lightcrackpass.id
  }}
}}

# Network security group
resource "azurerm_network_security_group" "lightcrackpass" {{
  name                = "lightcrackpass-nsg"
  location            = azurerm_resource_group.lightcrackpass.location
  resource_group_name = azurerm_resource_group.lightcrackpass.name

  security_rule {{
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }}
}}

# Virtual Machine + OS Disk 
resource "azurerm_linux_virtual_machine" "lightcrackpass" {{
  name                = "lightcrackpass_debian11"
  resource_group_name = azurerm_resource_group.lightcrackpass.name
  location            = azurerm_resource_group.lightcrackpass.location
  size                = "{machine_type}"

  network_interface_ids = [azurerm_network_interface.lightcrackpass.id]

  admin_username = "rootty"
  admin_password = "{password}"  

  os_disk {{
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }}

  source_image_reference {{
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }}

  computer_name  = "lightcrackpass"
  disable_password_authentication = false
}}

output "resource_group_name" {{
  value = azurerm_resource_group.lightcrackpass.name
}}

output "public_ip_address" {{
  value = azurerm_linux_virtual_machine.lightcrackpass.public_ip_address
}}
'''
    with open("azure_vm.tf", "w") as f:
        f.write(tf_content)

############## FUNCTION : Generate the hashcat_execution.sh script ############
def generate_hashcat_execution_script():
    script_content = """
# Install sshpass
sudo apt-get install sshpass

# Establish SSH connection and execute commands on the remote server
sshpass -p "$password" ssh -o "StrictHostKeyChecking=no" $username@$public_ip << EOF
    echo "Connection to the server $public_ip is successful"

    # Update package list and install hashcat
    
    sudo apt-get install hashcat -y

    # Download and decompress the rockyou wordlist
    wget https://github.com/praetorian-inc/Hob0Rules/raw/5634e5c1d05d08704243b8b8707b90b809a4069c/wordlists/rockyou.txt.gz
    gunzip rockyou.txt.gz
    
    # Run hashcat with provided arguments
    hashcat $hash $attack_argument $hash_argument rockyou.txt -o cracked_hash.txt --force
    
EOF

sshpass -p "$password" sftp -o "StrictHostKeyChecking=no" $username@$public_ip << EOF
    get cracked_hash.txt
EOF

# Display only the cracked hash without the hash

echo "The cracked hash is:"
cat cracked_hash.txt | cut -d ":" -f 2
rm cracked_hash.txt

# End of the script
"""
    with open("hashcat_execution.sh", "w") as f:
      
        f.write(f'#!/bin/bash\n')
        f.write(f'public_ip="{public_ip}"\n')
        f.write(f'attack_argument="{attack_argument}"\n')
        f.write(f'hash_argument="{hash_argument}"\n')
        f.write(f'hash="{hash}"\n')
        f.write(f'username="{username}"\n')
        f.write(f'password="{password}"\n')
        f.write("\n")
        f.write(script_content)



######################################
############## MAIN #############
######################################

############## Variables #############
username = "rootty"
password = generate_password()
selected_machine = "Standard_B1s"
attack_argument = "-a 0"
hash_argument = "-m 0"
hash = "5f4dcc3b5aa765d61d8327deb882cf99"


############# Login to Azure #############
az_login()


############# Generate the Terraform file #############
generate_terraform_file(selected_machine, password)


############# Initialize Terraform #############
terraform_init_command = "terraform init"
subprocess.run(terraform_init_command, shell=True, check=True)


#############  Create the VM using Terraform #############
terraform_apply_command = "terraform apply -auto-approve"
subprocess.run(terraform_apply_command, shell=True, check=True)


############# Get the public IP address of the VM #############
terraform_output_command = "terraform output -json"
output = subprocess.run(terraform_output_command, shell=True, capture_output=True, text=True, check=True)
output_json = json.loads(output.stdout)
public_ip_info = output_json.get("public_ip_address") 
public_ip = public_ip_info.get("value")


############# Generate the hashcat_execution.sh script #############
generate_hashcat_execution_script()


############# Execute the script #############
subprocess.run("bash hashcat_execution.sh", shell=True, check=True)
    

############# Destroy the infrastructure #############
subprocess.run("terraform destroy -auto-approve", shell=True, check=True)
subprocess.run(terraform_apply_command, shell=True, check=True)
  


