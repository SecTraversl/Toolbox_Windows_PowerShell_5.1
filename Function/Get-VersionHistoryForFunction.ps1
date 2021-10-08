<#
.SYNOPSIS
  The "Get-VersionHistoryForFunction" function returns the content of the line containing "Version History:" within the comment-based-help for my functions.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-VersionHistoryForFunction Ping-MachineGun

          Version History: 1.0 | 2020-12-21 | Initial Version
          


  Here we run the tool to return the version for just one function.  Multiple function names may also be given to this tool as well, to get similar results.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-VersionHistoryForFunction.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-09-15 | Updated the name, the tool aesthetics, and added an alias
  Dependencies:
  Notes:


  .
#>
function Get-VersionHistoryForFunction {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the function name for which you want to find the version.')]
    [string[]]
    $FunctionName
  )
  
  begin {}
  
  process {

    foreach ($item in $FunctionName) {

      Get-Help $item -Full | Out-String -Stream | Select-String -Pattern "Version History:"
      
    }
  }
  
  end {}
}