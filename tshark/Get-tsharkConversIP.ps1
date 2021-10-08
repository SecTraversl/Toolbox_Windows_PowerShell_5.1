<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> *ConversI <tab>
  PS C:\> Get-tsharkConversIP

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*ConversI" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Convers_NoFilter = Get-tsharkConversIP -Pcap .\myTest.pcap

  IPv4 Conversations

  Filter:<No Filter>


  PS C:\> $Convers_NoFilter | ft *

  IP1          Dir IP2             <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---          --- ---             -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5   <-> 10.44.29.235    4030     3012489 2623     244489  6653      3256978  0.118706000   94.8141
  10.44.29.235 <-> 99.86.84.73     1391     4087497 1203     66710   2594      4154207  70.847163000  16.5633
  10.30.73.152 <-> 10.44.29.235    431      475172  205      127638  636       602810   10.159894000  75.9857
  10.44.29.235 <-> 104.31.76.155   281      694630  175      14699   456       709329   32.515518000  26.7282
  10.44.29.235 <-> 40.89.244.232   156      578232  161      16458   317       594690   16.473668000  61.0515
  10.44.29.235 <-> 172.217.9.163   155      245891  116      8192    271       254083   37.153620000  45.6165
  10.9.8.7     <-> 10.44.29.235    112      9219    111      16526   223       25745    8.292020000   64.7679
  10.44.29.235 <-> 44.238.227.223  103      55485   103      29095   206       84580    17.028562000  74.3034
  10.44.29.235 <-> 31.13.93.19     73       25380   70       10261   143       35641    37.555547000  45.4128
  10.44.29.235 <-> 40.89.244.234   65       47155   65       8147    130       55302    18.283039000  76.4451
  10.44.29.235 <-> 104.28.23.242   67       146024  49       4869    116       150893   20.051517000  50.1989
  10.44.29.235 <-> 192.0.78.22     38       16320   41       5436    79        21756    37.607607000  31.6547
  10.44.29.235 <-> 192.0.73.2      39       44239   38       4154    77        48393    38.303651000  12.5374
  10.44.29.235 <-> 151.101.194.110 28       16956   28       3703    56        20659    12.285624000  46.0421
  10.44.29.235 <-> 192.0.77.32     29       40063   25       2854    54        42917    37.383245000  45.6312
  10.44.29.235 <-> 172.217.14.170  27       10823   22       2973    49        13796    36.114496000  45.2510
  10.44.29.235 <-> 199.232.9.7     18       7896    23       3830    41        11726    70.158620000  11.3095
  10.44.29.220 <-> 224.0.0.251     0        0       35       7967    35        7967     11.566578000  82.2649



  Here we run the function by simplying referencing a packet capture.  The output consists of IP Conversations found in the capture and statistical information concerning those conversations.  In this capture we see multicast, public, and private IP addresses.

