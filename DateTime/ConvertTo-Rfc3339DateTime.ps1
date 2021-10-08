<#
.SYNOPSIS
  The "ConvertTo-Rfc3339DateTime" take a give date/time string and converts it an RFC3399 compatible date/time string.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-Date '2021-06-14T14:58:59Z'

  Monday, June 14, 2021 7:58:59 AM


  PS C:\> (Get-Date '2021-06-14T14:58:59Z').ToUniversalTime()

  Monday, June 14, 2021 2:58:59 PM


  PS C:\> Rfc3339DateTime '2021-06-14T14:58:59Z'

  2021-06-14T07:58:59-07:00


  PS C:\> Rfc3339DateTime '2021-06-14T14:58:59Z' -OutputTimezone UTC

  2021-06-14T14:58:59Z



  Here we have various demonstrations of dealing with a given date/time string.  The first example shows that Get-Date by default will convert to the local time of the machine; whereas the second example shows how to ensure UTC time is displayed.  In the 3rd and 4th examples we are using the function "ConvertTo-Rfc3339DateTime" by referencing its alias of 'Rfc3339DateTime'.  We display the RFC3339 time first with its defaults, expressing the date/time string as a reference to the local computer's offset.  The final example shows the RFC3339 date/time string in UTC.

.INPUTS
.OUTPUTS
.NOTES
  Name:  ConvertTo-Rfc3339DateTime.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-06-16 | Initial Version
  Dependencies:
  Notes:
  - This format is compatible with both ISO 8601 and RFC3339 (due to the embedded "T" in the output):  https://medium.com/easyread/understanding-about-rfc-3339-for-datetime-formatting-in-software-engineering-940aa5d5f68a
    Excerpt:
      # This is acceptable in ISO 8601 and RFC 3339 (with T)
      2019-10-12T07:20:50.52Z
      # This is only accepted in RFC 3339 (without T)
      2019-10-12 07:20:50.52Z

  - A comment in this post was helpful to get a decent format for UTC: https://stackoverflow.com/questions/17017/how-do-i-parse-and-convert-a-datetime-to-the-rfc-3339-date-time-format
    - Specifically:
        I had to use datetime.ToUniversalTime().ToString("yyyy-MM-dd'T'HH:mm:ssZ") – Tomáš Linhart Jun 8 '16 at 21:29
        
  - A comment in this github issues post was helpful in deriving a way to display the offset from UTC for the local machine:  https://github.com/PowerShell/PowerShell/issues/11410
    - Specifically:
        [datetime]::now.tostring("HH:mm zzz") returns the offset information, e.g. 13:25 +01:00

        But the formatter doesn't seem to have a method for converting local time to universal time or vice versa. It needs to be done before the formatting is applied.
        [datetime]::now.ToUniversalTime().tostring("HH:mm zzz")


  .
#>
function ConvertTo-Rfc3339DateTime {
  [CmdletBinding()]
  [Alias('Rfc3339DateTime')]
  param (
    [Parameter()]
    [string]
    $DateTimeString,
    [Parameter()]
    [ValidateSet('LocalComputerOffset', 'UTC')]
    [string]
    $OutputTimezone = 'LocalComputerOffset'
  )
  
  begin {}
  
  process {
    if ($OutputTimezone -eq "UTC") {
      $Date = Get-Date $DateTimeString
      Write-Host ''
      Write-Output $Date.ToUniversalTime().ToString("yyyy-MM-dd'T'HH:mm:ssZ")
      Write-Host ''
      Write-Host ''

    }
    else {
      $Date = Get-Date $DateTimeString
      Write-Host ''
      Write-Output $Date.ToString("yyyy-MM-dd'T'HH:mm:sszzz")
      Write-Host ''
      Write-Host ''
    }
    
    
  }
  
  end {}
}