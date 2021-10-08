<#
.SYNOPSIS
  The "Convert-DateFromUsFormatToYMD" function converts the given string from a United States date format of "Month/Day/Year" into a format of "YearMonthDay".
.DESCRIPTION
.EXAMPLE
  PS C:\> ConvertUsDateFormat -DateString '12/7/2021'
  20211207


  Here we call the function "Convert-DateFromUsFormatToYMD" by using its built-in alias of 'ConvertUsDateFormat'.  In return, we get the given string conversion from a United States date format of "Month/Day/Year" into a format of "YearMonthDay".

.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-DateFromUsFormatToYMD.ps1
  Author: Travis Logue
  Version History: 1.1 | 2021-09-07 | Initial Version
  Dependencies:  
  Notes:

  .
#>
function Convert-DateFromUsFormatToYMD {
  [CmdletBinding()]
  [Alias('ConvertUsDateFormat')]
  param (
    [Parameter()]
    [string]
    $DateString
  )
  
  begin {}
  
  process {
    $DTobj = [datetime]::ParseExact($DateString, 'M/d/yyyy', $null)
    $DTobj.ToString('yyyyMMdd')
  }
  
  end {}
}