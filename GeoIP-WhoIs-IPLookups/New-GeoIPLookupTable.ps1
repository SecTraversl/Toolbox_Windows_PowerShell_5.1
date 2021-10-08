<#
.SYNOPSIS
  The "New-GeoIPLookupTable" function does a GeoIP lookup for a given list of IP Addresses so that they can be stored and referenced later on.

.DESCRIPTION
.EXAMPLE
  PS C:\> $GeoIPLookup = New-GeoIPLookupTable -Csv .\Pulse-GeoIP.csv -IPAddressHeader 'geoip.ip'
  PS C:\>
  PS C:\> Get-CommandRuntime
  Seconds           : 57

  PS C:\> $GeoIPLookup | measure
  Count    : 435

  PS C:\> $GeoIPLookup | select -f 20 -Property LookupDate,* -ErrorAction Ignore | ft

  LookupDate ip             city           region            country loc               org                                       postal timezone
  ---------- --             ----           ------            ------- ---               ---                                       ------ --------
  12/26/2020 2.27.1.14      Telford        England           GB      52.6766,-2.4493   AS12576 EE Limited                        TF3    Europ...
  12/26/2020 2.45.31.64     Milan          Lombardy          IT      45.4643,9.1895    AS30722 Vodafone Italia S.p.A.            20121  Europ...
  12/26/2020 3.89.7.95      Virginia Beach Virginia          US      36.7978,-76.1759  AS14618 Amazon.com, Inc.                  23464  Ameri...
  12/26/2020 3.91.73.60     Virginia Beach Virginia          US      36.7978,-76.1759  AS14618 Amazon.com, Inc.                  23464  Ameri...
  12/26/2020 5.66.46.90     Wolverhampton  England           GB      52.5855,-2.1230   AS5607 Sky UK Limited                     WV1    Europ...
  12/26/2020 5.188.210.227  Pyatigorsk     Stavropol??? Kray RU      44.0486,43.0594   AS34665 Petersburg Internet Network ltd.  357500 Europ...
  12/26/2020 12.32.216.130  New York City  New York          US      40.7143,-74.0060  AS7018 AT&T Services, Inc.                10004  Ameri...
  12/26/2020 23.127.173.235 San Antonio    Texas             US      29.4241,-98.4936  AS7018 AT&T Services, Inc.                78205  Ameri...
  12/26/2020 24.0.125.224   Philadelphia   Pennsylvania      US      39.9523,-75.1638  AS33659 Comcast Cable Communications, LLC 19099  Ameri...
  12/26/2020 24.16.185.17   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.16.199   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.59.89    Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.59.175   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.61.222   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.195.146  Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.17.196.47   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.18.11.220   Tacoma         Washington        US      47.2529,-122.4443 AS33650 Comcast Cable Communications, LLC 98401  Ameri...
  12/26/2020 24.18.33.63    Tacoma         Washington        US      47.2529,-122.4443 AS33650 Comcast Cable Communications, LLC 98401  Ameri...
  12/26/2020 24.18.127.29   Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...
  12/26/2020 24.18.145.169  Seattle        Washington        US      47.6062,-122.3321 AS33650 Comcast Cable Communications, LLC 98111  Ameri...



  Here we run the function referencing the .csv that has IP Address data (using the "-Csv" parameter) in it while also specifying the header name of the row in the .csv that contains the IP Addresses (using the "-IPAddressHeader" parameter).  For the 435 GeoIP lookups the total time to completion was 57 seconds.  The function adds the property of "LookupDate" to each entry and we are displaying that first in the output above.

.INPUTS
.OUTPUTS
.NOTES
  Name: New-GeoIPLookupTable
  Author: Travis Logue
  Version History: 2.0 | 2020-01-06 | Code changes in light of limitation in the 'ipinfo.io' API to only populate 'hostname' field if the first IP that is looked up has a 'hostname' property; e.g. '24.0.125.224' vs. '2.27.1.14'
  Dependencies: Get-GeoIP.ps1 | MyDateTime.ps1
  Notes:


  .
#>
function New-GeoIPLookupTable {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .csv containing the IP Addresses to lookup.')]
    [string]
    $Csv,
    [Parameter(HelpMessage='Reference the header in the .csv under which the "IP Addresses" are stored.')]
    [string]
    $IPAddressHeader = 'geoip.ip'
  )
  
  begin {}
  
  process {

    $Content = Import-Csv $Csv
    $UniqueIPAddresses = $Content.$IPAddressHeader | Where-Object {$_}  | Select-Object -Unique
    $FirstResult = Get-GeoIP $UniqueIPAddresses[0]
    Write-Host "`nThere is a limitation of the 'ipinfo.io' API to only populate the 'hostname' field if the first IP that is looked up has a 'hostname' property; e.g. '24.0.125.224' vs. '2.27.1.14'`n" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "`nThe Get-GeoIP lookup results for the first entry of the list are as follows:`n$FirstResult`n`n"
    $Answer = Read-Host "Do you want to continue? [y/n]"

    if ($Answer.ToLower().StartsWith('y')) {
      $GeoIPLookupResults = $UniqueIPAddresses | % { Get-GeoIP  $_ }
      $GeoIPLookupResults | Add-Member -MemberType NoteProperty -Name LookupDate -Value (MyDateTime -YearMonthDay) 
      
      Write-Output $GeoIPLookupResults
    }
    else {
      Write-Host "`nExiting the function..."
      break
    }

  }
  
  end {}
}