<#
.SYNOPSIS
  The "Invoke-GitAdd" function takes the given argument to the "-File" parameter (including '*' as an option) and performs a "git add $File".

.EXAMPLE
.NOTES
  Name:  Invoke-GitAdd.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:
  - 

  .
#>
function Invoke-GitAdd {
  [CmdletBinding()]
  [Alias('GitAdd')]
  param (
    [Parameter(Mandatory)]
    [string[]]
    $File
  )
  
  begin {}
  
  process {
    git add $File
  }
  
  end {}
}