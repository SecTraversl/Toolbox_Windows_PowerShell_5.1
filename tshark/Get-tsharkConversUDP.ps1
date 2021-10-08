<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> *conversu <tab>
  PS C:\> Get-tsharkConversUDP



  Here we are demonstrating a fast way to invoke this function.  Simply typing "*conversu" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Convers_NoFilter = Get-tsharkConversUDP -Pcap .\myTest.pcap

  UDP Conversations

  Filter:<No Filter>


  PS C:\> $Convers_NoFilter | ft *

  IP1                Dir IP2                  <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                  -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5:53850   <-> 10.44.29.235:3389    2918     2938246 836      65363   3754      3003609  0.118788000   94.2128
  10.44.29.220:5353  <-> 224.0.0.251:5353     0        0       35       7967    35        7967     11.566578000  82.2649
  10.44.29.235:137   <-> 10.44.29.255:137     0        0       33       3036    33        3036     10.834146000  61.0343
  10.44.41.184:1900  <-> 239.255.255.250:1900 0        0       14       4676    14        4676     2.045403000   90.3401
  10.44.41.203:1900  <-> 239.255.255.250:1900 0        0       12       4008    12        4008     6.081920000   75.2912
  10.44.29.235:54532 <-> 239.255.255.250:1900 0        0       10       1790    10        1790     1.030733000   75.1947
  10.44.46.222:1900  <-> 239.255.255.250:1900 0        0       7        2429    7         2429     0.000000000   90.1546
  10.44.46.228:1900  <-> 239.255.255.250:1900 0        0       7        2415    7         2415     1.455737000   90.1547
  10.44.46.250:1900  <-> 239.255.255.250:1900 0        0       7        2422    7         2422     2.115632000   90.1619
  10.44.46.218:1900  <-> 239.255.255.250:1900 0        0       7        2443    7         2443     3.532253000   90.1908
  10.44.46.251:1900  <-> 239.255.255.250:1900 0        0       7        2443    7         2443     3.801604000   90.1622
  10.44.46.223:1900  <-> 239.255.255.250:1900 0        0       6        2064    6         2064     9.641149000   75.1229
  10.44.46.221:1900  <-> 239.255.255.250:1900 0        0       6        2082    6         2082     11.482335000  75.1236
  10.44.29.235:56458 <-> 172.217.9.141:443    0        0       6        7098    6         7098     11.624875000  3.9998
  10.44.29.235:137   <-> 151.101.65.7:137     0        0       6        552     6         552      12.858969000  3.2651
  10.44.29.235:137   <-> 40.89.244.232:137    0        0       6        552     6         552      17.134275000  35.1924
  10.44.29.235:137   <-> 52.141.221.14:137    0        0       6        552     6         552      19.220760000  14.8727
  10.44.29.235:137   <-> 40.89.244.234:137    0        0       6        552     6         552      20.178889000  9.3514
  10.44.29.235:137   <-> 104.28.23.242:137    0        0       6        552     6         552      22.022590000  3.1135
  10.44.29.235:137   <-> 104.31.76.155:137    0        0       6        552     6         552      34.180877000  4.4677
  10.44.29.235:137   <-> 192.0.78.22:137      0        0       6        552     6         552      39.204785000  8.5632
  10.44.29.235:137   <-> 192.0.73.2:137       0        0       6        552     6         552      40.205910000  3.0012
  10.44.29.235:137   <-> 199.232.9.7:137      0        0       6        552     6         552      71.204363000  8.3979
  10.44.29.235:54160 <-> 239.255.255.250:1900 0        0       4        860     4         860      6.654986000   3.0028
  10.44.29.235:61273 <-> 10.9.8.7:53          2        190     2        158     4         348      11.556787000  0.1144



  Here we run the function by simplying referencing a packet capture.  The output consists of UDP Conversations found in the capture and statistical information concerning those conversations.  In this capture we see multicast, public, and private IP addresses.

