#!/bin/bash

# Variables pour stocker les choix de l'utilisateur
selected_platform=""
selected_machine=""
selected_attack=""
selected_hash_type=""
selected_hash=""

############## Hash ##############
read -p "Enter the hash: " hash
selected_hash=$hash


############## Platform ##############
display_main_menu() {
    clear
    echo "Welcome! Choose a platform to deploy the tool:"
    echo "1. AWS"
    echo "2. Azure"
    echo "3. Quit"
}

############## Machine type (AWS) ##############
display_aws_machine_menu() {
    clear
    echo "Choose the type of machine to deploy for AWS:"
    echo "1. t2.micro (1 vCPU, 1 GB RAM)"
    echo "2. t2.small (1 vCPU, 2 GB RAM)"
    echo "3. t2.medium (2 vCPU, 4 GB RAM)"
    echo "4. t2.large (2 vCPU, 8 GB RAM)"
    echo "5. Return to main menu"
}

############## Machine type (Azure) ##############
display_azure_machine_menu() {
    clear
    echo "Choose the type of machine to deploy for Azure:"
    echo "1. Standard_B1s (1 vCPU, 1 GB RAM)"
    echo "2. Standard_B1ms (1 vCPU, 2 GB RAM)"
    echo "3. Standard_B2s (2 vCPU, 4 GB RAM)"
    echo "4. Standard_B2ms (2 vCPU, 8 GB RAM)"
    echo "5. Return to main menu"
}

############## Attack type ##############
display_attack_menu() {
    clear
    echo "Choose the type of attack:"
    echo "1. Dictionary attack"
    echo "2. Combinator attack"
    echo "3. Brute-force attack"
    echo "4. Hybrid attack"
    echo "5. Association attack"
    echo "6. Return to previous menu"
}

############## Hash type ##############
display_hash_menu() {
    clear
    echo "Choose the type of hash:"
    echo "1. MD5"
    echo "2. SHA1"
    echo "3. Return to previous menu"
}

############## Main logic ##############
while true; do
    display_main_menu

    read -p "Your choice: " main_choice

    case $main_choice in
        1) # AWS
            selected_platform="AWS"
            display_aws_machine_menu
            read -p "Your choice: " machine_choice
            case $machine_choice in
                1) selected_machine="t2.micro" ;;
                2) selected_machine="t2.small" ;;
                3) selected_machine="t2.medium" ;;
                4) selected_machine="t2.large" ;;
                5) continue ;;
                *) echo "Invalid choice. Please choose a valid option." ;;
            esac
            ;;
        2) # Azure
            selected_platform="Azure"
            display_azure_machine_menu
            read -p "Your choice: " machine_choice
            case $machine_choice in
                1) selected_machine="Standard_B1s" ;;
                2) selected_machine="Standard_B1ms" ;;
                3) selected_machine="Standard_B2s" ;;
                4) selected_machine="Standard_B2ms" ;;
                5) continue ;;
                *) echo "Invalid choice. Please choose a valid option." ;;
            esac
            ;;
        3) # Quit
            echo "Goodbye!"
            exit 0
            ;;
        *) # Invalid choice
            echo "Invalid choice. Please choose a valid option."
            sleep 2
            ;;
    esac

    # Check if both platform and machine are selected
    if [[ -n $selected_platform && -n $selected_machine ]]; then
        break
    fi
done

display_attack_menu
read -p "Your choice: " selected_attack

case $selected_attack in
    1) # Dictionary attack
        attack_argument="-a 0"
        ;;
    2) # Combinator attack
        attack_argument="-a 1"
        ;;
    3) # Brute-force attack
        attack_argument="-a 3"
        ;;
    4) # Hybrid attack
        attack_argument="-a 6"
        ;;
    5) # Association attack
        attack_argument="-a 9"
        ;;
    6) # Return to previous menu
        ;;
    *) # Invalid choice
        echo "Invalid choice. Please choose a valid option."
        ;;
esac

if [ "$selected_attack" != "6" ]; then
    display_hash_menu
    read -p "Your choice: " selected_hash_type

    case $selected_hash_type in
        1) # MD5
            hash_argument="-m 0"
            ;;
        2) # SHA1
            hash_argument="-m 100"
            ;;
        3) # Other hash type
            # Add logic for other hash types here
            ;;
        4) # Return to previous menu
            ;;
        *) # Invalid choice
            echo "Invalid choice. Please choose a valid option."
            ;;
    esac
fi


# Print the selected options
echo "Platform: $selected_platform"
echo "Machine: $selected_machine"
echo "Attack: $attack_argument"
echo "Hash Type: $hash_argument"


############## Execution #############

# Send the selected options to the corresponding script
if [ "$selected_platform" = "Azure" ]; then
    # Remplacer les valeurs des variables dans le fichier azure.py
    sed -i "s/selected_machine = .*/selected_machine = \"$selected_machine\"/" azure.py
    sed -i "s/attack_argument = .*/attack_argument = \"$attack_argument\"/" azure.py
    sed -i "s/hash_argument = .*/hash_argument = \"$hash_argument\"/" azure.py
    sed -i "s/hash = .*/hash = \"$hash\"/" azure.py
    python3 azure.py
else if 
    [ "$selected_platform" = "AWS" ]; then
        sed -i "s/selected_machine = .*/selected_machine = \"$selected_machine\"/" aws.py
        sed -i "s/attack_argument = .*/attack_argument = \"$attack_argument\"/" aws.py
        sed -i "s/hash_argument = .*/hash_argument = \"$hash_argument\"/" aws.py
        sed -i "s/hash = .*/hash = \"$hash\"/" aws.py
        # python3 aws.py
    fi
fi

