<<<<<<< HEAD
# Disable Windows Firewall (all profiles)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Enable WinRM
winrm quickconfig -force

# Ensure WinRM starts automatically
Set-Service WinRM -StartupType Automatic
Start-Service WinRM
=======
# Disable Windows Firewall (all profiles)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Enable WinRM
winrm quickconfig -force

# Ensure WinRM starts automatically
Set-Service WinRM -StartupType Automatic
Start-Service WinRM
>>>>>>> 7bf2c8c5490be32881777aed50681cbb1ef7df7e
