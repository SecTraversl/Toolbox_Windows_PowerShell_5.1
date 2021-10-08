<#
.SYNOPSIS
  The "Invoke-GitCommit" function is a wrapper for the 'git commit -m $CommitMessage' command line.

.EXAMPLE
.NOTES
  Name:  Invoke-GitCommit.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:
  - 

  .
#>
function Invoke-GitCommit {
  [CmdletBinding()]
  [Alias('GitCommit')]
  param (
    [Parameter(Mandatory)]
    [string]
    $CommitMessage
  )
  
  begin {}
  
  process {
    git commit -m $CommitMessage
  }
  
  end {}
}