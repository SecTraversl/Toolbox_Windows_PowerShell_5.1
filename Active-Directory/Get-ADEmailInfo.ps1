<#
.SYNOPSIS
  The "Get-ADEmailInfo" function is a succinct way to retrieve any AD Object (such as a user or a group) that has an email address partially matching the argument given to the "-Mail" parameter.

.DESCRIPTION
.EXAMPLE
  PS C:\> ADEmailInfo 'helpdesk'

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



  Here we run the "Get-ADEmailInfo" function by calling its built-in alias of 'ADEmailInfo'.  We reference the substring of 'helpdesk' to be used in our default wildcard search for an AD Object that has the given substring in its "Mail" property value.  In return we get two AD Objects, one of which is a 'group' object containing the given substring, and the other which is a 'user' object.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADEmailInfo.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-27 | Updated aesthetics
  Dependencies:  ActiveDirectory module
  Notes:


  .
#>
function Get-ADEmailInfo {
  [CmdletBinding()]
  [Alias('ADEmailInfo')]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Reference a partial or full email address to retrieve from Active Directory.')]
    [string[]]
    $Mail,
    [Parameter()]
    [string[]]
    $Property,
    [Parameter(HelpMessage = 'Use this switch parameter to ensure the "mail" string used in the filter is an exact match for the argument given to the "-Mail" parameter')]
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

    foreach ($item in $Mail) {

      if ($ExactMatch) {
        $Filter = "Mail -like '$item'"
      }
      else {
        $Filter = "Mail -like '*$item*'"
      }
      
      Get-ADObject -Filter $Filter -Properties $Properties
      
    }

  }
  
  end {}
}