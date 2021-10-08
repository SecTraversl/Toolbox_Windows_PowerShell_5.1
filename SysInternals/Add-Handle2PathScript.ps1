

<#
.SYNOPSIS
  This script adds the "Handle*" directory underneath "$HOME\Program*\SysInternals\" location.  In order to execute this script use the "-RunScript" switch parameter.  *REQUIRES*: "Add-EnvPath.ps1" to be loaded in memory and callable.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Based off of the "Add-EnvPath.ps1" function
#>

function Add-Handle2PathScript {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'This is a script. If you want to run the script, use this $RunScript switch parameter')]
    [switch]
    $RunScript    
  )
  
  begin {}
  
  process {

    if ($RunScript) {
      $Handle = (Get-Item $home\Program*\SysInternals\Handle*).FullName
      Add-EnvPath -Path $Handle
    }

  }
  
  end {}

}