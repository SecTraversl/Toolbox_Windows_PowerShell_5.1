<#
.SYNOPSIS
  The "Get-Months" function returns the months of the year.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-Months -ThreeLetterMonth
  Jan
  Feb
  Mar
  Apr
  May
  Jun
  Jul
  Aug
  Sep
  Oct
  Nov
  Dec

  PS C:\> Get-Months
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December



  Here we run the function without any parameters, and also with the switch parameter "-ThreeLetterMonth".

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-Months.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-11 | Initial Version
  Dependencies: 
  Notes:
  - This is where I derived the syntax to get all of the months using PowerShell:   https://tommymaynard.com/get-all-13-months-in-a-year-2014/


  .
#>
function Get-Months {
  [CmdletBinding()]
  param (
    [Parameter()]
    [switch]
    $ThreeLetterMonth
  )
  
  begin {}
  
  process {
    if ($ThreeLetterMonth) {
      (New-Object System.Globalization.DateTimeFormatInfo).MonthNames | ? {$_} | % { $_[0..2] -join ''}
    }
    else {
      (New-Object System.Globalization.DateTimeFormatInfo).MonthNames | ? {$_}
    }
  }
  
  end {}
}