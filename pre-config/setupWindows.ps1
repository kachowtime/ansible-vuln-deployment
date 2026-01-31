# Disable Windows Firewall (all profiles)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Enable WinRM
winrm quickconfig -force

# Ensure WinRM starts automatically
Set-Service WinRM -StartupType Automatic
Start-Service WinRM
