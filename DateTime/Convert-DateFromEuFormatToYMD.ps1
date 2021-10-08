<#
.SYNOPSIS
  The "Convert-DateFromEuFormatToYMD" function converts the given string from a European date format of "Day/Month/Year" into a format of "YearMonthDay".
.DESCRIPTION
.EXAMPLE
  PS C:\> ConvertEuDateFormat -DateString '26/06/2021'
  20210626

  PS C:\> ConvertEuDateFormat -DateString '3/7/2021'
  20210703

  

  Here we call the function "Convert-DateFromEuFormatToYMD" by using its built-in alias of 'ConvertEuDateFormat'.  In return, we get the given string conversion from a European date format of "Day/Month/Year" into a format of "YearMonthDay".

.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-DateFromEuFormatToYMD.ps1
  Author: Travis Logue
  Version History: 1.1 | 2021-09-07 | Initial Version
  Dependencies:  
  Notes:

  .
#>
function Convert-DateFromEuFormatToYMD {
  [CmdletBinding()]
  [Alias('ConvertEuDateFormat')]
  param (
    [Parameter()]
    [string]
    $DateString
  )
  
  begin {}
  
  process {
    $DTobj = [datetime]::ParseExact($DateString, 'd/M/yyyy', $null)
    $DTobj.ToString('yyyyMMdd')
  }
  
  end {}
}