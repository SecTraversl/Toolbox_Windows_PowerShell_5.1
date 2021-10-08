<#
.SYNOPSIS
  The "Get-ADObjectTimestamp" function takes a numeric Active Directory timestamp and converts it to a human-readable format.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ADUser -Identity Jannus.Fugal -Properties badPasswordTime

  badPasswordTime   : 132665259961917071
  DistinguishedName : CN=Jannus Fugal,OU=Employee,OU=Operators,DC=corp,DC=MyDomain,DC=com
  Enabled           : True
  GivenName         : Jannus
  Name              : Jannus Fugal
  ObjectClass       : user
  ObjectGUID        : ffa5f6e4-dfbe-4456-8496-3f44a857f090
  SamAccountName    : Jannus.Fugal
  SID               : S-1-5-21-203572503-109117628-3773961456-57895
  Surname           : Fugal
  UserPrincipalName : Jannus.Fugal@MyDomain.com


  PS C:\> ConvertWindowsTimestamp 132665259961917071
  153547 18:06:36.1917071 - 5/26/2021 11:06:36 AM



  Here we query Active Directory for the "badPasswordTime" property of a specific user.  We then call the function "Convert-ADObjectTimestamp" by using its built-in alias of 'ConvertWindowsTimestamp'.

.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-ADObjectTimestamp.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-08-30 | Added an additional means of doing this
  Dependencies:
  Notes:
  - Here is the reference from where we retrieved the idea of using [datetime]::FromFileTime() to convert the timestamp:  https://docs.microsoft.com/en-us/archive/blogs/poshchap/one-liner-get-a-list-of-ad-users-password-expiry-dates
    - Old way using w32tm.exe -ntte:  
        ♣ Temp> w32tm.exe -ntte 132665259961917071
        153547 18:06:36.1917071 - 5/26/2021 11:06:36 AM

    - New way using [datetime]::FromFileTime()
        √ Temp> [datetime]::FromFileTime(132665259961917071)

        Wednesday, May 26, 2021 11:06:36 AM

  .
#>
function Convert-ADObjectTimestamp {
  [CmdletBinding()]
  [Alias('ConvertWindowsTimestamp')]
  param (
    [Parameter()]
    [string]
    $Timestamp
  )
  
  begin {}
  
  process {

    # Original way I learned to do this:
    <#
    w32tm.exe /ntte $Timestamp
    #>

    [datetime]::FromFileTime($Timestamp)

  }
  
  end {}
}