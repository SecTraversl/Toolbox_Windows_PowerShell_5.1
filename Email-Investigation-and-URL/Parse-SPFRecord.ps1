<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Parse-SPFRecord.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-04 | Initial Version
  Dependencies: 
  Notes:


  .
#>
function Parse-SPFRecord {
  [CmdletBinding()]
  [Alias('SpfParse')]
  param (
    [Parameter(ValueFromPipeline=$true)]
    [Microsoft.DnsClient.Commands.DnsRecord_TXT]
    $SPFRecord,
    [Parameter()]
    [string[]]
    $Match
  )
  
  begin {}
  
  process {
    
    $Formatted = $SpfResults.Strings -split ' ' -match "\w+:"

    if ($Match) {
      foreach ($item in $Match) {
        $Formatted | ? { $_ -match $item}
      }
    }
    else {
      Write-Output $Formatted
    } 

  }
  
  end {}
}