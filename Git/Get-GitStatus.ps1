<#
.SYNOPSIS
  The "Get-GitStatus" function is a wrapper for the "git status" command line.

.EXAMPLE
.NOTES
  Name:  Get-GitStatus.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:
  - 

  .
#>
function Get-GitStatus {
  [CmdletBinding()]
  [Alias('GitStatus')]
  param ()
  
  begin {}
  
  process {
    git status
  }
  
  end {}
}