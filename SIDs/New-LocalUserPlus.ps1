<#
.SYNOPSIS
  The "New-LocalUserPlus" function is a utility to create a new local useraccount with certain preferred settings.

.DESCRIPTION
.EXAMPLE
  PS C:\> NewLocalUser -Name TestUser

  cmdlet New-LocalUser at command pipeline position 1
  Supply values for the following parameters:
  Password: ******************************

  Name     Enabled Description
  ----     ------- -----------
  TestUser True

  PS C:\> Get-LocalUserPlus | ? name -eq 'TestUser'

  Name                   : TestUser
  Enabled                : True
  SID                    : S-1-5-21-1648910119-3597843528-2260513475-1023
  LastLogon              :
  PasswordLastSet        : 1/27/2021 9:42:16 AM
  PasswordChangeableDate : 1/27/2021 9:42:16 AM
  PasswordExpires        :
  PasswordRequired       : True
  UserMayChangePassword  : True
  Description            :
  PrincipalSource        : Local
  ObjectClass            : User
  FullName               :
  AccountExpires         :



  Here we run the function using its alias of "NewLocalUser" and then use the "Get-LocalUserPlus" function to validate the properties are as we expect.

.INPUTS
.OUTPUTS
.NOTES
  Name: New-LocalUserPlus.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-01-27 | Initial Version
  Dependencies:
  Notes:
  - This was a helpful reference for Splatting, used in the code below: https://adamtheautomator.com/powershell-splatting-what-is-it-and-how-does-it-work/
  - This was a helpful reference in discovering the use of the .put() method for changing an attribute of a given object (in this case, the property: ".PasswordRequired = $true"): https://community.idera.com/database-tools/powershell/ask_the_experts/f/powershell_and_wmi-24/10561/making-changes-to-local-accounts

  .
#>
function New-LocalUserPlus {
  [CmdletBinding()]
  [Alias('NewLocalUser')]
  param (
    [Parameter(HelpMessage = 'Reference the Username for the user.', Mandatory = $true)]
    [string]
    $Name,
    [Parameter(HelpMessage = 'Reference a Description for the user.')]
    [string]
    $Description,
    [Parameter(HelpMessage = 'Reference the Full Name of the user.')]
    [string]
    $FullName,
    [Parameter(HelpMessage = 'This Switch Parameter indicates that the user cannot change the password on the user account.')]
    [bool]
    $UserMayNotChangePassword,
    [Parameter(HelpMessage = 'This Switch Parameter changes the default of this function so that the account does expire, according to the normal domain policy')]
    [switch]
    $PasswordExpires,
    [Parameter(HelpMessage = 'This Switch Parameter changes the default of this function so that code involved with setting the "PasswordRequired" property is disabled.')]
    [switch]
    $PasswordNotRequired
  )
  
  begin {}
  
  process {

    $cmdlet = 'New-LocalUser'
    $param = @{Name = $Name }

    if ($Description) {
      $param.Add("Description", $Description)
    }
    if ($FullName) {
      $param.Add("FullName", "$FullName")
    }
    if ($UserMayNotChangePassword) {
      $param.Add("UserMayChangePassword", "$true")
    }    

    if ($PasswordNotRequired) {
      & $cmdlet @param 
    }
    else {

      if ($PasswordExpires) {
        & $cmdlet @param 
      }
      else {
        $param.Add('PasswordNeverExpires', $true)
        & $cmdlet @param   
      }

      Get-WmiObject win32_useraccount -Filter "Name='$Name'" | ForEach-Object { $_.PasswordRequired = $true; $_.put() } | Out-Null
      
    }
   
  }
  
  end {}
}