.EXAMPLE
  PS C:\> $Convers_PublicIP = Get-tsharkConversIP -Pcap .\myTest.pcap -FilterSet PublicIP

  IPv4 Conversations containing Public IP Addresses and excluding Multicast

  Filter:( !(ip.src==10.0.0.0/8) && !(ip.src==172.16.0.0/12) && !(ip.src==192.168.0.0/16) ) || ( !(ip.dst==10.0.0.0/8) && !(ip.dst==172.16.0.0/12) && !(ip.dst==192.168.0.0/16) )  &&  !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PublicIP |ft *

  IP1          Dir IP2             <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---          --- ---             -------- ------- -------- ------- --------- -------- ------------- --------
  10.44.29.235 <-> 99.86.84.73     1391     4087497 1203     66710   2594      4154207  70.847163000  16.5633
  10.44.29.235 <-> 104.31.76.155   281      694630  175      14699   456       709329   32.515518000  26.7282
  10.44.29.235 <-> 40.89.244.232   156      578232  161      16458   317       594690   16.473668000  61.0515
  10.44.29.235 <-> 172.217.9.163   155      245891  116      8192    271       254083   37.153620000  45.6165
  10.44.29.235 <-> 44.238.227.223  103      55485   103      29095   206       84580    17.028562000  74.3034
  10.44.29.235 <-> 31.13.93.19     73       25380   70       10261   143       35641    37.555547000  45.4128
  10.44.29.235 <-> 40.89.244.234   65       47155   65       8147    130       55302    18.283039000  76.4451
  10.44.29.235 <-> 104.28.23.242   67       146024  49       4869    116       150893   20.051517000  50.1989
  10.44.29.235 <-> 192.0.78.22     38       16320   41       5436    79        21756    37.607607000  31.6547
  10.44.29.235 <-> 192.0.73.2      39       44239   38       4154    77        48393    38.303651000  12.5374
  10.44.29.235 <-> 151.101.194.110 28       16956   28       3703    56        20659    12.285624000  46.0421
  10.44.29.235 <-> 192.0.77.32     29       40063   25       2854    54        42917    37.383245000  45.6312
  10.44.29.235 <-> 172.217.14.170  27       10823   22       2973    49        13796    36.114496000  45.2510
  10.44.29.235 <-> 199.232.9.7     18       7896    23       3830    41        11726    70.158620000  11.3095
  10.44.29.235 <-> 172.217.9.141   15       5517    20       8961    35        14478    11.624875000  45.2864
  10.44.29.235 <-> 52.141.221.14   12       14056   18       2386    30        16442    17.435128000  45.7569
  10.44.29.235 <-> 216.58.194.36   15       5325    13       1731    28        7056     36.811137000  45.2561
  10.44.29.235 <-> 151.101.65.7    9        7586    15       2117    24        9703     11.669383000  45.0844
  3.81.243.131 <-> 10.44.29.235    12       1551    11       1381    23        2932     8.309401000   60.5129
  10.44.29.235 <-> 52.230.222.68   5        1148    10       884     15        2032     1.350792000   90.1032

  

  Here we run the function by referencing a packet capture and specifying "-FilterSet PublicIP".  The output consists of IP Conversations found in the capture where a Public IP address is part of the conversation.  This Filter Set excludes Multicast addresses.

