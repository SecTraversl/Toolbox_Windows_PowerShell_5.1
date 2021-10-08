<#
.SYNOPSIS
  The "Invoke-GPUpdateForce" function runs the "gpupdate /force" command on a given array of computer names.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Invoke-GPUpdateForce.ps1
  Author:  Travis Logue
  Version History:  
  Dependencies:
  Notes:

  .
#>
function Invoke-GPUpdateForce {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string[]]
    $ComputerName,
    [Parameter()]
    [switch]
    $UsePsExec
  )
  
  begin {}
  
  process {

    if ($UsePsExec) {
      foreach ($Computer in $ComputerName) {
        # $exe = ".\PsExec64.exe"
        # $param = "\\"
        .\PsExec64.exe \\$Computer Gpupdate.exe /force
      }
    }
    else {
      foreach ($Computer in $ComputerName) {
        Invoke-Command -ComputerName $Computer -ScriptBlock { gpupdate.exe /force } -AsJob -Verbose
      }
    }
  }
  
  end {}
}