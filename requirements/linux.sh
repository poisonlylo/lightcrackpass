# Update linux packages
sudo apt-get -y update

# Install azure cli 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 

# Test azure cli
az_help=$(az -help)
expected="Group
    az"
if [[ $az_help != *"$expected"* ]]; then
    echo "Error: Azure CLI is not correctly installed."
    exit 1
fi

# Install terraform reuqirements
sudo apt install -y gnupg software-properties-common curl wget

# install hashicorp gpg key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Get the fingerprint
fingerprint=$(gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint)

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

# Install terraform
sudo apt install -y terraform

rm /etc/apt/sources.list.d/hashicorp.list

# Run terraform -help
terraform_help=$(terraform -help)

# Expected output
expected="Usage: terraform"

# Check if the output matches the expected one
if [[ $terraform_help != *"$expected"* ]]; then
    echo "Error: Terraform is not correctly installed."
    exit 1
fi


