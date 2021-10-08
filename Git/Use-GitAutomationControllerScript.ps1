<#
.SYNOPSIS
  The "Use-GitAutomationControllerScript" function is a Controller Script to automate the adding, committing, and pushing of all tracked git changes from the "origin" (the local folder) to the "main" repository.
.EXAMPLE
.NOTES
  Name:  Use-GitAutomationControllerScript.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-10-08 | Initial Version
  Dependencies:  git.exe
  Notes:
  - 

  .
#>
function Use-GitAutomationControllerScript {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $CommitMessage
  )
  
  begin {}
  
  process {
    Write-Host "`ngit status`ngit add *`ngit status`ngit commit -m `$CommitMessage`ngit push origin main`n" -ForegroundColor Yellow -BackgroundColor Black
    $Answer = Read-Host "Do you want to run the following? [y|n]:"

    if ( $Answer.ToLower().StartsWith('y') ) {
      git status
      git add *
      git status
      git commit -m $CommitMessage
      git push origin main
    }

  }
  
  end {}
}