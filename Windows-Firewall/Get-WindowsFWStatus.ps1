<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WindowsFWStatus.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-06 | Initial Version
  Dependencies: 
  Notes:


  .
#>
function Get-WindowsFWStatus {
  [CmdletBinding()]
  param (
    
  )
  
  begin {}
  
  process {

    Write-Host "`nNow running...:  'Get-NetFirewallProfile -Profile * | Select-Object Name,Enabled'`n" -BackgroundColor Black -ForegroundColor Yellow
    Get-NetFirewallProfile -Profile * | Select-Object Name,Enabled

  }
  
  end {}
}