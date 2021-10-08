
<#
.SYNOPSIS
  Starts a Windows App based off of the partial name given.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  - This idea came from the following reddit post:  https://www.reddit.com/r/PowerShell/comments/jj55so/run_windows_apps_using_powershell_the_easy_way/gac7hth/
#>

function Start-WindowsApp {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $WindowsApp
  )
  
  begin {}
  
  process {

    Start-Process shell:$("AppsFolder\" + (get-appxpackage | ? {$_.PackageFamilyName -like "*$WindowsApp*"}).PackageFamilyName + "!App")
    
  }
  
  end {}
}