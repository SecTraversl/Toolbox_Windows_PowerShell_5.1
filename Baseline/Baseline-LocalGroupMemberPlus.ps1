<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Baseline-LocalGroupMemberPlus.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-01-23 | Initial Version
  Dependencies: Get-LocalGroupMemberPlus.ps1 | MyDateTime.ps1 
  Notes:


  .
#>
function Baseline-LocalGroupMemberPlus {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the directory to store the Baseline file.  The default is: "$Home\Documents\Temp\ps1_files\Baseline\".')]
    [string]
    [ValidateScript({Test-Path $_})]
    $BaselineDirectory = "$Home\Documents\Temp\ps1_files\Baseline\"
  )
  
  begin {}
  
  process {
    $Hostname = HOSTNAME.EXE
    $Day = MyDateTime -YearMonthDay

    if (-not ($BaselineDirectory.EndsWith("\")) ) {
      $BaselineDirectory = $BaselineDirectory + "\"
    }

    Get-LocalGroupMemberPlus | Export-Clixml "$($BaselineDirectory)Baseline_LocalGroupMemberPlus_$($Hostname)_$($Day).xml"
  }
  
  end {}
}