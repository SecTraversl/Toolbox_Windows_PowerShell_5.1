<#
.SYNOPSIS
  The "Start-WindowsFW" function allows for the disabling of the Windows Firewall.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-WindowsFWStatus

  Now running...:  'Get-NetFirewallProfile -Profile * | Select-Object Name,Enabled'

  Name    Enabled
  ----    -------
  Domain     True
  Private    True
  Public     True

  PS C:\> Stop-WindowsFW

  Now running...:  'Set-NetFirewallProfile -Profile * -Enabled False'

  PS C:\> Get-WindowsFWStatus

  Now running...:  'Get-NetFirewallProfile -Profile * | Select-Object Name,Enabled'

  Name    Enabled
  ----    -------
  Domain    False
  Private   False
  Public    False

  PS C:\> Start-WindowsFW

  Now running...:  'Set-NetFirewallProfile -Profile * -Enabled True'

  PS C:\> Get-WindowsFWStatus

  Now running...:  'Get-NetFirewallProfile -Profile * | Select-Object Name,Enabled'

  Name    Enabled
  ----    -------
  Domain     True
  Private    True
  Public     True



  Here we show how to use the function and the reverse the affects of the function with various commands, along with showing the status changes to the Windows Firewall along the way.

.INPUTS
.OUTPUTS
.NOTES
  Name: Start-WindowsFW.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-06 | Initial Version
  Dependencies: 
  Notes:


  .
#>
function Start-WindowsFW {
  [CmdletBinding()]
  param (
    
  )
  
  begin {}
  
  process {

    Write-Host "`nNow running...:  'Set-NetFirewallProfile -Profile * -Enabled True'`n" -BackgroundColor Black -ForegroundColor Yellow
    Set-NetFirewallProfile -Profile * -Enabled True

  }
  
  end {}
}