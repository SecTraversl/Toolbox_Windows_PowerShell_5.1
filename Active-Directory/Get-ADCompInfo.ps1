<#
.SYNOPSIS
  The "Get-ADCompInfo" function is a succinct way to retrieve an AD Computer object that has a name partially matching the argument given to the "-Name" parameter.

.DESCRIPTION
.EXAMPLE
  PS C:\> ADCompInfo RemDesk

  Certificates         : {System.Security.Cryptography.X509Certificates.X509Certificate}
  DistinguishedName    : CN=RemDesktopPC,OU=Desktop,OU=Devices,DC=corp,DC=MyDomain,DC=com
  DNSHostName          : RemDesktopPC.subd.MyDomain.com
  Enabled              : True
  Name                 : RemDesktopPC
  ObjectClass          : computer
  ObjectGUID           : ea895eb6-4795-7925-a596-ee268c9e87ab
  SamAccountName       : RemDesktopPC$
  servicePrincipalName : {WSMAN/RemDesktopPC.subd.MyDomain.com, WSMAN/RemDesktopPC, TERMSRV/RemDesktopPC.subd.MyDomain.com,
                        TERMSRV/RemDesktopPC...}
  SID                  : S-1-5-15-213745452-569715233-0553666126-90577
  UserPrincipalName    :



  Here we run the "Get-ADCompInfo" function by calling its built-in alias of 'ADCompInfo'.  We reference the substring of 'RemDesk' to be used in our default wildcard search for an AD Computer object that has the given substring in its "Name" property value.  In return we get the only matching computer object along with various properties pertaining to that computer object.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADCompInfo.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-25 | Updated aesthetics
  Dependencies:  ActiveDirectory module
  Notes:


  .
#>
function Get-ADCompInfo {
  [CmdletBinding()]
  [Alias('ADCompInfo')]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Reference a partial or full computer name to retrieve from Active Directory.')]
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
      $Properties = @('Certificates', 'servicePrincipalName') + @($Property)
    }
    else {
      $Properties = @('Certificates', 'servicePrincipalName')
    }


    foreach ($item in $Name) {

      if ($ExactMatch) {
        $Filter = "Name -like '$item'"
      }
      else {
        $Filter = "Name -like '*$item*'"
      }      

      Get-ADComputer -Filter $Filter -Properties $Properties

    }

  }
  
  end {}
}