### Overview
---
**Install-RSAT** simplifies setting up an admin workstation. Instead of opening Settings > Optional Features and adding each RSAT component by hand, you run one command and pass flags for each tool you need. It uses the built-in _Add-WindowsCapability_ cmdlet, so no external downloads or modules are required.

### Features
---
- **Flag-based selection:** install only what you need (for example -ADDS -DNS -GroupPolicy).
- **21 supported tools:** AD DS/LDS, BitLocker Recovery, Certificate Services, DHCP, DNS, Failover Clustering, File Services, Group Policy Management, IPAM, LLDP, Network Controller, Network Load Balancing, Remote Access, Remote Desktop Services, Server Manager, Shielded VM, Storage Migration Service, Storage Replica, System Insights, Volume Activation and WSUS.
- **Status check:** the -Status flag lists every RSAT component and whether it is installed.
- **Usage hint:** running the script with no flags prints the correct syntax instead of failing.
- **Installed-tools report:** shows the current RSAT state before it begins installing.

### Requirements
---
- Windows 10/11 (Features on Demand-based RSAT)
- Elevated (Run as Administrator) PowerShell session
- Internet access or an available Features on Demand source

### Usage
---
```PowerShell
.\Install-RSAT.ps1 -Status
.\Install-RSAT.ps1 -ADDS -DNS -DHCP -GroupPolicy
```

