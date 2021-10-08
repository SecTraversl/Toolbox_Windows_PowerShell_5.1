<#
.SYNOPSIS
  The "Get-ADUserLogonInfoSimple" function gets Logon information about a given AD User, by querying the Domain Controller found in the $env:LOGONSERVER variable.  This is not necessarily the most authoritative timestamp of domain Logon information for that user -- in order to get that you must query each Domain Controller and find the most recent timestamp.

.DESCRIPTION
.EXAMPLE
  PS C:\> ADUserLogonInfoSimple Jannus.Fugal

  SamAccountName              : Jannus.Fugal
  LastLogonConverted          : 9/23/2021 3:18:26 PM
  LastLogonDate               : 9/14/2021 7:41:08 AM
  LastLogonTimestampConverted : 9/14/2021 7:41:08 AM
  LogonCount                  : 4921



  Here we run the function by calling its built-in alias of "ADUserLogonInfoSimple".  In return, we get various Logon information for the user according to the Domain Controller found in the $env:LOGONSERVER variable.  This is not necessarily the most authoritative timestamp of domain Logon information for that user -- in order to get that you must query each Domain Controller and find the most recent timestamp.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADUserLogonInfoSimple.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-23 | Updated Version
  Dependencies:  ActiveDirectory module
  Notes:
  - This took almost 4 minutes to complete when querying all users
  - Here is the reference from where we retrieved the idea of using [datetime]::FromFileTime() to convert the timestamp:  https://docs.microsoft.com/en-us/archive/blogs/poshchap/one-liner-get-a-list-of-ad-users-password-expiry-dates
    - Old way using w32tm.exe -ntte:  
        ♣ Temp> w32tm.exe -ntte 132665259961917071
        153547 18:06:36.1917071 - 5/26/2021 11:06:36 AM

    - New way using [datetime]::FromFileTime()
        √ Temp> [datetime]::FromFileTime(132665259961917071)

        Wednesday, May 26, 2021 11:06:36 AM
  
  .
#>
function Get-ADUserLogonInfoSimple {
  [CmdletBinding()]
  [Alias('ADUserLogonInfoSimple')]
  param (
    [Parameter( ParameterSetName = 'Default', Position = 0 )]
    [string[]]
    $Identity,
    [Parameter( Position = 1)]
    [switch]
    $AllUsers
  )
  
  begin {}
  
  process {

    $Properties = @('SamAccountName', 'LastLogon', 'LastLogonDate', 'LastLogonTimestamp', 'LogonCount')

    if ($AllUsers) {
      $Results = Get-ADUser -Filter * -Properties *
    }
    elseif ($Identity) {
      $Results = foreach ($item in $Identity) {
        Get-ADUser -Identity $item -Properties $Properties
      }
    }

    if ($Results) {
      $Results | Select-Object -Property `
        'SamAccountName', 
      @{n = 'LastLogonConverted'; e = { [datetime]::FromFileTime($_.LastLogon) } }, 
      'LastLogonDate', 
      @{n = 'LastLogonTimestampConverted'; e = { [datetime]::FromFileTime($_.LastLogonTimestamp) } }, 
      'LogonCount'
    }

  }
  
  end {}
}