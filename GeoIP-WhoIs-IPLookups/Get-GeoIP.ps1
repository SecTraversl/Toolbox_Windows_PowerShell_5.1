<#
.SYNOPSIS
  The "Get-GeoIP" function queries the API from 'https://ipinfo.io/' in order to retrieve geolocation information about a specified IP Address.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-GeoIP -IPAddress "174.204.64.16"

  ip       : 174.204.64.16
  hostname : 16.sub-174-204-64.myvzw.com
  city     : Seattle
  region   : Washington
  country  : US
  loc      : 47.6062,-122.3321
  org      : AS6167 Cellco Partnership DBA Verizon Wireless
  postal   : 98111
  timezone : America/Los_Angeles
  readme   : https://ipinfo.io/missingauth



  Here we run the function using a specific IP Address and in return receive various information about the source and location associated with that IP Address.

.EXAMPLE
  PS C:\> $x = gcb
  PS C:\> $x -join ', '
  172.56.20.3, 172.58.59.182, 209.6.3.166, 209.170.125.226, 172.56.27.180, 12.202.23.213, 70.251.212.146, 98.38.61.250, 172.58.100.204, 216.244.82.210,
  75.176.243.189, 93.37.135.167, 99.125.138.157, 172.58.27.86, 172.56.40.246, 162.250.160.204, 179.6.197.249, 64.44.80.60, 107.77.241.46, 172.58.69.5, 2
  4.0.125.224, 52.36.251.118, 35.182.104.198, 52.60.97.235, 35.161.251.132, 52.21.22.43, 209.95.50.41, 104.200.152.54, 3.215.91.250, 54.227.245.241, 34.
  201.89.115, 34.216.201.131, 50.56.142.140, 69.20.52.205, 52.79.210.83, 71.84.159.195, 52.47.138.207, 70.112.224.184, 174.251.210.23, 24.116.105.128

  PS C:\> $GeoIPResolved = Get-GeoIP $x
  PS C:\> $GeoIPResolved | ft

  ip              hostname                                                  city           region           country loc               org
  --              --------                                                  ----           ------           ------- ---               ---
  172.56.20.3                                                               Nashville      Tennessee        US      36.1659,-86.7844  AS21928 T-Mobile US...
  172.58.59.182                                                             Germantown     Wisconsin        US      43.2286,-88.1104  AS21928 T-Mobile US...
  209.6.3.166                                                               Herndon        Virginia         US      38.9839,-77.3675  AS6079 RCN
  209.170.125.226                                                           New York City  New York         US      40.7185,-74.0025  AS1299 Telia Compan...
  172.56.27.180                                                             Tampa          Florida          US      27.9475,-82.4584  AS21928 T-Mobile US...
  12.202.23.213                                                             Lubbock        Texas            US      33.5779,-101.8552 AS7018 AT&T Service...
  70.251.212.146                                                            Sugar Hill     Georgia          US      34.1065,-84.0335  AS7018 AT&T Service...
  98.38.61.250                                                              Centennial     Colorado         US      39.5792,-104.8769 AS7922 Comcast Cabl...
  172.58.100.204                                                            Houston        Texas            US      29.7633,-95.3633  AS21928 T-Mobile US...
  216.244.82.210                                                            Seattle        Washington       US      47.6062,-122.3321 AS23033 Wowrack.com
  24.0.125.224    c-24-0-125-224.hsd1.nj.comcast.net                        Cherry Hill    New Jersey       US      39.9348,-75.0307  AS33659 Comcast Cab...
  52.36.251.118   ec2-52-36-251-118.us-west-2.compute.amazonaws.com         Portland       Oregon           US      45.5234,-122.6762 AS16509 Amazon.com,...
  35.182.104.198  ec2-35-182-104-198.ca-central-1.compute.amazonaws.com     Toronto        Ontario          CA      43.7001,-79.4163  AS16509 Amazon.com,...
  52.60.97.235    ec2-52-60-97-235.ca-central-1.compute.amazonaws.com       Toronto        Ontario          CA      43.7001,-79.4163  AS16509 Amazon.com,...
  35.161.251.132  ec2-35-161-251-132.us-west-2.compute.amazonaws.com        Portland       Oregon           US      45.5234,-122.6762 AS16509 Amazon.com,...
  52.21.22.43     ec2-52-21-22-43.compute-1.amazonaws.com                   Virginia Beach Virginia         US      36.8348,-76.0961  AS14618 Amazon.com,...
  209.95.50.41    nye1up.monitis.com                                        New York City  New York         US      40.7143,-74.0060  AS32780 Hosting Ser...
  104.200.152.54  law1up.monitis.com                                        Los Angeles    California       US      34.0443,-118.2509 AS46562 Performive LLC
  69.20.52.205    collector-iad-69-20-52-205.monitoring.rackspacecloud.com  Washington     Washington, D.C. US      38.8951,-77.0364  AS27357 Rackspace H...
  52.79.210.83    ec2-52-79-210-83.ap-northeast-2.compute.amazonaws.com     Seoul          Seoul            KR      37.5660,126.9784  AS16509 Amazon.com,...
  71.84.159.195   071-084-159-195.res.spectrum.com                          Denton         Texas            US      33.2289,-97.1314  AS20115 Charter Com...
  52.47.138.207   ec2-52-47-138-207.eu-west-3.compute.amazonaws.com         Paris          ??le-de-France   FR      48.8534,2.3488    AS16509 Amazon.com,...
  70.112.224.184  cpe-70-112-224-184.austin.res.rr.com                      Austin         Texas            US      30.2428,-97.7658  AS11427 Charter Com...
  174.251.210.23  23.sub-174-251-210.myvzw.com                              Greensburg     Pennsylvania     US      40.3015,-79.5389  AS6167 Cellco Partn...
  24.116.105.128  24-116-105-128.cpe.sparklight.net                         Long Beach     Mississippi      US      30.3505,-89.1528  AS11492 CABLE ONE, ...



  Here we show how to copy a list of IP Addresses from the clipboard and 'paste' them into a variable using 'gcb', an alias for "Get-Clipboard".  From there we reference the array of IP Addresses by using them as a positional parameter while calling the "Get-GeoIP" function.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-GeoIP.ps1
  Author: Travis Logue
  Version History: 3.0 | 2021-02-09 | We changed the code to compensate for the missing 'hostname' property on many non-U.S. IP Addresses (manually added the 'hostname' property = null)
  Dependencies:
  Notes:
  - 2021-01-06 - There is a limitation of the 'ipinfo.io' API to only populate the 'hostname' field if the first IP that is looked up has a 'hostname' property; e.g. '24.0.125.224' vs. '2.27.1.14'

  
  .
#>
function Get-GeoIP {
  [CmdletBinding()]
  [Alias('GeoIP')]
  param (
    [Parameter(HelpMessage='Reference the IP Address to look up.',Mandatory=$true)]
    [string[]]
    $IPAddress
  )
  
  begin {}
  
  process {

    foreach ($IP in $IPAddress) {

      $LookupResults = Invoke-WebRequest -Uri "https://ipinfo.io/$IP/json" | ConvertFrom-Json

      # Here we are checking if the 'hostname' property exists, and if it doesn't we are adding to the object
      if ('hostname' -notin $LookupResults.PSobject.Properties.name  ) {
        $LookupResults | Add-Member -MemberType NoteProperty -Name hostname -Value $null
      }

      # Here we are standardizing the order the properties were displayed
      Write-Output ($LookupResults | Select-Object 'ip','hostname','city','region','country','loc','org','postal','timezone','readme')
       
    }
    
  }
  
  end {}
}





