<#
.SYNOPSIS
  The "Get-ADObjectInfo" function is a succinct way to retrieve any AD Object (such as a user or a group) that has a name partially matching the argument given to the "-ComputerName" parameter.

.DESCRIPTION
.EXAMPLE
  PS C:\> ADObjectInfo 'help desk'

  DistinguishedName : CN=IT Help Desk Shared Mailbox Users,OU=Security,OU=Groups,DC=corp,DC=MyDomain,DC=com
  Mail              : ITHelpDeskShrdMBXUsers@MyDomain.com
  Name              : IT Help Desk Shared Mailbox Users
  ObjectClass       : group
  ObjectGUID        : fa6c11c4-4ddb-96a7-a7e0-f595cfe8b27c
  objectSid         : S-1-5-52-265948488-568713991-4301410127-23276
  SamAccountName    : IT Help Desk Shared Mailbox Users

  DistinguishedName : CN=IT Help Desk,OU=SharedMB,OU=Resources,DC=corp,DC=MyDomain,DC=com
  Mail              : ITHelpDesk@MyDomain.com
  Name              : IT Help Desk
  ObjectClass       : user
  ObjectGUID        : 662cd982-9fa2-287d-aa8f-53e4a066201d
  objectSid         : S-1-5-54-016745283-485954434-3440012693-92142
  SamAccountName    : ITHelpDesk

  DistinguishedName : OU=Help Desk,OU=Users,OU=Controlled Objects,DC=corp,DC=MyDomain,DC=com
  Name              : Help Desk
  ObjectClass       : organizationalUnit
  ObjectGUID        : 6d9e9eea-e42a-4912-7a21-ef81d0ba9106



  Here we run the "Get-ADObjectInfo" function by calling its built-in alias of 'ADObjectInfo'.  We reference the substring of 'helpdesk' to be used in our default wildcard search for an AD Object that has the given substring in its "Name" property value.  In return we get three AD Objects, one of which is a 'group' object containing the given substring, another which is a 'user' object, and a third which is an 'organizational unit'.


.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADObjectInfo.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-27 | Updated aesthetics
  Dependencies:  ActiveDirectory module
  Notes:


  .
#>
function Get-ADObjectInfo {
  [CmdletBinding()]
  [Alias('ADObjectInfo')]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Reference a partial or full object name to retrieve from Active Directory.')]
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
      $Properties = @('Mail', 'objectSid', 'SamAccountName') + @($Property)
    }
    else {
      $Properties = @('Mail', 'objectSid', 'SamAccountName')
    }
    
    foreach ($item in $Name) {
      
      if ($ExactMatch) {
        $Filter = "Name -like '$item'"
      }
      else {
        $Filter = "Name -like '*$item*'"
      }
      
      Get-ADObject -Filter $Filter -Properties $Properties

    }

  }
  
  end {}
}