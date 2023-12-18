import platform
import os
import subprocess

# Get the system/OS name
os_name = platform.system()

if os_name == 'Linux':
    os.system('sh requirements/linux.sh')
elif os_name == 'Windows':
    subprocess.call(['python', 'requirements/windows.py'])
else:
    print(f"Unsupported OS: {os_name}")




