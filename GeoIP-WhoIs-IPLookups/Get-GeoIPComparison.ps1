<#
.SYNOPSIS
  The "Get-GeoIPComparison" function opens a browser to 'www.iplocation.net' in order to retrieve geolocation information about a specified IP Address from 5 different online services.
  
.DESCRIPTION
.EXAMPLE
.INPUTS
.OUTPUTS
.NOTES
  Name: Get-GeoIPComparison.ps1
  Author: Travis Logue
  Version History: 1.1 | 2021-01-14 | Initial Version
  Dependencies:
  Notes:
  - For other ways to do free Geo IP lookups... See also... https://dev.maxmind.com/geoip/geoip2/geolite2/

  
  .
#>
function Get-GeoIPComparison {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the IP Address to look up.',Mandatory=$true)]
    [string]
    $IPAddress
  )
  
  begin {}
  
  process {

    $brave = "c:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe"

    $param = @()
    $param += "-incognito"

    $Url = "https://www.iplocation.net/ip-lookup?query=$IPAddress"

    & $brave $param $Url

  }
  
  end {}
}