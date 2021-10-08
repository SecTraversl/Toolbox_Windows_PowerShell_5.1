
<#
.SYNOPSIS
  The "Get-GPOLastUpdateTime" returns the last time that Group Policy was applied for both the User and the Computer, and from which Domain Controller the Group Policy was applied from.

.DESCRIPTION
.EXAMPLE
  PS C:\> GPOLastUpdateTime

  COMPUTER SETTINGS
      Last time Group Policy was applied: 9/18/2021 at 6:23:08 PM
      Group Policy was applied from:      ANWPORCBC04.subd.MyDomain.com
  USER SETTINGS
      Last time Group Policy was applied: 9/18/2021 at 6:15:35 PM
      Group Policy was applied from:      ANWPORCBC03.subd.MyDomain.com



  Here we run the function by calling its built-in alias of "GPOlastUpdateTime".  In return we see the last time that Group Policy was applied for both the User and the Computer, and from which Domain Controller the Group Policy was applied from.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-GPOLastUpdateTime.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-18 | Initial Version
  Dependencies:
  Notes:
  - This was one of the first articles that was helpful for this idea:  https://devblogs.microsoft.com/scripting/use-powershell-to-generate-and-parse-a-group-policy-object-report/


  .
#>


function Get-GPOLastUpdateTime {
  [CmdletBinding()]
  [Alias('GPOLastUpdateTime')]
  param ()
  
  begin {}
  
  process {

    # Use Out-GridView to do quick text searches from the output
    # - Search for "applied" to see last time GPOs were Applied for User/Computer

    $GPResult = gpresult.exe /r

    $GPResult | Select-String "COMPUTER SETTINGS", "USER SETTINGS", "Last time Group Policy was applied:", "Group Policy was applied from:"

    
  }
  
  end {}
}