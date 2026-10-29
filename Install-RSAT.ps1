<#
    .SYNOPSIS
    Installs RSAT (Remote Server Administration Tools) on a host machine.

    .DESCRIPTION
    Install-RSAT powershell script automates the installation of RSAT Tools using flag-based feature installation. The tool(s) to be installed is passed by using one or multiple flags in the general form -<Tool Flag>. The script supports checking the system for pre-installed RSAT by passing -Status flag.

    .PARAMETER Status
    Checks the host machine for RSAT installation and returns the status of the installed tools.

    .PARAMETER ADDS
    Installs RSAT: Active Directory Domain Services and Lightweight Directory Services Tools includes snap-ins and command-line tools for remotely managing AD DS and AD LDS on Windows Server.

    .PARAMETER Bitlocker
    Installs RSAT: BitLocker Drive Encryption Administration Utilities include tools for managing BitLocker Drive Encryption features. BitLocker Active Directory Recovery Password Viewer helps to locate BitLocker drive encryption recovery passwords in Active Directory Domain Services (AD DS).

    .PARAMETER CertificateServices
    Installs RSAT: Active Directory Certificate Services Tools Active Directory Certificate Services Tools include the Certification Authority, Certificate Templates, Enterprise PKI and Online Responder Management snap-ins for remotely managing AD CS on Windows Server.

    .PARAMETER DHCP
    Installs RSAT: DHCP Server Tools include the DHCP MMC snap-in, DHCP server netsh context and Windows PowerShell module for DHCP Server.

    .PARAMETER DNS
    Installs RSAT: DNS Server Tools include the DNS Manager snap-in, dnscmd.exe command-line tool and Windows PowerShell module for DNS Server.

    .PARAMETER FailoverClustering
    Installs RSAT: Failover Clustering Tools include the Failover Cluster Manager snap-in, the Cluster-Aware Updating interface and the Failover Cluster module for Windows PowerShell.

    .PARAMETER FileServices
    Installs RSAT: File Services Tools include snap-ins and command-line tools for remotely managing the File Services role on Windows Server.

    .PARAMETER GroupPolicy
    Installs RSAT: Group Policy Management Tools include Group Policy Management Console, Group Policy Management Editor and Group Policy Starter GPO Editor.

    .PARAMETER IPAM
    Installs RSAT: IP Address Management (IPAM) Client is used to connect to and manage a remote IPAM server. IPAM provides a central framework for managing IP address space and corresponding infrastructure servers such as DHCP and DNS in an Active Directory forest.

    .PARAMETER LLDP
    Installs RSAT: Data Centre Bridging LLDP Tools include PowerShell tools for remotely managing LLDP agents on Windows Server.

    .PARAMETER NetworkController
    Installs RSAT: Network Controller Management Tools include PowerShell tools for managing the Network Controller role on Windows Server.

    .PARAMETER NetworkLoadBalancer
    Installs RSAT: Network Load Balancing Tools include the Network Load Balancing Manager snap-in, the Network Load Balancing module for Windows PowerShell and the nlb.exe and wlbs.exe command-line tools.

    .PARAMETER RemoteAccess
    Installs RSAT: Remote Access Management Tools include graphical and PowerShell tools for managing the Remote Access role on Windows Server.

    .PARAMETER RemoteDesktop
    Installs RSAT: Remote Desktop Services Tools include snap-ins for Remote Desktop Licensing Manager, Remote Desktop Licensing Diagnostics and Remote Desktop Gateway Manager. Use Server Manager to administer all other RDS role services.

    .PARAMETER ServerManager
    Installs RSAT: Server Manager includes the Server Manager console and PowerShell tools for remotely managing Windows Server, and includes tools to remotely configure NIC teaming on Windows Server and Best Practices Analyser.

    .PARAMETER ShieldedVM
    Installs RSAT: Shielded VM Tools include the Provisioning Data File Wizard and the Template Disk Wizard.

    .PARAMETER StorageMigration
    Installs RSAT: Storage Migration Service Management Tools for storage migration jobs.

    .PARAMETER StorageReplica
    Installs RSAT: Storage Replica Windows PowerShell module to remotely manage the Storage Replica feature on Windows Server 2016.

    .PARAMETER VolumeActivation
    Installs RSAT: Volume activation tools to manage volume activation licence keys on a Key Management Service (KMS) host or in Microsoft Active Directory Domain Services. These tools can be used to install, activate and manage one or more volume activation licence keys, and to configure KMS settings on Windows Server.

    .PARAMETER WSUS
    Installs RSAT: Windows Server Update Services Tools include graphical and PowerShell tools for managing WSUS.

    .PARAMETER SystemInsights
    Installs RSAT: System Insights module for Windows PowerShell provides the ability to manage System Insights feature.
