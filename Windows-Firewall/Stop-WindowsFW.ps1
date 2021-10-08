<#
.SYNOPSIS
  The "Stop-WindowsFW" function allows for the disabling of the Windows Firewall.

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

  PS C:\> Set-NetFirewallProfile -Profile * -Enabled True
  PS C:\>
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
  Name: Stop-WindowsFW.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-06 | Initial Version
  Dependencies: 
  Notes:
  - This was helpful for getting the syntax for the command below: https://www.dell.com/support/kbdoc/en-us/000135271/windows-server-how-to-properly-turn-off-the-windows-firewall-in-windows-server-2008-and-above

  .
#>
function Stop-WindowsFW {
  [CmdletBinding()]
  param (
    
  )
  
  begin {}
  
  process {

    Write-Host "`nNow running...:  'Set-NetFirewallProfile -Profile * -Enabled False'`n" -BackgroundColor Black -ForegroundColor Yellow
    Set-NetFirewallProfile -Profile * -Enabled False

  }
  
  end {}
}