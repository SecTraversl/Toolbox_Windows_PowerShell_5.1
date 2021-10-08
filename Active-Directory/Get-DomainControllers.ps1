<#
.SYNOPSIS
  The "Get-DomainControllers" functions returns a list of Domain Controllers for a given domain.  The default value of the "-DomainName" parameter is that of the variable $env:USERDOMAIN.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-DomainControllers
  ANWPORCBC03.subd.MyDomain.com
  ANWPORCBC04.subd.MyDomain.com
  RADPORCDC01.subd.MyDomain.com



  Here we run the function and in return we get the 3 Domain Controller FQDNs for the domain name value found in the $env:USERDOMAIN variable.  You can also specify a different domain explicitly using the "-DomainName" parameter.
  
.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-DomainControllers.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-23 | Updated version
  Dependencies:  ActiveDirectory module
  Notes:

  
  .
#>
function Get-DomainControllers {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = "Enter the name of the Domain")]
    [string]
    $DomainName = "$env:USERDOMAIN"
  )
    
  begin {}
    
  process {
    $DCList = nltest.exe /dclist:$DomainName
    $Results = (( $DCList | Select-String -Pattern "\[DS\]" ) -replace "\[.*", "").Trim()
    Write-Output $Results
  }
    
  end {}
}