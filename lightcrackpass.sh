#!/bin/bash

# Directory for documentation files
DOC_DIR="docs"

# Display help message
display_help() {
    echo "Usage: $0 -p PLATFORM -m MACHINE -a ATTACK -t HASH_TYPE -h HASH [-d ARGUMENT]"
    echo
    echo "  -p PLATFORM    Platform to deploy the tool (aws or azure)"
    echo "  -m MACHINE     Type of machine to deploy"
    echo "  -a ATTACK      Type of attack"
    echo "  -t HASH_TYPE   Type of hash"
    echo "  -h HASH        Hash to crack"
    echo "  -d ARGUMENT    Display documentation for the given argument (platform, machine, attack, hash_type, hash)"
    echo
    echo "Example:"
    echo "  $0 -p AWS -m t2.micro -a 0 -t 0 -h your_hash_here"
    echo
    echo "Documentation example:"
    echo "  $0 -d platform"
    exit 1
}

# Display documentation
display_documentation() {
    local arg=$1
    local doc_file="$DOC_DIR/$arg.txt"

    if [[ -f $doc_file ]]; then
        cat "$doc_file"
    else
        echo "No documentation available for '$arg'."
    fi
    exit 0
}

# Parse command line arguments
while getopts "p:m:a:t:h:d:" opt; do
    case ${opt} in
        p)
            selected_platform=$OPTARG
            ;;
        m)
            selected_machine=$OPTARG
            ;;
        a)
            attack_argument=$OPTARG
            ;;
        t)
            hash_argument=$OPTARG
            ;;
        h)
            selected_hash_argument=$OPTARG
            ;;
        d)
            display_documentation $OPTARG
            ;;
        *)
            display_help
            ;;
    esac
done

# If the selected hash argument is a file, read its content
if [[ -f $selected_hash_argument ]]; then
    selected_hash=$(<"$selected_hash_argument")
else
    selected_hash=$selected_hash_argument
fi

# Validate required arguments
if [[ -z $selected_platform || -z $selected_machine || -z $attack_argument || -z $hash_argument || -z $selected_hash ]]; then
    echo "All options are required."
    display_help
fi

# Map attack types to arguments
case $attack_argument in
    0)
        attack_argument="-a 0" # Dictionary attack
        ;;
    1)
        attack_argument="-a 1" # Combinator attack
        ;;
    3)
        attack_argument="-a 3" # Brute-force attack
        ;;
    6)
        attack_argument="-a 6" # Hybrid attack
        ;;
    9)
        attack_argument="-a 9" # Association attack
        ;;
    *)
        echo "Invalid attack type."
        display_help
        ;;
esac

Bien sûr, voici le cas que vous avez demandé :

bash

# Map machine types to arguments
case $selected_machine in
    0)
        selected_machine="-m 1" # Standard NC6s v3
        ;;
    1)
        selected_machine="-m 2" # Standard ND6s v2
        ;;
    2)
        selected_machine="-m 3" # Standard NV32as v4
        ;;
    3)
        selected_machine="-m 4" # Standard NC12s v3
        ;;
    4)
        selected_machine="-m 5" # Standard NC24s v3
        ;;
    *)
        echo "Invalid machine selected. Please choose a number between 1 and 5."
        ;;
esac


