<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-GPOsForUser.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-14 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-GPOsForUser {
  [CmdletBinding()]
  [Alias('GPOsForUser')]
  param (
    
  )
  
  begin {}
  
  process {
    $UserGPResult = gpresult.exe /scope user /v

    for ($i = 0; $i -lt $UserGPResult.Count; $i++) {

      # Here we match the line of interest
      if ($UserGPResult[$i] -like "*Applied Group Policy Objects*") {

        # Create the 'collector' array
        $AppliedGPOs = @()
        
        # Create the counter
        $counter = 0

        # The current line is the line of interest (our entry point) and we want to skip one line and start collecting the values thereafter, so we start collecting with "$UserGPResult[$i + 2 + $counter]"

        do {
          # We will trim the excess blank characters from the beginning and end of the line
          $TrimOffTheLeadingAndTrailingBlankSpace = ($UserGPResult[$i + 2 + $counter]).Trim()

          # Add each 'trimmed' line to the 'collector' array, and increment the $counter...
          $AppliedGPOs += $TrimOffTheLeadingAndTrailingBlankSpace
          $counter += 1

          # ... Until the line is a "Blank Line"
        } until ($null -like $UserGPResult[$i + 2 + $counter])

        # We have what we need, so let's break out of the 'for loop'
        break
      }      
    }

    Write-Output $AppliedGPOs


  }
  
  end {}
}