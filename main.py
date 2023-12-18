import subprocess
import json

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

# Call the function to check if logged in and login if necessary
az_login()

# Initier terraform
terraform_init_command = "terraform init"
subprocess.run(terraform_init_command, shell=True, check=True)

#  Creer l'infrastructure
terraform_apply_command = "terraform apply -auto-approve"
subprocess.run(terraform_apply_command, shell=True, check=True)

# Recuperer l'IP publique
terraform_output_command = "terraform output -json"
terraform_output = subprocess.run(terraform_output_command, shell=True, capture_output=True, text=True, check=True)
terraform_output_json = json.loads(terraform_output.stdout)
ip_publique = terraform_output_json['ip_publique']['value']



#  Detruire l'infrastructure
# yes | terraform destroy
subprocess.run("terraform destroy", shell=True, check=True)
subprocess.run(terraform_apply_command, shell=True, check=True)
  