.EXAMPLE
  PS C:\> $Convers_PublicIP = Get-tsharkConversUDP -Pcap .\myTest.pcap -FilterSet PublicIP

  UDP Conversations containing Public IP Addresses and excluding Multicast

  Filter:( !(ip.src==10.0.0.0/8) && !(ip.src==172.16.0.0/12) && !(ip.src==192.168.0.0/16) ) || ( !(ip.dst==10.0.0.0/8) && !(ip.dst==172.16.0.0/12) && !(ip.dst==192.168.0.0/16) )  &&  !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PublicIP | ft *

  IP1                Dir IP2                 <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                 -------- ------- -------- ------- --------- -------- ------------- --------
  10.44.29.235:56458 <-> 172.217.9.141:443   0        0       6        7098    6         7098     11.624875000  3.9998
  10.44.29.235:137   <-> 151.101.65.7:137    0        0       6        552     6         552      12.858969000  3.2651
  10.44.29.235:137   <-> 40.89.244.232:137   0        0       6        552     6         552      17.134275000  35.1924
  10.44.29.235:137   <-> 52.141.221.14:137   0        0       6        552     6         552      19.220760000  14.8727
  10.44.29.235:137   <-> 40.89.244.234:137   0        0       6        552     6         552      20.178889000  9.3514
  10.44.29.235:137   <-> 104.28.23.242:137   0        0       6        552     6         552      22.022590000  3.1135
  10.44.29.235:137   <-> 104.31.76.155:137   0        0       6        552     6         552      34.180877000  4.4677
  10.44.29.235:137   <-> 192.0.78.22:137     0        0       6        552     6         552      39.204785000  8.5632
  10.44.29.235:137   <-> 192.0.73.2:137      0        0       6        552     6         552      40.205910000  3.0012
  10.44.29.235:137   <-> 199.232.9.7:137     0        0       6        552     6         552      71.204363000  8.3979
  10.44.29.235:137   <-> 151.101.194.110:137 0        0       3        276     3         276      53.891931000  3.0058

  

  Here we run the function by referencing a packet capture and specifying "-FilterSet PublicIP".  The output consists of UDP Conversations found in the capture where a Public IP address is part of the conversation.  This Filter Set excludes Multicast addresses.

.EXAMPLE
  PS C:\> $Convers_PvtIpOnly = Get-tsharkConversUDP -Pcap .\myTest.pcap -FilterSet PrivateIPOnly

  UDP Conversations containing Private IP Addresses (RFC1918) Only

  Filter:(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)


  PS C:\> $Convers_PvtIpOnly | ft *

  IP1                Dir IP2                 <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                 -------- ------- -------- ------- --------- -------- ------------- --------
  10.30.40.5:53850   <-> 10.44.29.235:3389   2918     2938246 836      65363   3754      3003609  0.118788000   94.2128
  10.44.29.235:137   <-> 10.44.29.255:137    0        0       33       3036    33        3036     10.834146000  61.0343
  10.44.29.235:61273 <-> 10.9.8.7:53         2        190     2        158     4         348      11.556787000  0.1144
  10.44.29.235:56457 <-> 10.9.8.7:53         2        382     2        160     4         542      11.578695000  0.1154
  10.44.29.235:60547 <-> 10.9.8.7:53         2        398     2        168     4         566      12.196560000  0.1154
  10.44.29.235:56513 <-> 10.9.8.7:53         2        344     2        160     4         504      16.948500000  0.1156
  10.44.29.235:62156 <-> 10.9.8.7:53         2        322     2        172     4         494      17.132351000  0.1149
  10.44.29.235:60775 <-> 10.9.8.7:53         2        322     2        172     4         494      17.132568000  0.1147
  10.44.29.235:65396 <-> 10.9.8.7:53         2        334     2        184     4         518      17.132595000  0.1145
  10.44.29.235:55270 <-> 10.9.8.7:53         2        302     2        174     4         476      17.361523000  0.1157
  10.44.29.235:54057 <-> 10.9.8.7:53         2        248     2        152     4         400      19.988011000  0.1145
  10.44.29.235:50677 <-> 10.9.8.7:53         2        330     2        172     4         502      20.073463000  0.1151
  10.44.29.235:58542 <-> 10.9.8.7:53         2        296     2        172     4         468      21.946657000  0.1159
  10.44.29.235:61946 <-> 10.9.8.7:53         2        252     2        156     4         408      32.411016000  0.1152
  10.44.29.235:49867 <-> 10.9.8.7:53         2        296     2        172     4         468      34.105693000  0.1145
  10.44.29.235:58163 <-> 10.9.8.7:53         2        290     2        162     4         452      36.710.30.00  0.1149
  10.44.29.235:56543 <-> 10.9.8.7:53         2        188     2        156     4         344      36.710424000  0.1146
  10.44.29.235:56431 <-> 10.9.8.7:53         2        264     2        170     4         434      36.710533000  0.1153
  10.44.29.235:57117 <-> 10.9.8.7:53         2        268     2        170     4         438      36.776824000  0.1143
  10.44.29.235:55521 <-> 10.9.8.7:53         2        272     2        172     4         444      36.791524000  0.1155
  10.44.29.235:56220 <-> 10.9.8.7:53         2        272     2        156     4         428      37.481175000  0.1142
  10.44.29.235:62697 <-> 10.9.8.7:53         2        298     2        168     4         466      39.112048000  0.1145
  10.44.29.235:54056 <-> 10.9.8.7:53         2        296     2        166     4         462      40.112885000  0.1145
  10.44.29.235:49993 <-> 10.9.8.7:53         2        238     2        146     4         384      70.093951000  0.1152
  10.44.29.235:54105 <-> 10.9.8.7:53         2        388     2        174     4         562      72.944037000  0.1158
  10.44.29.235:50183 <-> 10.9.8.7:53         1        165     2        172     3         337      19.072812000  0.1474
  10.44.29.235:137   <-> 192.168.146.143:137 0        0       3        276     3         276      58.453985000  3.0010



  Here we run the function by referencing a packet capture and specifying "-FilterSet PrivateIPOnly".  The output consists of UDP Conversations found in the capture where only Private IP addresses (RFC1918) are part of the conversation.  This Filter Set excludes Multicast addresses and Public IP addresses.

