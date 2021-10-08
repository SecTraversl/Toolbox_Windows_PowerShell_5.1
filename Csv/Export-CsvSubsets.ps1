<#
.SYNOPSIS
  The "Export-CsvSubsets" function takes a given array and exports each element within the array to its own .csv file.  This function is particularly useful when you have an array of arrays, such as when you divide one large array up into smaller sections and then want to export each section to a separate .csv file.

.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Export-CsvSubsets.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-07-13 | Initial Version
  Dependencies:
  Notes:

  .
#>
function Export-CsvSubsets {
  [CmdletBinding()]
  param (
    [Parameter()]
    [array]
    $Array,
    [Parameter()]
    [string]
    $Name
  )
  
  begin {}
  
  process {

    if ($Name) {
      $Name = '_' + $Name + '.csv'
    }
    else {
      $Name = '.csv'
    }

    for ($i = 0; $i -lt $Array.Count; $i++) {
      Write-Verbose "Array number: $($i + 1)"
      if ($($i + 1).ToString().Length -eq 1) {
        $Array[$i] | Export-Csv -NoTypeInformation "Subset_0$($i + 1)$Name"
      }
      else {
        $Array[$i] | Export-Csv -NoTypeInformation "Subset_$($i + 1)$Name"
      }
    }

  }
  
  end {}
}