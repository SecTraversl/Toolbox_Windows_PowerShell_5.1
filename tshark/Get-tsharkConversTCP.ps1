<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> *conversu <tab>
  PS C:\> Get-tsharkConversTCP



  Here we are demonstrating a fast way to invoke this function.  Simply typing "*converst" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Convers_NoFilter = Get-tsharkConversTCP -Pcap .\myTest.pcap

  TCP Conversations

  Filter:<No Filter>


  PS C:\> $Convers_NoFilter | ft *

  IP1                Dir IP2                 <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                 -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5:62876   <-> 10.44.29.235:3389   1105     70037   1781     176539  2886      246576   0.118706000   94.8141
  10.44.29.235:19494 <-> 99.86.84.73:443     1391     4087497 1203     66710   2594      4154207  70.847163000  16.5633
  10.44.29.235:19458 <-> 104.31.76.155:443   281      694630  169      14147   450       708777   32.515518000  26.7282
  10.44.29.235:19442 <-> 40.89.244.232:443   156      578232  155      15906   311       594138   16.473668000  61.0515
  10.44.29.235:19462 <-> 172.217.9.163:443   149      242279  109      7221    258       249500   37.153620000  45.6165
  10.44.29.235:19436 <-> 10.30.73.152:5985   40       8600    120      166243  160       174843   10.316346000  60.8515
  10.44.29.235:19437 <-> 10.30.73.152:5985   32       8120    100      135262  132       143382   10.334438000  75.8111
  10.44.29.235:19474 <-> 10.30.73.152:5985   46       92952   45       14898   91        107850   38.634762000  0.6569
  10.44.29.235:19457 <-> 104.28.23.242:443   55       140250  34       2809    89        143059   20.051517000  45.0626
  10.44.29.235:19471 <-> 192.0.78.22:443     38       16320   35       4884    73        21204    37.607607000  31.6547
  10.44.29.235:19465 <-> 31.13.93.19:443     33       10411   35       5406    68        15817    37.555547000  45.4128
  10.44.29.235:19452 <-> 40.89.244.234:443   36       25764   31       3358    67        29122    18.283440000  76.4447
  10.44.29.235:19464 <-> 192.0.77.32:443     29       40063   25       2854    54        42917    37.383245000  45.6312
  10.44.29.235:19473 <-> 192.0.73.2:443      29       37411   24       2577    53        39988    38.303890000  12.5372
  10.44.29.235:19433 <-> 10.30.73.152:5985   13       960     33       44542   46        45502    10.171788000  0.2141
  10.44.29.235:19487 <-> 44.238.227.223:443  23       12289   23       8495    46        20784    70.110504000  21.2215
  10.44.29.235:19434 <-> 10.30.73.152:5985   12       900     30       38733   42        39633    10.181447000  0.2138
  10.44.29.235:19449 <-> 44.238.227.223:443  19       6387    21       7636    40        14023    17.091486000  0.0356
  10.44.29.235:19445 <-> 44.238.227.223:443  17       6273    20       7583    37        13856    17.029421000  0.0663
  10.44.29.235:19441 <-> 151.101.194.110:443 18       9822    17       2373    35        12195    12.285935000  46.0418
  10.44.29.235:19460 <-> 172.217.14.170:443  20       6924    15       2002    35        8926     36.114739000  45.2508
  10.44.29.235:19438 <-> 172.217.9.141:443   15       5517    14       1863    29        7380     11.625543000  45.2858
  10.44.29.235:19435 <-> 10.30.73.152:5985   8        2774    20       21872   28        24646    10.301071000  0.2850
  10.44.29.235:19461 <-> 216.58.194.36:443   15       5325    13       1731    28        7056     36.811137000  45.2561
  10.44.29.235:19475 <-> 10.30.73.152:5985   11       3150    15       9516    26        12666    38.965709000  0.3255
  10.44.29.235:19432 <-> 10.30.73.152:5985   8        660     17       19056   25        19716    10.160515000  0.1718



  Here we run the function by simplying referencing a packet capture.  The output consists of TCP Conversations found in the capture and statistical information concerning those conversations.  In this capture we see public and private IP addresses.

