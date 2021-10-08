<#
.SYNOPSIS
  The "Invoke-GitClone" function takes a given URL for a git repository and clones it to the current working directory.
.EXAMPLE
.NOTES
  Name:  Invoke-GitClone.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:  
  - 

  .
#>
function Invoke-GitClone {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $URL
  )
  
  begin {}
  
  process {
    git clone $URL
  }
  
  end {}
}
