# Update linux packages
sudo apt-get -y update

# Install terraform and azure CLI reuqirements 
sudo apt install -y gnupg software-properties-common curl wget


# Install azure cli 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 

# Install terraform

## install hashicorp gpg key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

## Get the fingerprint
fingerprint=$(gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint)
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

## Update the package list to include the hashicorp repository
sudo apt update

## apt install terraform
sudo apt install -y terraform

## Remove the hashicorp.list file because it is not needed anymore
rm /etc/apt/sources.list.d/hashicorp.list


# Test the installation

## Test terraform
terraform_help=$(terraform -help)
expected="Usage: terraform"
if [[ $terraform_help != *"$expected"* ]]; then
    echo "Error: Terraform is not correctly installed."
    exit 1
fi

## Test azure cli
az_help=$(az -help)
expected="Group
    az"
if [[ $az_help != *"$expected"* ]]; then
    echo "Error: Azure CLI is not correctly installed."
    exit 1
fi