.EXAMPLE
  PS C:\> $Convers_PublicIP = Get-tsharkConversTCP -Pcap .\myTest.pcap -FilterSet PublicIP

  TCP Conversations containing Public IP Addresses and excluding Multicast

  Filter:( !(ip.src==10.0.0.0/8) && !(ip.src==172.16.0.0/12) && !(ip.src==192.168.0.0/16) ) || ( !(ip.dst==10.0.0.0/8) && !(ip.dst==172.16.0.0/12) && !(ip.dst==192.168.0.0/16) )  &&  !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PublicIP | ft *

  IP1                Dir IP2                 <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                 -------- ------- -------- ------- --------- -------- ------------- --------
  10.44.29.235:19494 <-> 99.86.84.73:443     1391     4087497 1203     66710   2594      4154207  70.847163000  16.5633
  10.44.29.235:19458 <-> 104.31.76.155:443   281      694630  169      14147   450       708777   32.515518000  26.7282
  10.44.29.235:19442 <-> 40.89.244.232:443   156      578232  155      15906   311       594138   16.473668000  61.0515
  10.44.29.235:19462 <-> 172.217.9.163:443   149      242279  109      7221    258       249500   37.153620000  45.6165
  10.44.29.235:19457 <-> 104.28.23.242:443   55       140250  34       2809    89        143059   20.051517000  45.0626
  10.44.29.235:19471 <-> 192.0.78.22:443     38       16320   35       4884    73        21204    37.607607000  31.6547
  10.44.29.235:19465 <-> 31.13.93.19:443     33       10411   35       5406    68        15817    37.555547000  45.4128
  10.44.29.235:19452 <-> 40.89.244.234:443   36       25764   31       3358    67        29122    18.283440000  76.4447
  10.44.29.235:19464 <-> 192.0.77.32:443     29       40063   25       2854    54        42917    37.383245000  45.6312
  10.44.29.235:19473 <-> 192.0.73.2:443      29       37411   24       2577    53        39988    38.303890000  12.5372
  10.44.29.235:19487 <-> 44.238.227.223:443  23       12289   23       8495    46        20784    70.110504000  21.2215
  10.44.29.235:19449 <-> 44.238.227.223:443  19       6387    21       7636    40        14023    17.091486000  0.0356
  10.44.29.235:19445 <-> 44.238.227.223:443  17       6273    20       7583    37        13856    17.029421000  0.0663
  10.44.29.235:19441 <-> 151.101.194.110:443 18       9822    17       2373    35        12195    12.285935000  46.0418
  10.44.29.235:19460 <-> 172.217.14.170:443  20       6924    15       2002    35        8926     36.114739000  45.2508
  10.44.29.235:19438 <-> 172.217.9.141:443   15       5517    14       1863    29        7380     11.625543000  45.2858
  10.44.29.235:19461 <-> 216.58.194.36:443   15       5325    13       1731    28        7056     36.811137000  45.2561
  10.44.29.235:19450 <-> 52.141.221.14:443   12       14056   12       1834    24        15890    17.435128000  45.7569
  10.44.29.235:19488 <-> 199.232.9.7:443     11       6928    10       1741    21        8669     70.158620000  0.1772
  10.44.29.235:19489 <-> 104.28.23.242:443   12       5774    9        1508    21        7282     70.193460000  0.0569
  10.44.29.235:19439 <-> 151.101.65.7:443    9        7586    9        1565    18        9151     11.669383000  45.0844
  10.44.29.235:19440 <-> 151.101.194.110:443 10       7134    8        1054    18        8188     12.285624000  0.0216
  10.44.29.235:19472 <-> 192.0.73.2:443      10       6828    8        1025    18        7853     38.303651000  0.0344

  

  Here we run the function by referencing a packet capture and specifying "-FilterSet PublicIP".  The output consists of TCP Conversations found in the capture where a Public IP address is part of the conversation.  This Filter Set excludes Multicast addresses.

