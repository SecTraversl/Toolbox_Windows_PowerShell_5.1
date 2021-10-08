<#
.SYNOPSIS
  The "TrustDelegationComputers" function searches a given domain for any systems which are 'TrustedForDelegation' or are 'TrustedToAuthForDelegation' and returns the AD Computer Object for those systems. 

.DESCRIPTION
.EXAMPLE
  PS C:\> TrustDelegationComputers | select Name, TrustedForDelegation, TrustedToAuthForDelegation

  Name        TrustedForDelegation TrustedToAuthForDelegation
  ----        -------------------- --------------------------
  ANWPORCDC01                 True                      False
  ANWPORCDC02                 True                      False
  LOCPORCDC01                 True                      False



  Here we run the "Find-TrustedDelegationComputers" by calling its built-in alias 'TrustDelegationComputers'.  We select certain properties to show of the returned objects, and we see that in the default domain only 3 systems are "TrustedForDelegation" and they all appear to be domain controllers.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Find-TrustedDelegationComputers.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-08-28 | Initial Version
  Dependencies:  ActiveDirectory module
  Notes:
  - Good reference for Kerberos and Trusted Delegation:  https://adsecurity.org/?p=1667

  .
#>
function Find-TrustedDelegationComputers {
  [CmdletBinding()]
  [Alias('TrustDelegationComputers')]
  param (
    [Parameter(HelpMessage = 'For Future Use. To be used to specify which domain to do the search.')]
    [string[]]
    $Server
  )
  
  begin {}
  
  process {

    $Properties = @('Certificates', 'servicePrincipalName', 'TrustedForDelegation', 'TrustedToAuthForDelegation')

    Get-ADComputer -Filter "TrustedForDelegation -eq 'True' -or TrustedToAuthForDelegation -eq 'True'" -Properties $Properties

  }
  
  end {}
}