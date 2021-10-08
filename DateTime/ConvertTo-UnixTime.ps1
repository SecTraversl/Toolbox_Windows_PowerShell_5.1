<#
.SYNOPSIS
  The "ConvertTo-UnixTime" function takes a given date/time string and it will convert it to the Epoch / Unix timestamp format
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-Date '2021-06-14T14:58:59Z'

  Monday, June 14, 2021 7:58:59 AM


  PS C:\> Get-Date '2021-06-14T14:58:59Z' -UFormat %s
  1623657539
  PS C:\>
  PS C:\>
  PS C:\> $date = Get-Date '2021-06-14T14:58:59Z'
  PS C:\>
  PS C:\> $date.ToUniversalTime()

  Monday, June 14, 2021 2:58:59 PM


  PS C:\> Get-Date $date.ToUniversalTime() -UFormat %s
  1623682739
  PS C:\>
  PS C:\>
  PS C:\> ToUnixTime '2021-06-14T14:58:59Z'
  1623682739
  PS C:\>
  PS C:\> ToEpochTime '2021-06-14T14:58:59Z'
  1623682739
  PS C:\>
  PS C:\> ConvertTo-UnixTime '2021-06-14T14:58:59Z'
  1623682739



  Here we are doing a number of demonstrations.  The time string we are working with is a "Zulu" timestamp (Notice the "Z" at the end of the string) which is the the same as telling PowerShell that the timezone is UTC.  You can see that PowerShell auto-converts this to the local time as the default display when we display the $date variable.  We display the various ways to call this function, by using the "CovertTo-UnixTime" name, as well as using the aliases of "ToUnixTime" and "ToEpochTime". 

.INPUTS
.OUTPUTS
.NOTES
  Name:  ConvertFrom-UnixTime.ps1
  Author:  Travis Logue
  Version History:  1.3 | 2021-06-15 | Added the comment-help, changed function name, made prevous name an alias
  Dependencies:
  Notes:
  - Idea gleaned from:  https://stackoverflow.com/questions/4192971/in-powershell-how-do-i-convert-datetime-to-unix-time/32777771
  - Specifically:
      - not sure when -uformat was added to get-date but it allows you to use unix date format strings;

        [int64](get-date -uformat %s)

        answered Aug 14 '19 at 2:04

        silicontrip
        57644 silver badges1818 bronze badges
        Hopefully this bubbles up to the top somewhere – Jason S May 12 '20 at 1:59
        1
        -uformat %s is there in PS 5.1, not sure about earlier versions, so at least since Jan 2017 – Jason S May 12 '20 at 2:01

        [int64](Get-Date(Get-Date).ToUniversalTime() -UFormat %s) fixes the timestamp when you are not in UTC timezone. – bitdancer Dec 14 '20 at 22:02

  .
#>

function ConvertTo-UnixTime {
  [CmdletBinding()]
  [alias('ConvertTo-EpochTime', 'ToEpochTime', 'ToUnixTime')]
  param (
    [Parameter(HelpMessage = 'Reference the Date/Time string that you want to convert to a Unix / Epoch timestamp {e.g. "1597384447"}')]
    [string]
    $DateTimeString
  )
  
  begin {}
  
  process {

    $Date = Get-Date $DateTimeString
    $Date = $Date.ToUniversalTime()
    $EpochTimeFormat = Get-Date $Date -UFormat %s
    Write-Output $EpochTimeFormat
  }
  
  end {}
}