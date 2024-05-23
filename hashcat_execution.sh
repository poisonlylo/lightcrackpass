#!/bin/bash
public_ip="172.211.80.137"
attack_argument="-a 0"
hash_argument="-m 0"
hash="5f4dcc3b5aa765d61d8327deb882cf99"
username="rootty"
password="cWcaKkjULvS5zyFPChhR"


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
