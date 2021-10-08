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
  Name:  Get-GPResultForComputer.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-07 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-GPResultForComputer {
  [CmdletBinding()]
  param (
    
  )
  
  begin {}
  
  process {
    gpresult.exe /scope computer /v
  }
  
  end {}
}