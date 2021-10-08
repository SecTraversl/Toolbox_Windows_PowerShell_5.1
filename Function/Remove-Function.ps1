<#
.SYNOPSIS
  The "Remove-Function" function takes the name of a function that is currently loaded in memory (and in the "Function:\" PSDrive) and removes it from memory in the current shell.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Remove-Function.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-15 | Initial Version
  Dependencies:  
  Notes:
  - This was helpful in my research:  https://richardspowershellblog.wordpress.com/2009/02/10/function-removal/
  - This was also helpful:  https://powershell-guru.com/powershell-tip-35-list-and-remove-a-function/
  
  . 
#>
function Remove-Function {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $FunctionName
  )
  
  begin {}
  
  process {
    Remove-Item Function:$FunctionName
  }
  
  end {}
}