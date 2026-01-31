#!/bin/bash

# Exit on error
set -e

echo "==============================="
echo "Updating apt..."
echo "==============================="
sudo apt update -y

echo "==============================="
echo "Installing Ansible, Python3, pip3, and Git..."
echo "==============================="
sudo apt install -y ansible python3 python3-pip git

echo "==============================="
echo "Installing pywinrm..."
echo "==============================="
pip3 install --user pywinrm

echo "==============================="
echo "Verifying installations..."
ansible --version | head -n 1
python3 -c "import winrm" && echo "pywinrm installed successfully"
git --version

echo "==============================="
echo "Setup complete! Ansible + Git + pywinrm ready."
echo "==============================="
