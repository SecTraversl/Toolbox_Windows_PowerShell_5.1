<#
.SYNOPSIS
  The "Get-DependenciesForFunction" function returns the content of the line containing "Dependencies:" within the comment-based-help for my functions.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-DependenciesForFunction Ping-MachineGun

          Dependencies: Split-ArrayInHalf.ps1



  Here we run the tool to return the dependencies for just one function.  Multiple function names may also be given to this tool as well, to get similar results.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-DependenciesForFunction.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-09-15 | Updated the name, the tool aesthetics, and added an alias
  Dependencies:
  Notes:


  .
#>
function Get-DependenciesForFunction {
  [CmdletBinding()]
  [Alias('DependenciesForFunction')]
  param (
    [Parameter(HelpMessage = 'Reference the function name for which you want to find dependencies.')]
    [string[]]
    $FunctionName
  )
  
  begin {}
  
  process {

    foreach ($item in $FunctionName) {

      Get-Help $item -Full | Out-String -Stream | Select-String -Pattern Dependencies:

    }
  }
  
  end {}
}