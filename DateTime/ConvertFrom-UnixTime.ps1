<#
.SYNOPSIS
  The "ConvertFrom-UnixTime" function takes a given Epoch / Unix timestamp and returns the value of the human readable format.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  ConvertFrom-UnixTime.ps1
  Author:  Travis Logue
  Version History:  1.3 | 2021-06-15 | Added the comment-help, changed function name, made prevous name an alias
  Dependencies:
  Notes:
  - Idea gleaned from:  https://stackoverflow.com/questions/10781697/convert-unix-time-with-powershell
  - Misc. Notes:
      -   # See Convert a Unix timestamp to a .NET DateTime.
    - http://codeclimber.net.nz/archive/2007/07/10/convert-a-unix-timestamp-to-a-.net-datetime.aspx

    # You can easily reproduce this in PowerShell.
      $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
      $whatIWant = $origin.AddSeconds($unixTime)

    #edited Jan 14 '19 at 6:32
    #Peter Mortensen

    #answered May 28 '12 at 8:45
    #JohnB

      [datetime]$origin = '1970-01-01 00:00:00' works just as well, and is maybe a little easier to understand – Torbjörn Bergstedt May 28 '12 at 8:54

      @TorbjörnBergstedt Or [datetime] '1970-01-01Z', which is both shorter and correctly specifies the point in time in UTC (although what you get back is expressed in local time). Similarly, New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0, Utc should be used. – mklement0 May 4 at 9:24


  .
#>

function ConvertFrom-UnixTime {
  [CmdletBinding()]
  [alias('ConvertFrom-EpochTime', 'Convert-UnixTime2WindowsTime', 'FromEpochTime', 'FromUnixTime')]
  param (
    [Parameter(HelpMessage = 'Reference the Unix timestamp {e.g. "1597384447"} that you want to convert')]
    [string]
    $UnixTime
  )
  
  begin {}
  
  process {

    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $whatIWant = $origin.AddSeconds($UnixTime)
    Write-Output $whatIWant

  }
  
  end {}
}