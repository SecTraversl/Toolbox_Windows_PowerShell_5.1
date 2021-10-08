<#
.SYNOPSIS
  The "Lock-Computer" functions locks the computer by leveraging "rundll32.exe user32.dll,LockWorkStation"
.DESCRIPTION
.EXAMPLE
  PS C:\> Lock-Computer



  This locks the computer.

.INPUTS
.OUTPUTS
.NOTES
  Name: Lock-Computer
  Author: Travis Logue
  Version History: 1.0 | 2021-01-03 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in determining the approach below: https://docs.microsoft.com/en-us/powershell/scripting/samples/changing-computer-state?view=powershell-7.1


  .
#>
function Lock-Computer {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    rundll32.exe user32.dll,LockWorkStation
  }
  
  end {}
}