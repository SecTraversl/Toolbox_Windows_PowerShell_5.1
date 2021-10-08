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
  Name: Convert-BytesToHex.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-09-08 | Updated aesthetics
  Dependencies:
  Notes:
    

  .
#>
function Convert-BytesToHex {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the System Byte Array you want to convert to a Hexadecimal string representation.')]
    [System.Byte[]]
    $SystemByteObject
  )
  
  begin {}
  
  process {
    $HexString = [BitConverter]::ToString($SystemByteObject)
    Write-Output $HexString
  }
  
  end {}
}