#>

Param(
    [switch]$Status,
    [switch]$ADDS,
    [switch]$Bitlocker,
    [switch]$CertificateServices,
    [switch]$DHCP,
    [switch]$DNS,
    [switch]$FailoverClustering,
    [switch]$FileServices,
    [switch]$GroupPolicy,
    [switch]$IPAM,
    [switch]$LLDP,
    [switch]$NetworkController,
    [switch]$NetworkLoadBalancer,
    [switch]$RemoteAccess,
    [switch]$RemoteDesktop,
    [switch]$ServerManager,
    [switch]$ShieldedVM,
    [switch]$StorageMigration,
    [switch]$StorageReplica,
    [switch]$VolumeActivation,
    [switch]$WSUS,
    [switch]$SystemInsights
)

$hostname = $env:COMPUTERNAME

# Function to retrieve the information of RSAT Tools on the host machine
function Get-RSATStatus {
    Write-Host -ForegroundColor Green "[+] RSAT Tools Status:" 
    Get-WindowsCapability -Online -Name "Rsat.*" | Select-Object @{Name="Tool Name"; Expression={$_.DisplayName}}, @{Name="Status"; Expression={$_.State}}
}

# Display the execution format if the script was executed with no arguments
if ($PSBoundParameters.Count -eq 0) {
    Write-Host -ForegroundColor Red "[!] No Flags were Selected"
    Write-Host -ForegroundColor Gray "[!] Install-RSAT -ADDS -DNS <...>`n"
    return
}

# Display the current RSAT Tools installed on the system if -Status flag is used
if ($PSBoundParameters.ContainsKey("Status")) {
    Get-RSATStatus
    return
}

# RSAT Tools with Installation Attributes
$ToolsToInstall = @{
    "ADDS"="Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0";            
    "Bitlocker"="Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0";
    "CertificateServices"="Rsat.CertificateServices.Tools~~~~0.0.1.0";               
    "DHCP"="Rsat.DHCP.Tools~~~~0.0.1.0";
    "DNS"="Rsat.Dns.Tools~~~~0.0.1.0";
    "FailoverClustering"="Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0";        
    "FileServices"="Rsat.FileServices.Tools~~~~0.0.1.0";
    "GroupPolicy"="Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0";
    "IPAM"="Rsat.IPAM.Client.Tools~~~~0.0.1.0";
    "LLDP"="Rsat.LLDP.Tools~~~~0.0.1.0";        
    "NetworkController"="Rsat.NetworkController.Tools~~~~0.0.1.0";             
    "NetworkLoadBalancer"="Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0";          
    "RemoteAccess"="Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0";           
    "RemoteDesktop"="Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0";          
    "ServerManager"="Rsat.ServerManager.Tools~~~~0.0.1.0";           
    "ShieldedVM"="Rsat.Shielded.VM.Tools~~~~0.0.1.0";
    "StorageMigration"="Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0";
    "StorageReplica"="Rsat.StorageReplica.Tools~~~~0.0.1.0";
    "SystemInsights"="Rsat.SystemInsights.Management.Tools~~~~0.0.1.0";         
    "VolumeActivation"="Rsat.VolumeActivation.Tools~~~~0.0.1.0";        
    "WSUS"="Rsat.WSUS.Tools~~~~0.0.1.0";
}

# Installation Banner
Write-Host "[+] Installing RSAT on $hostname"

# Install the tool whose flag is passed with the script
foreach ($Tool in $PSBoundParameters.Keys) {
    if ($ToolsToInstall.ContainsKey($Tool)) {
        $ToolName = $ToolsToInstall[$Tool]

        # Check the current state of this capability
        $Capability = Get-WindowsCapability -Online -Name $ToolName
        if ($Capability.State -eq "Installed") {
            Write-Host -ForegroundColor Yellow "`n[=] $Tool is already installed, skipping"
            continue
        }

        Write-Host -ForegroundColor Green "`n[+] Installing $ToolName"
        Add-WindowsCapability -Online -Name $ToolName
    }
}