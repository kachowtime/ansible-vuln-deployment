# Cyberpunk Active Directory Deployment

## Overview
This Ansible project automates the deployment of an Active Directory environment for a CCDC lab.

## Prerequisites
- Ansible with `ansible.windows` and `community.windows` collections installed
- Windows Server 2022 for the DC (win2022-1)
- WinRM configured on target hosts
- Local admin credentials: `cyberrange` / `Passw0rd!`

## File Structure
```
.
├── inventory.ini              # Host definitions
├── deploy_ad_p1.yml          # Phase 1: DC promotion
├── deploy_ad_p2.yml          # Phase 2: AD object creation
└── vars/
    └── ad/
        ├── ad.yml            # Domain configuration
        ├── local_admin.yml   # Pre-domain credentials
        └── domain_admin.yml  # Post-domain credentials
```

## Deployment Steps

### Phase 1: Promote Domain Controller
This installs AD DS, creates the domain, and reboots the server.

```bash
ansible-playbook -i inventory.ini deploy_ad_p1.yml
```

**What it does:**
- Installs AD Domain Services feature
- Promotes server to Domain Controller
- Creates `cyberpunk.local` domain
- Reboots the server
- Verifies DC status

**Duration:** ~10-15 minutes (includes reboot)

### Phase 2: Configure Active Directory
This creates OUs, groups, and users in the domain.

**IMPORTANT:** You must use domain credentials for Phase 2:

```bash
ansible-playbook -i inventory.ini deploy_ad_p2.yml -e @vars/ad/domain_admin.yml
```

**What it does:**
- Creates Organizational Units (Departments, Users)
- Creates security groups (Neon-IT, Neon-HR, etc.)
- Creates 10 domain users
- Adds users to their respective groups
- Displays deployment summary

**Duration:** ~3-5 minutes

## Created Objects

### Organizational Units
- Departments
- Users

### Security Groups (in Departments OU)
- Neon-IT (IT Department)
- Neon-HR (HR Department)
- Neon-Finance (Finance Department)
- Neon-Ops (Operations Department)
- Neon-Exec (Executives)

### Domain Users (in Users OU)
All users have password: `Neon123!`

| Username | Description         | Group         |
|----------|---------------------|---------------|
| v        | Street Runner       | Neon-Ops      |
| judy     | NetTech            | Neon-IT       |
| panam    | Logistics          | Neon-Ops      |
| dex      | Finance Analyst    | Neon-Finance  |
| rogue    | Strategy Lead      | Neon-Exec     |
| morgan   | HR Relations       | Neon-HR       |
| jackie   | Junior Admin       | Neon-IT       |
| river    | Field Specialist   | Neon-Ops      |
| kira     | Accountant         | Neon-Finance  |
| nova     | Payroll Specialist | Neon-HR       |

## Troubleshooting

### Phase 1 Issues
**Problem:** Domain promotion fails
- Verify the server has a static IP
- Check DNS settings point to itself (127.0.0.1)
- Ensure server name doesn't contain invalid characters

**Problem:** Can't connect after reboot
- Wait 2-3 minutes for services to start
- Verify WinRM is running: `Test-WSMan -ComputerName <IP>`

### Phase 2 Issues
**Problem:** Authentication failure
- Ensure you're using `-e @vars/ad/domain_admin.yml`
- Verify credentials: `CYBERPUNK\cyberrange` / `Passw0rd!`

**Problem:** "No such object" errors
- Phase 1 must complete successfully first
- Check domain promotion: `Get-ADDomain`

**Problem:** Users not added to groups
- Verify groups were created in Phase 2
- Check OU paths match

## Verification Commands

Run these on the domain controller:

```powershell
# Verify domain
Get-ADDomain

# List OUs
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName

# List groups
Get-ADGroup -Filter * | Select-Object Name, GroupScope, GroupCategory

# List users
Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled

# Check user group membership
Get-ADPrincipalGroupMembership -Identity "v" | Select-Object Name
```

## Key Fixes from Original

1. **Credential Consistency:** All passwords now use `Passw0rd!`
2. **Phase 2 Authentication:** Explicitly uses domain credentials via `-e` flag
3. **User Creation:** Added missing user creation tasks
4. **Group Placement:** Groups now created in Departments OU
5. **Service Verification:** Added checks for AD services before configuration
6. **Error Handling:** Added retries and better wait conditions
7. **Documentation:** Clear instructions on credential requirements

## Security Notes

⚠️ **This is a LAB environment. Do NOT use these credentials in production!**

- Default passwords are weak and publicly documented
- DSRM password should be changed: `Passw0rd!` → Strong password
- User passwords should follow organizational policy
- Consider implementing Group Policy for password requirements