.EXAMPLE
  PS C:\> $Convers_PvtIpOnly = Get-tsharkConversIP -Pcap .\myTest.pcap -FilterSet PrivateIPOnly

  IPv4 Conversations containing Private IP Addresses (RFC1918) Only

  Filter:(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PvtIpOnly | ft *

  IP1          Dir IP2             <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---          --- ---             -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5   <-> 10.44.29.235    4030     3012489 2623     244489  6653      3256978  0.118706000   94.8141
  10.30.73.152 <-> 10.44.29.235    431      475172  205      127638  636       602810   10.159894000  75.9857
  10.9.8.7     <-> 10.44.29.235    112      9219    111      16526   223       25745    8.292020000   64.7679
  10.44.29.235 <-> 10.44.29.255    0        0       33       3036    33        3036     10.834146000  61.0343
  10.30.76.33  <-> 10.44.29.235    15       1933    11       1418    26        3351     70.303593000  11.9018
  10.44.29.235 <-> 192.168.146.143 0        0       3        276     3         276      58.453985000  3.0010
  10.30.80.71  <-> 10.44.29.235    1        66      1        60      2         126      14.889775000  0.0000
  10.44.29.252 <-> 10.44.29.255    0        0       1        243     1         243      7.533952000   0.0000



  Here we run the function by referencing a packet capture and specifying "-FilterSet PrivateIPOnly".  The output consists of IP Conversations found in the capture where only Private IP addresses (RFC1918) are part of the conversation.  This Filter Set excludes Multicast addresses and Public IP addresses.

.EXAMPLE
  PS C:\> $Convers_Multicast = Get-tsharkConversIP -Pcap .\myTest.pcap -FilterSet Multicast

  IPv4 Conversations containing Multicast Addresses

  Filter:(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)


  PS C:\> $Convers_Multicast | ft *

  IP1          Dir IP2             <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---          --- ---             -------- ------- -------- ------- --------- -------- ------------- --------
  10.44.29.220 <-> 224.0.0.251     0        0       35       7967    35        7967     11.566578000  82.2649
  10.44.29.235 <-> 239.255.255.250 0        0       15       2696    15        2696     1.030733000   75.1947
  10.44.41.184 <-> 239.255.255.250 0        0       14       4676    14        4676     2.045403000   90.3401
  10.44.41.203 <-> 239.255.255.250 0        0       12       4008    12        4008     6.081920000   75.2912
  10.44.46.222 <-> 239.255.255.250 0        0       7        2429    7         2429     0.000000000   90.1546
  10.44.46.228 <-> 239.255.255.250 0        0       7        2415    7         2415     1.455737000   90.1547
  10.44.46.250 <-> 239.255.255.250 0        0       7        2422    7         2422     2.115632000   90.1619
  10.44.46.218 <-> 239.255.255.250 0        0       7        2443    7         2443     3.532253000   90.1908
  10.44.46.251 <-> 239.255.255.250 0        0       7        2443    7         2443     3.801604000   90.1622
  10.44.29.1   <-> 224.0.0.13      0        0       7        420     7         420      10.070390000  71.1341
  10.44.46.223 <-> 239.255.255.250 0        0       6        2064    6         2064     9.641149000   75.1229
  10.44.46.221 <-> 239.255.255.250 0        0       6        2082    6         2082     11.482335000  75.1236
  10.44.29.241 <-> 239.255.255.250 0        0       4        860     4         860      66.079773000  3.0032
  10.44.29.238 <-> 239.255.255.250 0        0       4        860     4         860      66.996608000  3.0040
  10.44.29.1   <-> 224.0.0.1       0        0       1        60      1         60       7.776128000   0.0000
  10.44.29.1   <-> 224.0.0.5       0        0       1        60      1         60       9.203231000   0.0000
  10.44.29.241 <-> 224.0.0.251     0        0       1        60      1         60       9.706480000   0.0000
  10.44.29.1   <-> 224.0.0.2       0        0       1        60      1         60       13.252872000  0.0000
  10.44.29.226 <-> 224.0.0.251     0        0       1        83      1         83       61.297670000  0.0000



  Here we run the function by referencing a packet capture and specifying "-FilterSet Multicast".  The output consists of IP Conversations found in the capture where a Multicast address is part of the conversation.  

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkConversIP
  Author: Travis Logue
  Version History: 1.0 | 2020-12-31 | Initial Version
  Dependencies:
  Notes:
  - This was helpful for the reference of the CIDR notation for the Multicast address supernet: https://en.wikipedia.org/wiki/Multicast_address

  
  .
#>
function Get-tsharkConversIP {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.',Mandatory=$true)]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This parameter contains a Validate Set Attribute. Choose from the following options: "PublicIP","PrivateIPOnly","Multicast". You may use the <tab> key to toggle through or to auto-complete.')]
    [ValidateSet("PublicIP","PrivateIPOnly","Multicast")]
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

          $Header = "`nIPv4 Conversations containing Public IP Addresses and excluding Multicast`n"
        }
        "PrivateIPOnly" { 
          $DisplayFilter = "(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)" 
          $Header = "`nIPv4 Conversations containing Private IP Addresses (RFC1918) Only`n"
        }
        "Multicast" { 
          $DisplayFilter = "(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)"
          $Header = "`nIPv4 Conversations containing Multicast Addresses`n" 
        }

      }
    }

    if ($DisplayFilter) {
      $Convers = tshark.exe -r $Pcap -q -z conv,ip,$DisplayFilter
    }
    else {
      $Convers = tshark.exe -r $Pcap -q -z conv,ip
      $Header = $Convers | Select-Object -Skip 1 -First 1
      $Header = $Header.Insert(0,"`n") + "`n"
    }

    $FilterHeader = $Convers | Select-Object -Skip 2 -First 1
    Write-Host "$Header" -BackgroundColor Black -ForegroundColor Yellow
    Write-Host "$FilterHeader`n`n" -BackgroundColor Black -ForegroundColor Yellow

    $TrimTopAndBottom = $Convers | Select-Object -Skip 5 | Select-Object -SkipLast 1
    $ObjectForm = $TrimTopAndBottom -replace "\s+","`t" | ConvertFrom-Csv -Delimiter "`t" -Header 'IP1','Dir','IP2','<-Frames','<-Bytes','Frames->','Bytes->','AllFrames','AllBytes','RelativeStart','Duration'
    Write-Output $ObjectForm
    
  }
  
  end {}
}