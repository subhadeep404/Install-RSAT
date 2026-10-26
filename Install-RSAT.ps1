# Requires: RunAsAdministrator
# Script to automate the installation of RSAT (Remote Server Adminisration Tools) for Remote Server Admiistration.

[CmdletBinding()]
Param(
    [switch]$Status,
    [switch]$ADDS,
    [switch]$Bitlocker,
    [switch]$Certificate,
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

function Get-RSATStatus {
    Write-Host -ForegroundColor Green "[+] RSAT Tools Status:" 
    Get-WindowsCapability -Online -Name "Rsat.*" | Select-Object @{Name="Tool Name"; Expression={$_.DisplayName}}, @{Name="Status"; Expression={$_.State}}
}

# Check if the command was passed with no arguments
if ($PSBoundParameters.Count -eq 0) {
    Write-Host -ForegroundColor Red "[!] No Flags were Selected"
    Write-Host -ForegroundColor Gray "[!] Install-RSAT -ADDS -DNS <...>`n"
    return
}

if ($PSBoundParameters.ContainsKey("Status")) {
    Get-RSATStatus
    return
}

# RSAT tool names with their installation attributes
$ToolsToInstall = @{
    "ADDS"="Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0";            
    "Bitlocker"="Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0";
    "Certificate"="Rsat.CertificateServices.Tools~~~~0.0.1.0";               
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

# Get information about the RSAT tools already installed
Get-RSATStatus

Write-Host "[+] Installing RSAT on $hostname"

# Check if the tool is selected to install
foreach ($Tool in $PSBoundParameters.Keys) {
    if ($ToolsToInstall.ContainsKey($Tool)) {
        $ToolName = $ToolsToInstall[$Tool]
        # Write-Host "$ToolName"
    }

    Write-Host -ForegroundColor Green "`n[+] Installing $ToolName"
    Add-WindowsCapability -Online -Name $ToolName
}