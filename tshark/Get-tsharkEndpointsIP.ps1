<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> *Endpointsi <tab>
  PS C:\> Get-tsharkEndpointsIP

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*Endpointsi" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> Get-tsharkEndpointsIP -Pcap .\myTest.pcap  | ft *

  IPv4 Endpoints

  Filter:<No Filter>


  IPAddress       Packets Bytes   TxPackets TxBytes RxPackets RxBytes
  ---------       ------- -----   --------- ------- --------- -------
  99.86.84.73     2594    4154207 1391      4087497 1203      66710
  104.31.76.155   456     709329  281       694630  175       14699
  40.89.244.232   317     594690  156       578232  161       16458
  44.238.227.223  206     84580   103       55485   103       29095
  31.13.93.19     143     35641   73        25380   70        10261
  40.89.244.234   130     55302   65        47155   65        8147
  104.28.23.242   116     150893  67        146024  49        4869
  239.255.255.250 96      29398   0         0       96        29398
  192.0.78.22     79      21756   38        16320   41        5436
  192.0.73.2      77      48393   39        44239   38        4154
  151.101.194.110 56      20659   28        16956   28        3703
  192.0.77.32     54      42917   29        40063   25        2854
  199.232.9.7     41      11726   18        7896    23        3830
  224.0.0.251     37      8110    0         0       37        8110
  52.141.221.14   30      16442   12        14056   18        2386
  216.58.194.36   28      7056    15        5325    13        1731
  151.101.65.7    24      9703    9         7586    15        2117
  3.81.243.131    23      2932    11        1381    12        1551
  52.230.222.68   15      2032    5         1148    10        884
  224.0.0.13      7       420     0         0       7         420
  224.0.0.1       1       60      0         0       1         60
  224.0.0.5       1       60      0         0       1         60
  224.0.0.2       1       60      0         0       1         60



  Here we run the function by simplying referencing a packet capture.  The output consists of IPv4 endpoints found in the capture and statistical information concerning them.  In this capture we see multicast, public, and private IP addresses.

.EXAMPLE
  PS C:\> Get-tsharkEndpointsIP -Pcap .\myTest.pcap -FilterSet PublicIP  | ft *

  IPv4 Endpoints - Public IP Addresses

  Filter:( !(ip.src==10.0.0.0/8) && !(ip.src==172.16.0.0/12) && !(ip.src==192.168.0.0/16) ) || ( !(ip.dst==10.0.0.0/8) && !(ip.dst==172.16.0.0/12) && !(ip.dst==192.168.0.0/16) )  &&  !(ip.addr==224.0.0.0/4)


  IPAddress       Packets Bytes   TxPackets TxBytes RxPackets RxBytes
  ---------       ------- -----   --------- ------- --------- -------
  99.86.84.73     2594    4154207 1391      4087497 1203      66710
  104.31.76.155   456     709329  281       694630  175       14699
  40.89.244.232   317     594690  156       578232  161       16458
  44.238.227.223  206     84580   103       55485   103       29095
  31.13.93.19     143     35641   73        25380   70        10261
  40.89.244.234   130     55302   65        47155   65        8147
  104.28.23.242   116     150893  67        146024  49        4869
  192.0.78.22     79      21756   38        16320   41        5436
  192.0.73.2      77      48393   39        44239   38        4154
  151.101.194.110 56      20659   28        16956   28        3703
  192.0.77.32     54      42917   29        40063   25        2854
  199.232.9.7     41      11726   18        7896    23        3830
  52.141.221.14   30      16442   12        14056   18        2386
  216.58.194.36   28      7056    15        5325    13        1731
  151.101.65.7    24      9703    9         7586    15        2117
  3.81.243.131    23      2932    11        1381    12        1551
  52.230.222.68   15      2032    5         1148    10        884

  

  Here we run the function by referencing a packet capture and specifying "-FilterSet PublicIP".  The output consists of IPv4 endpoints found in the capture which are Public IP addresses and statistical information concerning them.

.EXAMPLE
  PS C:\> Get-tsharkEndpointsIP -Pcap .\myTest.pcap -FilterSet PrivateIP  | ft *

  IPv4 Endpoints - Private IP Addresses (RFC1918)

  Filter:(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)


  IPAddress       Packets Bytes   TxPackets TxBytes RxPackets RxBytes
  ---------       ------- -----   --------- ------- --------- -------
  10.44.29.235    7576    3892322 4625      3502191 2951      390131
  10.30.40.5      6653    3256978 2623      244489  4030      3012489
  10.30.73.152    636     602810  205       127638  431       475172
  10.5.5.5        223     25745   111       16526   112       9219
  10.44.29.255    34      3279    0         0       34        3279
  10.30.76.33     26      3351    11        1418    15        1933
  192.168.146.143 3       276     0         0       3         276
  10.30.80.71     2       126     1         60      1         66
  10.44.29.252    1       243     1         243     0         0



  Here we run the function by referencing a packet capture and specifying "-FilterSet PrivateIP".  The output consists of IPv4 endpoints found in the capture which are Private IP addresses (RFC1918) and statistical information concerning them.