.EXAMPLE
  PS C:\> $Convers_PvtIpOnly = Get-tsharkConversTCP -Pcap .\myTest.pcap -FilterSet PrivateIPOnly

  TCP Conversations containing Private IP Addresses (RFC1918) Only

  Filter:(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PvtIpOnly | ft *

  IP1                Dir IP2                <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5:62876   <-> 10.44.29.235:3389  1105     70037   1781     176539  2886      246576   0.118706000   94.8141
  10.44.29.235:19436 <-> 10.30.73.152:5985  40       8600    120      166243  160       174843   10.316346000  60.8515
  10.44.29.235:19437 <-> 10.30.73.152:5985  32       8120    100      135262  132       143382   10.334438000  75.8111
  10.44.29.235:19474 <-> 10.30.73.152:5985  46       92952   45       14898   91        107850   38.634762000  0.6569
  10.44.29.235:19433 <-> 10.30.73.152:5985  13       960     33       44542   46        45502    10.171788000  0.2141
  10.44.29.235:19434 <-> 10.30.73.152:5985  12       900     30       38733   42        39633    10.181447000  0.2138
  10.44.29.235:19435 <-> 10.30.73.152:5985  8        2774    20       21872   28        24646    10.301071000  0.2850
  10.44.29.235:19475 <-> 10.30.73.152:5985  11       3150    15       9516    26        12666    38.965709000  0.3255
  10.44.29.235:19432 <-> 10.30.73.152:5985  8        660     17       19056   25        19716    10.160515000  0.1718
  10.44.29.235:19483 <-> 10.30.73.152:5985  6        2654    8        5854    14        8508     56.278459000  0.1626
  10.44.29.235:19486 <-> 10.30.73.152:5985  6        2654    8        5797    14        8451     69.744556000  0.1665
  10.30.76.33:49670  <-> 10.44.29.235:19492 8        1215    6        844     14        2059     70.465031000  11.7401
  10.44.29.235:19481 <-> 10.30.73.152:5985  6        2654    7        4721    13        7375     49.085955000  0.1628
  10.30.40.5:63352   <-> 10.44.29.235:5985  6        4152    6        2587    12        6739     31.119625000  54.1702
  10.44.29.235:19482 <-> 10.30.73.152:5985  5        480     7        3145    12        3625     56.170269000  0.1591
  10.44.29.235:19491 <-> 10.30.76.33:135    5        574     7        718     12        1292     70.303593000  11.9018
  10.44.29.235:19485 <-> 10.30.73.152:5985  4        420     7        3088    11        3508     69.636137000  0.1592
  10.44.29.235:19480 <-> 10.30.73.152:5985  4        420     6        2013    10        2433     48.974290000  0.1624
  10.44.29.235:19417 <-> 10.30.73.152:5985  1        60      2        108     3         168      10.159894000  0.0528
  10.44.29.235:19362 <-> 10.30.73.152:5985  1        60      2        108     3         168      10.170781000  0.0529
  10.44.29.235:19421 <-> 10.30.73.152:5985  1        60      2        108     3         168      56.169790000  0.0529
  10.44.29.235:19430 <-> 10.30.73.152:5985  1        60      2        108     3         168      69.635541000  0.0539
  10.44.29.235:3850  <-> 10.30.80.71:445    1        60      1        66      2         126      14.889775000  0.0000
  10.30.40.5:63289   <-> 10.44.29.235:5985  1        54      0        0       1         54       28.552447000  0.0000



  Here we run the function by referencing a packet capture and specifying "-FilterSet PrivateIPOnly".  The output consists of TCP Conversations found in the capture where only Private IP addresses (RFC1918) are part of the conversation.  This Filter Set excludes Multicast addresses and Public IP addresses.

.EXAMPLE
  PS C:\> $Convers_Multicast = Get-tsharkConversTCP -Pcap .\myTest.pcap -FilterSet Multicast

  TCP Conversations containing Multicast Addresses

  Filter:(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)


  PS C:\> $Convers_Multicast | ft *
  PS C:\>
  PS C:\>



  Here we run the function by referencing a packet capture and specifying "-FilterSet Multicast".  The output consists of TCP Conversations found in the capture where a Multicast address is part of the conversation... which doesn't occur because Multicast traffic would be UDP only.  https://stackoverflow.com/questions/21266008/can-i-use-broadcast-or-multicast-for-tcp

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkConversTCP
  Author: Travis Logue
  Version History: 1.0 | 2020-12-31 | Initial Version
  Dependencies:
  Notes:
  - This was helpful for the reference of the CIDR notation for the Multicast address supernet: https://en.wikipedia.org/wiki/Multicast_address
  - This was helpful as a reference describing why Multicast addresses and TCP wouldn't be found in a packet capture: https://stackoverflow.com/questions/21266008/can-i-use-broadcast-or-multicast-for-tcp

  .
#>
function Get-tsharkConversTCP {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.',Mandatory=$true)]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This paramater contains a Validate Set Attribute. Choose from the following options: "PublicIP","PrivateIPOnly","Multicast". You may use the <tab> key to toggle through or to auto-complete.')]
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

          $Header = "`nTCP Conversations containing Public IP Addresses and excluding Multicast`n"
        }
        "PrivateIPOnly" { 
          $DisplayFilter = "(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)" 
          $Header = "`nTCP Conversations containing Private IP Addresses (RFC1918) Only`n"
        }
        "Multicast" { 
          $DisplayFilter = "(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)"
          $Header = "`nTCP Conversations containing Multicast Addresses`n" 
        }

      }
    }

    if ($DisplayFilter) {
      $Convers = tshark.exe -r $Pcap -q -z conv,tcp,$DisplayFilter
    }
    else {
      $Convers = tshark.exe -r $Pcap -q -z conv,tcp
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