.EXAMPLE
  PS C:\> $Convers_Multicast = Get-tsharkConversUDP -Pcap .\myTest.pcap -FilterSet Multicast

  UDP Conversations containing Multicast Addresses

  Filter:(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)


  PS C:\> $Convers_Multicast | ft *

  IP1                Dir IP2                  <-Frames <-Bytes Frames-> Bytes-> AllFrames AllBytes RelativeStart Duration
  ---                --- ---                  -------- ------- -------- ------- --------- -------- ------------- --------
  10.44.29.220:5353  <-> 224.0.0.251:5353     0        0       35       7967    35        7967     11.566578000  82.2649
  10.44.41.184:1900  <-> 239.255.255.250:1900 0        0       14       4676    14        4676     2.045403000   90.3401
  10.44.41.203:1900  <-> 239.255.255.250:1900 0        0       12       4008    12        4008     6.081920000   75.2912
  10.44.29.235:54532 <-> 239.255.255.250:1900 0        0       10       1790    10        1790     1.030733000   75.1947
  10.44.46.222:1900  <-> 239.255.255.250:1900 0        0       7        2429    7         2429     0.000000000   90.1546
  10.44.46.228:1900  <-> 239.255.255.250:1900 0        0       7        2415    7         2415     1.455737000   90.1547
  10.44.46.250:1900  <-> 239.255.255.250:1900 0        0       7        2422    7         2422     2.115632000   90.1619
  10.44.46.218:1900  <-> 239.255.255.250:1900 0        0       7        2443    7         2443     3.532253000   90.1908
  10.44.46.251:1900  <-> 239.255.255.250:1900 0        0       7        2443    7         2443     3.801604000   90.1622
  10.44.46.223:1900  <-> 239.255.255.250:1900 0        0       6        2064    6         2064     9.641149000   75.1229
  10.44.46.221:1900  <-> 239.255.255.250:1900 0        0       6        2082    6         2082     11.482335000  75.1236
  10.44.29.235:54160 <-> 239.255.255.250:1900 0        0       4        860     4         860      6.654986000   3.0028
  10.44.29.241:56792 <-> 239.255.255.250:1900 0        0       4        860     4         860      66.079773000  3.0032
  10.44.29.238:58561 <-> 239.255.255.250:1900 0        0       4        860     4         860      66.996608000  3.0040
  10.44.29.226:5353  <-> 224.0.0.251:5353     0        0       1        83      1         83       61.297670000  0.0000



  Here we run the function by referencing a packet capture and specifying "-FilterSet Multicast".  The output consists of UDP Conversations found in the capture where a Multicast address is part of the conversation.  

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkConversUDP
  Author: Travis Logue
  Version History: 1.0 | 2020-12-31 | Initial Version
  Dependencies:
  Notes:
  - This was helpful for the reference of the CIDR notation for the Multicast address supernet: https://en.wikipedia.org/wiki/Multicast_address

  .
#>
function Get-tsharkConversUDP {
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

          $Header = "`nUDP Conversations containing Public IP Addresses and excluding Multicast`n"
        }
        "PrivateIPOnly" { 
          $DisplayFilter = "(ip.src==10.0.0.0/8 || ip.src==172.16.0.0/12 || ip.src==192.168.0.0/16) && (ip.dst==10.0.0.0/8 || ip.dst==172.16.0.0/12 || ip.dst==192.168.0.0/16) && !(ip.addr==224.0.0.0/4)" 
          $Header = "`nUDP Conversations containing Private IP Addresses (RFC1918) Only`n"
        }
        "Multicast" { 
          $DisplayFilter = "(ip.src==224.0.0.0/4 || ip.dst==224.0.0.0/4)"
          $Header = "`nUDP Conversations containing Multicast Addresses`n" 
        }

      }
    }

    if ($DisplayFilter) {
      $Convers = tshark.exe -r $Pcap -q -z conv,udp,$DisplayFilter
    }
    else {
      $Convers = tshark.exe -r $Pcap -q -z conv,udp
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