# Map hash types to arguments
case $hash_argument in
    0)
        hash_argument="-m 0" # MD5
        ;;
    100)
        hash_argument="-m 100" # SHA1
        ;;
    1300)
        hash_argument="-m 1300" # SHA2-224
        ;;
    1400)
        hash_argument="-m 1400" # SHA2-256
        ;;
    10800)
        hash_argument="-m 10800" # SHA2-384
        ;;
    1700)
        hash_argument="-m 1700" # SHA2-512
        ;;
    17300)
        hash_argument="-m 17300" # SHA3-224
        ;;
    17400)
        hash_argument="-m 17400" # SHA3-256
        ;;
    17500)
        hash_argument="-m 17500" # SHA3-384
        ;;
    17600)
        hash_argument="-m 17600" # SHA3-512
        ;;
    6000)
        hash_argument="-m 6000" # RIPEMD-160
        ;;
    600)
        hash_argument="-m 600" # BLAKE2b-512
        ;;
    11700)
        hash_argument="-m 11700" # GOST R 34.11-2012 (Streebog) 256-bit, big-endian
        ;;
    11800)
        hash_argument="-m 11800" # GOST R 34.11-2012 (Streebog) 512-bit, big-endian
        ;;
    6900)
        hash_argument="-m 6900" # GOST R 34.11-94
        ;;
    17010)
        hash_argument="-m 17010" # GPG (AES-128/AES-256 (SHA-1($pass)))
        ;;
    5100)
        hash_argument="-m 5100" # Half MD5
        ;;
    17700)
        hash_argument="-m 17700" # Keccak-224
        ;;
    17800)
        hash_argument="-m 17800" # Keccak-256
        ;;
    17900)
        hash_argument="-m 17900" # Keccak-384
        ;;
    18000)
        hash_argument="-m 18000" # Keccak-512
        ;;
    6100)
        hash_argument="-m 6100" # Whirlpool
        ;;
    10100)
        hash_argument="-m 10100" # SipHash
        ;;
    70)
        hash_argument="-m 70" # md5(utf16le($pass))
        ;;
    170)
        hash_argument="-m 170" # sha1(utf16le($pass))
        ;;
    1470)
        hash_argument="-m 1470" # sha256(utf16le($pass))
        ;;
    10870)
        hash_argument="-m 10870" # sha384(utf16le($pass))
        ;;
    1770)
        hash_argument="-m 1770" # sha512(utf16le($pass))
        ;;
    610)
        hash_argument="-m 610" # BLAKE2b-512($pass.$salt)
        ;;
    620)
        hash_argument="-m 620" # BLAKE2b-512($salt.$pass)
        ;;
    10)
        hash_argument="-m 10" # md5($pass.$salt)
        ;;
    20)
        hash_argument="-m 20" # md5($salt.$pass)
        ;;
    3800)
        hash_argument="-m 3800" # md5($salt.$pass.$salt)
        ;;
    3710)
        hash_argument="-m 3710" # md5($salt.md5($pass))
        ;;
    4110)
        hash_argument="-m 4110" # md5($salt.md5($pass.$salt))
        ;;
    4010)
        hash_argument="-m 4010" # md5($salt.md5($salt.$pass))
        ;;
    21300)
        hash_argument="-m 21300" # md5($salt.sha1($salt.$pass))
        ;;
    40)
        hash_argument="-m 40" # md5($salt.utf16le($pass))
        ;;
    2600)
        hash_argument="-m 2600" # md5(md5($pass))
        ;;
    3910)
        hash_argument="-m 3910" # md5(md5($pass).md5($salt))
        ;;
    3500)
        hash_argument="-m 3500" # md5(md5(md5($pass)))
        ;;
    4400)
        hash_argument="-m 4400" # md5(sha1($pass))
        ;;
    4410)
        hash_argument="-m 4410" # md5(sha1($pass).$salt)
        ;;
    20900)
        hash_argument="-m 20900" # md5(sha1($pass).md5($pass).sha1($pass))
        ;;
    21200)
        hash_argument="-m 21200" # md5(sha1($salt).md5($pass))
        ;;
    4300)
        hash_argument="-m 4300" # md5(strtoupper(md5($pass)))
        ;;
    30)
        hash_argument="-m 30" # md5(utf16le($pass).$salt)
        ;;
    110)
        hash_argument="-m 110" # sha1($pass.$salt)
        ;;
    120)
        hash_argument="-m 120" # sha1($salt.$pass)
        ;;
    4900)
        hash_argument="-t 4900" # sha1($salt.$pass.$salt)
        ;;
    4520)
        hash_argument="-t 4520" # sha1($salt.sha1($pass))
        ;;
    24300)
        hash_argument="-t 24300" # sha1($salt.sha1($pass.$salt))
        ;;
    140)
        hash_argument="-t 140" # sha1($salt.utf16le($pass))
        ;;
    19300)
        hash_argument="-t 19300" # sha1($salt1.$pass.$salt2)
        ;;
    14400)
        hash_argument="-t 14400" # sha1(CX)
        ;;
    4700)
        hash_argument="-t 4700" # sha1(md5($pass))
        ;;
    *)
        echo "Invalid hash type."
        display_help
        ;;
esac

# Print the selected options
echo "Platform: $selected_platform"
echo "Machine: $selected_machine"
echo "Attack: $attack_argument"
echo "Hash Type: $hash_argument"
echo "Hash: $selected_hash"

############## Execution #############

# Send the selected options to the corresponding script
if [ "$selected_platform" = "azure" ]; then
    # Remplacer les valeurs des variables dans le fichier azure.py
    sed -i "s/selected_machine = .*/selected_machine = \"$selected_machine\"/" azure.py
    sed -i "s/attack_argument = .*/attack_argument = \"$attack_argument\"/" azure.py
    sed -i "s/hash_argument = .*/hash_argument = \"$hash_argument\"/" azure.py
    sed -i "s/hash = .*/hash = \"$selected_hash\"/" azure.py
    python3 azure.py
elif [ "$selected_platform" = "aws" ]; then
    sed -i "s/selected_machine = .*/selected_machine = \"$selected_machine\"/" aws.py
    sed -i "s/attack_argument = .*/attack_argument = \"$attack_argument\"/" aws.py
    sed -i "s/hash_argument = .*/hash_argument = \"$hash_argument\"/" aws.py
    sed -i "s/hash = .*/hash = \"$selected_hash\"/" aws.py
    # python3 aws.py
else
    echo "Invalid platform."
    display_help
fi
