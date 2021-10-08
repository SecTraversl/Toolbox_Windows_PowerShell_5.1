

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
  Got this idea from: https://www.reddit.com/r/PowerShell/comments/jj55so/run_windows_apps_using_powershell_the_easy_way/gac7hth/
#>

function Get-WindowsApp {
  param ()
  
  Get-AppxPackage

}