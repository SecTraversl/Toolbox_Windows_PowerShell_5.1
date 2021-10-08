<#
.SYNOPSIS
  The "Get-WmicComputerNICs" function leverages WMIC to get Network Interface Card (NIC) information from a computer (including MAC Address, IP Address, Default Gateway, and more).
  
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-WmicComputerNICs.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-04-05 | Initial Version
  Dependencies: 
  Notes:


  . 
#>
function Get-WmicComputerNICs {
  [CmdletBinding()]
  [Alias('WmicNICs')]
  param (

  )
  
  begin {}
  
  process {
    wmic nicconfig get IPAddress,MACAddress,DefaultIPGateway,Index,Description,DHCPEnabled,DNSDomain,ServiceName /format:table
  }
  
  end {}
}