.EXAMPLE
  PS C:\> Get-tsharkEndpointsIP -Pcap .\myTest.pcap -FilterSet Multicast  | ft *

  IPv4 Endpoints - Multicast Addresses

  Filter:(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)


  IPAddress       Packets Bytes TxPackets TxBytes RxPackets RxBytes
  ---------       ------- ----- --------- ------- --------- -------
  239.255.255.250 96      29398 0         0       96        29398
  224.0.0.251     37      8110  0         0       37        8110
  224.0.0.13      7       420   0         0       7         420
  224.0.0.1       1       60    0         0       1         60
  224.0.0.5       1       60    0         0       1         60
  224.0.0.2       1       60    0         0       1         60



  Here we run the function by referencing a packet capture and specifying "-FilterSet Multicast".  The output consists of IPv4 endpoints found in the capture which are Multicast addresses and statistical information concerning them.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkEndpointsIP
  Author: Travis Logue
  Version History: 1.0 | 2020-12-31 | Initial Version
  Dependencies:
  Notes:
  - This was helpful for the reference of the CIDR notation for the Multicast address supernet: https://en.wikipedia.org/wiki/Multicast_address

  
  .
#>
function Get-tsharkEndpointsIP {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.',Mandatory=$true)]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This paramater contains a Validate Set Attribute. Choose from the following options: "PublicIP","PrivateIP","Multicast". You may use the <tab> key to toggle through or to auto-complete.')]
    [ValidateSet("PublicIP","PrivateIP","Multicast")]
    [string]
    $FilterSet
  )
  
  begin {}
  
  process {

    if ($FilterSet) {
      switch ($FilterSet) {
        
        "PublicIP" { 
          <# This didn't work because packets from 10.x.x.x to 192.168.x.x were still displayed with this syntax#>
          #$DisplayFilter = "(ip.addr!=10.0.0.0/8) && (ip.addr!=172.16.0.0/12) && (ip.addr!=192.168.0.0/16) && !(ip.addr==224.0.0.0/4)"
          $DisplayFilter = "( !(ip.src==10.0.0.0/8) && !(ip.src==172.16.0.0/12) && !(ip.src==192.168.0.0/16) ) || ( !(ip.dst==10.0.0.0/8) && !(ip.dst==172.16.0.0/12) && !(ip.dst==192.168.0.0/16) )  &&  !(ip.addr==224.0.0.0/4)"
          $Header = "`nIPv4 Endpoints - Public IP Addresses`n"
        }
        "PrivateIP" { 
          $DisplayFilter = "(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)" 
          $Header = "`nIPv4 Endpoints - Private IP Addresses (RFC1918)`n"
        }
        "Multicast" { 
          $DisplayFilter = "(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)"
          $Header = "`nIPv4 Endpoints - Multicast Addresses`n" 
        }

      }
    }

    if ($DisplayFilter) {
      $Endpoints = tshark.exe -r $Pcap -q -z endpoints,ip,$DisplayFilter 
    }
    else {
      $Endpoints = tshark.exe -r $Pcap -q -z endpoints,ip
      $Header = $Endpoints | Select-Object -Skip 1 -First 1
      $Header = $Header.Insert(0,"`n") + "`n"
    }

    $FilterHeader = $Endpoints | Select-Object -Skip 2 -First 1
    Write-Host "$Header" -BackgroundColor Black -ForegroundColor Yellow
    Write-Host "$FilterHeader`n" -BackgroundColor Black -ForegroundColor Yellow

    $TrimTopAndBottom = $Endpoints | Select-Object -Skip 4 | Select-Object -SkipLast 1
    $ObjectForm = $TrimTopAndBottom -replace "\s+","`t" | ConvertFrom-Csv -Delimiter "`t" -Header 'IPAddress','Packets','Bytes','TxPackets','TxBytes','RxPackets','RxBytes'

    if ($FilterSet -like "PrivateIP") {
      $Final = $ObjectForm | Where-Object {$_.IPAddress -match '^10\.|^172\.[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|^192\.168\.'}
    }
    else {
      $Final = $ObjectForm | Where-Object {$_.IPAddress -notmatch '^10\.|^172\.[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|^192\.168\.'}
    }     

    Write-Output $Final
    
  }
  
  end {}
}