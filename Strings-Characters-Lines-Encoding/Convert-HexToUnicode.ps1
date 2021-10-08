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
  Name: Convert-HexToUnicode.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-09-08 | Updated aesthetics
  Dependencies:
  Notes:
    

  .
#>
function Convert-HexToUnicode {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the Hexadecimal string to convert to Unicode.  This code expects that there is one byte or 2 Hexadecimal characters together by themselves.  If you have multiple bytes delimited by a hyphen, as in "73-00-61-00-6E-00-73-00-00-00"; use the following syntax:  -split "-"  | foreach {ConvertFrom-HexString_To_Unicode16Bit -HexString $_}')]
    [string]
    $HexString
  )
  
  begin {}
  
  process {
    $Unicode16Bit = [char]([convert]::toint16($HexString, 16))
    Write-Output $Unicode16Bit
  }
  
  end {}
}