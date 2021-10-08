<#
.SYNOPSIS
  The "Set-LocalUserAccountName" function changes a given useraccount name using the Get-WmiObject cmdlet.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-LocalUser | select Name,Enabled,SID,Description | ft

  Name               Enabled SID                                            Description
  ----               ------- ---                                            -----------
  Administrator         True S-1-5-21-1234566889-98431385-123451232321-500  Built-in account for administering the computer/domain
  DefaultAccount       False S-1-5-21-1234566889-98431385-123451232321-503  A user account managed by the system.
  MYusehr               True S-1-5-21-1234566889-98431385-123451232321-1004
  Guest                False S-1-5-21-1234566889-98431385-123451232321-501  Built-in account for guest access to the computer/domain
  JeaUser               True S-1-5-21-1234566889-98431385-123451232321-1026
  WDAGUtilityAccount   False S-1-5-21-1234566889-98431385-123451232321-504  A user account managed and used by the system for Windows Defender Application Guard scenarios.


  PS C:\> LocalUserNameChange -Name Guest -NewName 'WhoIsThisUser'

  The name update completed successfully

  PS C:\> Get-LocalUser | select Name,Enabled,SID,Description | ft

  Name               Enabled SID                                            Description
  ----               ------- ---                                            -----------
  Administrator         True S-1-5-21-1234566889-98431385-123451232321-500  Built-in account for administering the computer/domain
  DefaultAccount       False S-1-5-21-1234566889-98431385-123451232321-503  A user account managed by the system.
  MYusehr               True S-1-5-21-1234566889-98431385-123451232321-1004
  JeaUser               True S-1-5-21-1234566889-98431385-123451232321-1026
  WDAGUtilityAccount   False S-1-5-21-1234566889-98431385-123451232321-504  A user account managed and used by the system for Windows Defender Application Guard scenarios.
  WhoIsThisUser        False S-1-5-21-1234566889-98431385-123451232321-501  Built-in account for guest access to the computer/domain



  Here we run the function using its built-in alias of "LocalUserNameChange" in order to change the Guest local useraccount to have the name of "WhoIsThisUser".  We show the before and after using the Get-LocalUser cmdlet.

.INPUTS
.OUTPUTS
.NOTES
  Name: Set-LocalUserAccountName.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-01-31 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in deriving the correct syntax: https://stackoverflow.com/questions/5188917/powershells-script-to-re-name-local-guest-administrator-account
  

  .
#>
function Set-LocalUserAccountName {
  [CmdletBinding()]
  [Alias('LocalUserNameChange')]
  param (
    [Parameter(HelpMessage = 'Reference the current name of the local user you want to change.')]
    [string]
    $Name,
    [Parameter(HelpMessage = 'Reference the new name for the local user.', Mandatory = $true)]
    [string]
    $NewName,
    [Parameter(HelpMessage = 'Reference the SID of the local user you want to change.')]
    [string]
    $SID
  )
  
  begin {}
  
  process {

    # Specifying this because by default, if this is not specified, Get-WmiObject will query all domains within the forest and the local computer.  We just want the local computer in this case.
    $Domain = HOSTNAME.EXE

    if ($Name) {
      $LocalUser = Get-WmiObject -Class Win32_UserAccount -Filter "Domain='$Domain' and Name='$Name'"
    }
    elseif ($SID) {
      $LocalUser = Get-WmiObject -Class Win32_UserAccount -Filter "Domain='$Domain' and SID='$SID'"
    }
    else {
      Write-Host "`nEither a -Name parameter or a -SID parameter must be used to reference the existing local user account that you want to change`n" -BackgroundColor black -ForegroundColor Yellow
    }

    $RenameOperation = $LocalUser.Rename($NewName)

    if ($RenameOperation.ReturnValue -eq 0) {
      Write-Host "`nThe name update completed successfully`n" -BackgroundColor Black -ForegroundColor Yellow
    }
    else {
      Write-Host "`nThe name change attempt was unsuccessful`n" -BackgroundColor Black -ForegroundColor Red
    }

  }
  
  end {}
}