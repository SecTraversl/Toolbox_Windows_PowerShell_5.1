<#
.SYNOPSIS
  The "Invoke-GitPushFromOriginToMain" function is a wrapper for the 'git push origin main' command line.

.EXAMPLE
.NOTES
  Name:  Invoke-GitPushFromOriginToMain.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:
  - 

  .
#>
function Invoke-GitPushFromOriginToMain {
  [CmdletBinding()]
  [Alias('GitPushFromOriginToMain')]
  param ()
  
  begin {}
  
  process {
    git push origin main
  }
  
  end {}
}