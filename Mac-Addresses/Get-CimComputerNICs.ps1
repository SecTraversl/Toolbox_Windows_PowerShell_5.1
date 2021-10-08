<#
.SYNOPSIS
  The "Get-CimComputerNICs" function leverages CIM or WMI to get Network Interface Card (NIC) information from a computer (including MAC Address, IP Address, Default Gateway, and more).
  
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-CimComputerNICs.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-04-05 | Initial Version
  Dependencies: 
  Notes:


  . 
#>
function Get-CimComputerNICs {
  [CmdletBinding()]
  [Alias('ComputerNICs')]
  param (
    [Parameter()]
    [switch]
    $UseWMI
  )
  
  begin {}
  
  process {
    if ($UseWMI) {
      Get-WmiObject -Query "SELECT * FROM Win32_NetworkAdapterConfiguration" | Select-Object IPAddress,MACAddress,DefaultIPGateway,Index,Description,DHCPEnabled,DNSDomain,ServiceName
    }
    else {
      Get-CimInstance -Query "SELECT * FROM Win32_NetworkAdapterConfiguration" | Select-Object IPAddress,MACAddress,DefaultIPGateway,Index,Description,DHCPEnabled,DNSDomain,ServiceName
    }
  }
  
  end {}
}