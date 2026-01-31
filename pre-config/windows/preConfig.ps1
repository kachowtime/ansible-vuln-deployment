# =========================================================
# ConfigureRemotingForAnsible.ps1
# Purpose: Enable WinRM for Ansible 
# =========================================================

Write-Host "Configuring WinRM for Ansible..."

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Enable WinRM
Write-Host "Enabling WinRM..."
winrm quickconfig -quiet

# Set WinRM service
Write-Host "Configuring WinRM service..."
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

# Allow unencrypted traffic (LAB ONLY)
Write-Host "Allowing unencrypted WinRM..."
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Enable authentication methods
Write-Host "Enabling authentication methods..."
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{CredSSP="true"}'

# Increase memory limits (needed for AD installs)
Write-Host "Increasing WinRM memory limits..."
winrm set winrm/config '@{MaxMemoryPerShellMB="1024"}'

# Set TrustedHosts
Write-Host "Setting TrustedHosts..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# Disable firewall (LAB ONLY)
Write-Host "Disabling Windows Firewall (LAB ONLY)..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Restart WinRM
Write-Host "Restarting WinRM..."
Restart-Service WinRM

# Test WinRM
Write-Host "Testing WinRM..."
Test-WSMan localhost

Write-Host "WinRM configuration for Ansible completed."
