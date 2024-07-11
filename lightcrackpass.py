import argparse
import subprocess
import sys
import re
import random

def replace_variable_in_file(file_path, variable_name, new_value):
    with open(file_path, 'r') as file:
        file_content = file.read()

    # Replace the variable value using regex
    new_content = re.sub(f'{variable_name} = ".*"', f'{variable_name} = "{new_value}"', file_content)

    with open(file_path, 'w') as file:
        file.write(new_content)

def execute_script(platform, selected_machine, attack_argument, hash_argument, selected_hash):
    if platform == "azure":
        file_path = "azure.py"
    elif platform == "aws":
        file_path = "aws.py"
    else:
        print("Plateforme invalide.")
        display_help()
        return

    # Remplacer les valeurs des variables dans le fichier
    replace_variable_in_file(file_path, "selected_machine", selected_machine)
    replace_variable_in_file(file_path, "attack_argument", attack_argument)
    replace_variable_in_file(file_path, "hash_argument", hash_argument)
    replace_variable_in_file(file_path, "hash", selected_hash)

    # Exécuter le script Python
    subprocess.run(["python3", file_path])

def display_help():
    help_text = """
Usage: script.py -p PLATFORM -m MACHINE -a ATTACK -h HASH [-d ARGUMENT]

  -p PLATFORM    Platform to deploy the tool (aws or azure)
  -m MACHINE     Type of machine to deploy
  -a ATTACK      Type of attack
  -h HASH        Hash to crack
  -d ARGUMENT    Display documentation for the given argument (platform, machine, attack, hash)

Example:
  script.py -p azure -m 1 -a 0 -h 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8

Documentation example:
  script.py -d platform
"""
    print(help_text)
    sys.exit(1)

def display_documentation(argument):
    documentation = {
        "platform": "Platform to deploy the tool. Options are 'aws' or 'azure'.",
        "machine": "Type of machine to deploy. Provide the machine type as an integer.",
        "attack": "Type of attack. Provide the attack type as an integer.",
        "hash": "Hash to crack. Provide the hash as a string."
    }
    print(documentation.get(argument, "No documentation available for the given argument."))
    sys.exit(1)

def hash_identifier(hash_value):
    hash_length = len(hash_value)
    hash_types = {
        32: "MD5",
        40: "SHA1",
        56: "SHA2-224",
        64: "SHA2-256",
        96: "SHA2-384",
        128: "SHA2-512"
    }
    return hash_types.get(hash_length, "Unknown")

def map_hash_type_to_argument(hash_type):
    hashcat_args = {
        "MD5": "-m 0",
        "SHA1": "-m 100",
        "SHA2-224": "-m 1300",
        "SHA2-256": "-m 1400",
        "SHA2-384": "-m 10800",
        "SHA2-512": "-m 1700",
        "SHA3-224": "-m 17300",
        "SHA3-256": "-m 17400",
        "SHA3-384": "-m 17500",
        "SHA3-512": "-m 17600",
        "RIPEMD-160": "-m 6000",
        "BLAKE2b-512": "-m 600",
        "GOST R 34.11-2012 (Streebog) 256-bit": "-m 11700",
        "GOST R 34.11-2012 (Streebog) 512-bit": "-m 11800",
        "GOST R 34.11-94": "-m 6900",
        "GPG (AES-128/AES-256 (SHA-1($pass)))": "-m 17010",
        "Half MD5": "-m 5100",
        "Keccak-224": "-m 17700",
        "Keccak-256": "-m 17800",
        "Keccak-384": "-m 17900",
        "Keccak-512": "-m 18000",
        "Whirlpool": "-m 6100",
        "SipHash": "-m 10100",
        "md5(utf16le($pass))": "-m 70",
        "sha1(utf16le($pass))": "-m 170",
        "sha256(utf16le($pass))": "-m 1470",
        "sha384(utf16le($pass))": "-m 10870",
        "sha512(utf16le($pass))": "-m 1770",
        "BLAKE2b-512($pass.$salt)": "-m 610",
        "BLAKE2b-512($salt.$pass)": "-m 620",
        "md5($pass.$salt)": "-m 10",
        "md5($salt.$pass)": "-m 20",
        "md5($salt.$pass.$salt)": "-m 3800",
        "md5($salt.md5($pass))": "-m 3710",
        "md5($salt.md5($pass.$salt))": "-m 4110",
        "md5($salt.md5($salt.$pass))": "-m 4010",
        "md5($salt.sha1($salt.$pass))": "-m 21300",
        "md5($salt.utf16le($pass))": "-m 40",
        "md5(md5($pass))": "-m 2600",
        "md5(md5($pass).md5($salt))": "-m 3910",
        "md5(md5(md5($pass)))": "-m 3500",
        "md5(sha1($pass))": "-m 4400",
        "md5(sha1($pass).$salt)": "-m 4410",
        "md5(sha1($pass).md5($pass).sha1($pass))": "-m 20900",
        "md5(sha1($salt).md5($pass))": "-m 21200",
        "md5(strtoupper(md5($pass)))": "-m 4300",
        "md5(utf16le($pass).$salt)": "-m 30",
        "sha1($pass.$salt)": "-m 110",
        "sha1($salt.$pass)": "-m 120",
        "sha1($salt.$pass.$salt)": "-m 4900",
        "sha1($salt.sha1($pass))": "-m 4520",
        "sha1($salt.sha1($pass.$salt))": "-m 24300",
        "sha1($salt.utf16le($pass))": "-m 140",
        "sha1($salt1.$pass.$salt2)": "-m 19300",
        "sha1(CX)": "-m 14400",
        "sha1(md5($pass))": "-m 4700"
    }
    return hashcat_args.get(hash_type, "Invalid hash type.")

