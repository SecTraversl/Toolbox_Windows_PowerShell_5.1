<#
.SYNOPSIS
  The "Split-Array" function splits up a given array into 1 array with multiple sub-arrays that are sized based on the integer given to the -Size parameter.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Split-Array.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-07-13 | Initial Version
  Dependencies:
  Notes:
    - This was where I got the syntax for the code below: https://community.idera.com/database-tools/powershell/ask_the_experts/f/learn_powershell_from_don_jones-24/22622/split-an-array-into-multiple-smaller-arrays

  .
#>
function Split-Array {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [array]
    $Array,
    [Parameter(Mandatory)]
    [int]
    $Size
  )
  
  begin {}
  
  process {
    for ($i = 0; $i -lt $Array.Count; $i += $Size) {
      # $result = [System.Collections.ArrayList]@()
      $result += , @($Array[$i..($i + $Size - 1)])
    }
    Write-Host "NOTE: In order to access each sub-array use the bracket index notation, e.g.`$objects[0]" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "NOTE: To see the total count of sub-arrays, use `$objects.Count" -ForegroundColor Yellow -BackgroundColor Black
    Write-Output $result
  }
  
  end {}
}