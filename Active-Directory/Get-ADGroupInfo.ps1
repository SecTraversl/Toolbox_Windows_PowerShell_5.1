<#
.SYNOPSIS
  The "Get-ADGroupInfo" function is a succinct way to retrieve an AD Group object that has a name partially matching the argument given to the "-Name" parameter.

.DESCRIPTION
.EXAMPLE
  PS C:\> ADGroupInfo 'infosec'

  DistinguishedName : CN=VMware-InfoSec,OU=Security,OU=Groups,DC=corp,DC=MyDomain,DC=com
  GroupCategory     : Security
  GroupScope        : Universal
  Name              : VMware-InfoSec
  ObjectClass       : group
  ObjectGUID        : 7765a27c-11a2-4dae-a27a-d317a89a719d
  SamAccountName    : VMware-InfoSec
  SID               : S-1-5-33-354893651-010466885-0111034255-55691

  DistinguishedName : CN=MECH-InfoSec-Employees,OU=Distribution,OU=Groups,DC=corp,DC=MyDomain,DC=com
  GroupCategory     : Distribution
  GroupScope        : Universal
  Mail              : MECH-InfoSec-Employees@MyDomain.com
  Name              : MECH-InfoSec-Employees
  ObjectClass       : group
  ObjectGUID        : fc5f69e6-124d-4acb-9dc9-37e1169923e3
  SamAccountName    : MECH-InfoSec-Employees
  SID               : S-1-5-21-119147777-238368422-2050013282-34189



  Here we run the "Get-ADGroupInfo" function by calling its built-in alias of 'ADGroupInfo'.  We reference the substring of 'infosec' to be used in our default wildcard search for an AD Group object that has the given substring in its "Name" property value.  In return we get two AD Group objects, one of which is a 'Security' GroupCategory, and the other which is a 'Dsitribution' GroupCategory.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADGroupInfo.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-25 | Updated aesthetics
  Dependencies:  ActiveDirectory module
  Notes:


  .
#>
function Get-ADGroupInfo {
  [CmdletBinding()]
  [Alias('ADGroupInfo')]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Reference a partial or full group name to retrieve from Active Directory.')]
    [string[]]
    $Name,
    [Parameter()]
    [string[]]
    $Property,
    [Parameter(HelpMessage = 'Use this switch parameter to ensure the "name" string used in the filter is an exact match for the argument given to the "-Name" parameter')]
    [switch]
    $ExactMatch
  )
  
  begin {}
  
  process {

    if ($Property) {
      $Properties = @('Mail') + @($Property)
    }
    else {
      $Properties = @('Mail')
    }


    foreach ($item in $Name) {

      if ($ExactMatch) {
        $Filter = "Name -like '$item'"
      }
      else {
        $Filter = "Name -like '*$item*'"
      }      

      Get-ADGroup -Filter $Filter -Properties $Properties

    }

  }
  
  end {}
}