def main():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-p', '--platform', type=str, help='Platform to deploy the tool (aws or azure)')
    parser.add_argument('-m', '--machine', type=int, help='Type of machine to deploy')
    parser.add_argument('-a', '--attack', type=int, help='Type of attack')
    parser.add_argument('-h', '--hash', type=str, help='Hash to crack')
    parser.add_argument('-d', '--documentation', type=str, help='Display documentation for the given argument (platform, machine, attack, hash)')
    parser.add_argument('--help', action='store_true', help='Display help message')

    args = parser.parse_args()

    if args.help:
        display_help()

    if args.documentation:
        display_documentation(args.documentation)

    if not (args.platform and args.machine is not None and args.attack is not None and args.hash):
        display_help()

    # Identify the hash type
    identified_hash = hash_identifier(args.hash)
    if identified_hash == "Unknown":
        print("Hash type not recognized. Please enter the correct hash type from the following list:")
        print(" | ".join([
            "MD5", "SHA1", "SHA2-224", "SHA2-256", "SHA2-384", "SHA2-512",
            "SHA3-224", "SHA3-256", "SHA3-384", "SHA3-512", "RIPEMD-160",
            "BLAKE2b-512", "GOST R 34.11-2012 (Streebog) 256-bit",
            "GOST R 34.11-2012 (Streebog) 512-bit", "GOST R 34.11-94",
            "GPG (AES-128/AES-256 (SHA-1($pass)))", "Half MD5", "Keccak-224",
            "Keccak-256", "Keccak-384", "Keccak-512", "Whirlpool", "SipHash",
            "md5(utf16le($pass))", "sha1(utf16le($pass))", "sha256(utf16le($pass))",
            "sha384(utf16le($pass))", "sha512(utf16le($pass))", "BLAKE2b-512($pass.$salt)",
            "BLAKE2b-512($salt.$pass)", "md5($pass.$salt)", "md5($salt.$pass)",
            "md5($salt.$pass.$salt)", "md5($salt.md5($pass))", "md5($salt.md5($pass.$salt))",
            "md5($salt.md5($salt.$pass))", "md5($salt.sha1($salt.$pass))", "md5($salt.utf16le($pass))",
            "md5(md5($pass))", "md5(md5($pass).md5($salt))", "md5(md5(md5($pass)))",
            "md5(sha1($pass))", "md5(sha1($pass).$salt)", "md5(sha1($pass).md5($pass).sha1($pass))",
            "md5(sha1($salt).md5($pass))", "md5(strtoupper(md5($pass)))", "md5(utf16le($pass).$salt)",
            "sha1($pass.$salt)", "sha1($salt.$pass)", "sha1($salt.$pass.$salt)",
            "sha1($salt.sha1($pass))", "sha1($salt.sha1($pass.$salt))", "sha1($salt.utf16le($pass))",
            "sha1($salt1.$pass.$salt2)", "sha1(CX)", "sha1(md5($pass))"
        ]))
        user_hash_type = input("Enter the hash type: ")
        hash_argument = map_hash_type_to_argument(user_hash_type)
    else:
        print(f"Identified hash type: {identified_hash}")
        user_confirmation = input("Is this correct? (y/n): ")
        if user_confirmation.lower() == 'y':
            hash_argument = map_hash_type_to_argument(identified_hash)
        else:
            user_hash_type = input("Enter the hash type: ")
            hash_argument = map_hash_type_to_argument(user_hash_type)

    print(f"Hashcat argument: {hash_argument}")

    # Validate required arguments
    if not (args.platform and args.machine is not None and args.attack is not None and args.hash):
        print("All options are required.")
        display_help()

    # Map attack types to arguments
    attack_types = {
        0: "-a 0",  # Dictionary attack
        1: "-a 1",  # Combinator attack
        3: "-a 3",  # Brute-force attack
        6: "-a 6",  # Hybrid attack
        9: "-a 9"   # Association attack
    }
    attack_argument = attack_types.get(args.attack, "Invalid attack type.")
    if attack_argument == "Invalid attack type.":
        display_help()

    # Map machine types to arguments
    machine_types = {
        0: "Standard NC6s v3",
        1: "Standard ND6s v2",
        2: "Standard NV32as v4",
        3: "Standard NC12s v3",
        4: "Standard NC24s v3"
    }
    selected_machine = machine_types.get(args.machine, "Invalid machine selected. Please choose a number between 0 and 4.")
    if selected_machine.startswith("Invalid"):
        print(selected_machine)
        display_help()

    # Print the selected options
    print(f"Platform: {args.platform}")
    print(f"Machine: {selected_machine}")
    print(f"Attack: {attack_argument}")
    print(f"Hash Type: {hash_argument}")
    print(f"Hash: {args.hash}")
    
    # Write variables got 
    platform = args.platform
    selected_machine = selected_machine
    attack_argument = attack_argument
    hash_argument = hash_argument
    selected_hash = args.hash
    

    execute_script(platform, selected_machine, attack_argument, hash_argument, selected_hash)

if __name__ == "__main__":
    main()
