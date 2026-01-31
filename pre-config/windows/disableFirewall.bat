@echo off
:: Run PowerShell command to disable all firewalls
powershell -Command "Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False; Get-NetFirewallProfile | Select Name, Enabled"
pause
