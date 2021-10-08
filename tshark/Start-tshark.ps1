<#
.SYNOPSIS
  The "Start-tshark" function is a wrapper for 'tshark.exe' allowing for the capture of packets based off of an IP address, a network address, port, protocol, or any other Capture Filter.  By default, packets will display in the terminal; however, the packets can also be written to a file by using the "-WriteCaptureFile" parameter or by using its alias "-w". Additionally, this tool was created with multiple "Filter Sets" that allow for instant filtering via pre-built Capture Filters. Valid "-FilterSet" arguments include: EthernetOnly, PublicIP, PrivateIPOnly, and Multicast.  See the examples for "-FilterSet" uses.

.DESCRIPTION
.EXAMPLE
  PS C:\> s*tshar <tab>
  PS C:\> Start-tshark

  PS C:\> tsharkStart -c 5 -n
  Capturing on 5 interfaces
      1   0.000000   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      2   0.090892 18.211.133.65 -> 10.80.7.56   TCP 60 443 -> 64019 [ACK] Seq=1 Ack=57 Win=10 Len=0
      3   0.091594 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      4   0.132063   10.80.7.56 -> 18.211.133.65 TCP 54 64019 -> 443 [ACK] Seq=57 Ack=57 Win=511 Len=0
      5   1.142657 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
  5 packets captured

  

  Here we are demonstrating fast ways to invoke this function.  Simply typing "s*tshar" and then pressing the Tab key should result in the full function name.  Additionally, using the function's built-in alias of "tsharkStart" or "tsharkS <tab>" also allows for quick invocation of this tool.

.EXAMPLE
  PS C:\> Start-Job {ping 8.8.8.8 -t}

  Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
  --     ----            -------------   -----         -----------     --------             -------
  11     Job11           BackgroundJob   Running       True            localhost            ping 8.8.8.8 -t

  PS C:\> Get-tsharkInterfaces

  IntRef IntName                      IPAddress
  ------ -------                      ---------
  1      VirtualBox Host-Only Network {fe80::4197:6f04:9b14:c23%23, 192.168.56.1}
  3      Local Area Connection* 2     {fe80::30ad:2cac:352f:99fc%3, 169.254.153.252}
  4      Local Area Connection* 1     {fe80::945a:2c9e:b36d:8125%8, 169.254.129.37}
  5      Bluetooth Network Connection {fe80::8865:b625:88c1:3700%14, 169.254.55.0}
  8      Ethernet 6                   10.80.7.56
  9      Wi-Fi                        169.254.167.130
  11     Local Area Connection        {fe80::c57:a7d5:7b67:b520%20, 169.254.181.32}
  12     Ethernet 4                   169.254.103.89

  PS C:\> Start-tshark -Interface 8 -HostCaptureFilter 8.8.8.8
  Capturing on 'Ethernet 6'
    1   0.000000   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=2692/33802, ttl=128
    2   0.021079      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=2692/33802, ttl=116 (request in 1)
    3   1.001009   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=2693/34058, ttl=128
    4   1.021959      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=2693/34058, ttl=116 (request in 3)
    5   2.002009   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=2694/34314, ttl=128
    6   2.022351      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=2694/34314, ttl=116 (request in 5)
    7   3.002947   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=2695/34570, ttl=128
    8   3.023145      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=2695/34570, ttl=116 (request in 7)
    9   4.004697   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=2696/34826, ttl=128
   10   4.024981      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=2696/34826, ttl=116 (request in 9)
  10 packets captured

  PS C:\> Start-tshark -i 8 -host 8.8.8.8
  Capturing on 'Ethernet 6'
    1   0.000000   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=3726/36366, ttl=128
    2   0.020000      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=3726/36366, ttl=116 (request in 1)
    3   1.000954   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=3727/36622, ttl=128
    4   1.021283      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=3727/36622, ttl=116 (request in 3)
    5   2.002718   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=3728/36878, ttl=128
    6   2.023050      8.8.8.8 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=3728/36878, ttl=116 (request in 5)
    7   3.003572   10.80.7.56 -> 8.8.8.8      ICMP 74 Echo (ping) request  id=0x0001, seq=3729/37134, ttl=128
  7 packets captured



  Here we start a background job that is pinging "8.8.8.8".  We then use the "Get-tsharkInterfaces" function to identify the Interface Reference number we want to use in our capture.  We then invoke the "Start-tshark" function, referencing interface "8" and using the parameter of "-HostCaptureFilter" (also "-host" can be used since it is an alias for this parameter) in order to capture any traffic to or from the IP Address of 8.8.8.8.  Finally, we invoke "Start-tshark" one last time using the parameter aliases to show the same result.

.EXAMPLE
  PS C:\> Start-Job -ScriptBlock {ping 1.1.1.1 -t}
  Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
  --     ----            -------------   -----         -----------     --------             -------
  33     Job33           BackgroundJob   Running       True            localhost            ping 1.1.1.1 -t

  PS C:\> Start-tshark -host 1.1.1.1
  Capturing on 8 interfaces
      1   0.000000   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4875/2835, ttl=128
      2   0.020959      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4875/2835, ttl=58 (request in 1)
      3   1.000834   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4876/3091, ttl=128
      4   1.021886      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4876/3091, ttl=58 (request in 3)
      5   2.001625   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4877/3347, ttl=128
      6   2.022967      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4877/3347, ttl=58 (request in 5)
  1 packet dropped from Ethernet 6
  6 packets captured

  PS C:\>
  PS C:\> Start-tshark -net 1.1.0.0/16
  Capturing on 8 interfaces
      1   0.000000   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4946/21011, ttl=128
      2   0.020719      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4946/21011, ttl=58 (request in 1)
      3   1.001476   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4947/21267, ttl=128
      4   1.022136      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4947/21267, ttl=58 (request in 3)
      5   2.003584   10.80.7.56 -> 1.1.1.1      ICMP 74 Echo (ping) request  id=0x0001, seq=4948/21523, ttl=128
      6   2.024469      1.1.1.1 -> 10.80.7.56   ICMP 74 Echo (ping) reply    id=0x0001, seq=4948/21523, ttl=58 (request in 5)
  6 packets captured



  Here we start a background job that is pinging "1.1.1.1".  In these examples we did not specify an interface to capture on, so we are capturing on all interfaces.  The first example shows the use of the "-HostCaptureFilter" parameter using the alias of "-host".  The second example show the use of the "-NetworkCaptureFilter" parameter using the alias of "-net".

.EXAMPLE
  PS C:\> Start-tshark -f "src port 53"
  Capturing on 8 interfaces
      1   0.000000    10.80.7.1 -> 10.80.7.56   DNS 245 Standard query response 0x3a8b A outlook.office365.com CNAME outlook.ha.office365.com CNAME outlook.m
  s-acdc.office.com CNAME EAT-efz.ms-acdc.office.com A 40.97.119.82 A 52.96.121.2 A 52.96.113.130 A 40.97.84.34
      2   2.136960    10.80.7.1 -> 10.80.7.56   DNS 95 Standard query response 0x0db8 A allabouttesting.org A 192.185.129.21
      3   3.496993    10.80.7.1 -> 10.80.7.56   DNS 85 Standard query response 0x404c A c0.wp.com A 192.0.77.37
      4   3.879881    10.80.7.1 -> 10.80.7.56   DNS 147 Standard query response 0xbf86 A www.googletagmanager.com CNAME www-googletagmanager.l.google.com A 1
  42.250.69.200
      5   3.886745    10.80.7.1 -> 10.80.7.56   DNS 90 Standard query response 0xd46c A www.google.com A 142.250.69.196
      6   3.888025    10.80.7.1 -> 10.80.7.56   DNS 85 Standard query response 0x9075 A i2.wp.com A 192.0.77.2
      7   3.890609    10.80.7.1 -> 10.80.7.56   DNS 145 Standard query response 0x7e5d A pagead2.googlesyndication.com CNAME pagead46.l.doubleclick.net A 172
  .217.14.226
      8   3.890697    10.80.7.1 -> 10.80.7.56   DNS 85 Standard query response 0x1fa0 A i0.wp.com A 192.0.77.2
      9   3.893145    10.80.7.1 -> 10.80.7.56   DNS 85 Standard query response 0x54d0 A i1.wp.com A 192.0.77.2
     10   3.894133    10.80.7.1 -> 10.80.7.56   DNS 95 Standard query response 0xd8b5 A secure.gravatar.com A 192.0.73.2
     11   3.897203    10.80.7.1 -> 10.80.7.56   DNS 109 Standard query response 0x42c1 A cdn.onesignal.com A 104.18.226.52 A 104.18.225.52
     12   3.898282    10.80.7.1 -> 10.80.7.56   DNS 88 Standard query response 0x9179 A stats.wp.com A 192.0.76.3
     13   3.901552    10.80.7.1 -> 10.80.7.56   DNS 137 Standard query response 0x845e A ws-na.amazon-adsystem.com CNAME ws-na.assoc-amazon.com A 52.46.135.1
  32
     14   4.187341    10.80.7.1 -> 10.80.7.56   DNS 91 Standard query response 0xa5d3 A www.gstatic.com A 216.58.193.67
     15   5.064271    10.80.7.1 -> 10.80.7.56   DNS 132 Standard query response 0x60f3 A fonts.gstatic.com CNAME gstaticadssl.l.google.com A 172.217.3.195
     16  19.931172    10.80.7.1 -> 10.80.7.56   DNS 177 Standard query response 0x4ad0 A edgeapi.slack.com CNAME prod-haproxy-edge-nlb-eip-1a731160ba803b29.e
  lb.us-west-2.amazonaws.com A 54.214.87.230
  16 packets captured



  Here we start tshark and specify the "-FreeHandCaptureFilter" parameter by using its alias of "-f".  This parameter allows us to specify any valid capture filter syntax that we want (it's the equivalent of ' tshark -f "my favorite capture filter syntax" ' {For a capture filter syntax reference, visit: https://www.cellstream.com/reference-reading/tipsandtricks/379-top-10-wireshark-filters-2}).  After starting tshark with the capture filter, we then used a browser to visit "https://allabouttesting.org/tshark-basic-tutorial-with-practical-examples/", and we see all of the DNS requests related to visiting that website.  (Packet 1 and packet 16 are representative background chatter of Outlook and Slack and are not related to the visit of the website 'allabouttesting.org').

.EXAMPLE
  PS C:\> Start-tshark -f "multicast or broadcast" -i 8 -n -w non-unicast.pcap
  Capturing on 'Ethernet 6'
  9
  PS C:\> tshark.exe -nr .\non-unicast.pcap
    1   0.000000 f1:74:ba:8d:45:07 -> 02:40:f3:00:00:00 STP 53 RST. Root = 32768/0/f1:74:ba:8d:45:06  Cost = 0  Port = 0x8002
    2   1.262319    10.80.7.1 -> 233.89.188.1 UDP 60 37528 -> 10001 Len=4
    3   1.263537    10.80.7.1 -> 255.255.255.255 UDP 60 37528 -> 10001 Len=4
    4   1.999983 f1:74:ba:8d:45:07 -> 02:40:f3:00:00:00 STP 53 RST. Root = 32768/0/f1:74:ba:8d:45:06  Cost = 0  Port = 0x8002
    5   4.000204 f1:74:ba:8d:45:07 -> 02:40:f3:00:00:00 STP 53 RST. Root = 32768/0/f1:74:ba:8d:45:06  Cost = 0  Port = 0x8002
    6   4.362359 f1:74:ba:8d:45:07 -> 02:40:f3:00:00:0e LLDP 109 MA/f1:74:ba:8d:45:06 LA/Port 2 120 SysN=UBNT SysD=USW-8P-60, 4.3.20.11298, Linux 3.6.5
    7   4.459916    10.80.7.1 -> 233.89.188.1 UDP 60 47526 -> 10001 Len=4
    8   4.459973    10.80.7.1 -> 255.255.255.255 UDP 60 47526 -> 10001 Len=4
    9   6.000508 f1:74:ba:8d:45:07 -> 02:40:f3:00:00:00 STP 53 RST. Root = 32768/0/f1:74:ba:8d:45:06  Cost = 0  Port = 0x8002



  Here we demonstrate how to use the "-WriteCaptureFile" parameter using its alias of "-w".  We capture traffic based off of the specified interface and a Capture Filter, write the packets to a file called, "non-unicast.pcap", and then view that packet capture file using traditional tshark syntax.

.EXAMPLE
  PS C:\> tsharkInterfaces

  IntRef IntName                      IPAddress
  ------ -------                      ---------
  1      Local Area Connection* 13    10.30.40.4
  3      Bluetooth Network Connection {fe80::8865:b625:88c1:3700%14, 169.254.55.0}
  6      Ethernet 6                   10.80.7.56
  8      Local Area Connection        {fe80::c57:a7d5:7b67:b520%20, 169.254.181.32}
  9      Ethernet 4                   169.254.103.89


  PS C:\> tsharkStart -i 1,6 -FilterSet EthernetOnly -n -c 10
  Capturing on 2 interfaces
      1   0.000000 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      2   2.001192 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      3   4.000376 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      4   6.000508 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      5   8.000635 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      6  10.000725 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      7  12.000726 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      8  14.000984 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
      9  16.001025 e0:63:da:8d:45:07 -> 01:80:c2:00:00:00 STP 53 RST. Root = 32768/0/e0:63:da:8d:45:06  Cost = 0  Port = 0x8002
     10  16.563047 74:ac:b9:3b:e6:a9 -> 75:ED:BA:f3:6c:cb ARP 60 Who has 10.80.7.56? Tell 10.80.7.1
  1 packet dropped from Ethernet 6
  10 packets captured



  Here we start by invoking the function 'Get-tsharkInterfaces' by using its built-in alias "tsharkInterfaces". Then we run the function 'Start-tshark' using its built-in alias of "tsharkStart" and we reference interfaces '1' and '6' using the "-i" or "-Interface" parameter.  We also use the "-FilterSet" parameter which contains a Validate Set with the following options: EthernetOnly, PublicIP, PrivateIPOnly, and Multicast.  We are able to tab through the available options once "-FilterSet" has been referenced at the command line. In this example we specify "EthernetOnly" which will ignore the IP related traffic and shows the frames that are captured at Layer 2.  We also reference the "-NoNameResolution" parameter using the alias of "-n", as well as specifying how many packets to capture using the "-Count" parameter alias of "-c".

.EXAMPLE
  PS C:\> tsharkStart -i 1,6 -FilterSet PublicIP -n -c 10
  Capturing on 2 interfaces
      1   0.000000   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      2   0.090767 18.211.133.65 -> 10.80.7.56   TCP 60 443 -> 64157 [ACK] Seq=1 Ack=57 Win=10 Len=0
      3   0.091960 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      4   0.132940   10.80.7.56 -> 18.211.133.65 TCP 54 64157 -> 443 [ACK] Seq=57 Ack=57 Win=512 Len=0
      5   1.270331 52.96.121.130 -> 10.80.7.56   TLSv1.2 97 Application Data
      6   1.310404   10.80.7.56 -> 52.96.121.130 TCP 54 49369 -> 443 [ACK] Seq=1 Ack=44 Win=511 Len=0
      7   7.000150   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      8   7.099759 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      9   7.140658   10.80.7.56 -> 18.211.133.65 TCP 54 64315 -> 443 [ACK] Seq=57 Ack=57 Win=511 Len=0
    10   8.000004   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
  2 packets dropped from Ethernet 6
  10 packets captured
  PS C:\>
  PS C:\> tsharkStart -i 1,6 -host 18.211.133.65 -n -c 10
  Capturing on 2 interfaces
      1   0.000000   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      2   0.091506 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      3   0.131723   10.80.7.56 -> 18.211.133.65 TCP 54 64315 -> 443 [ACK] Seq=57 Ack=57 Win=511 Len=0
      4   0.999640   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      5   1.091161 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      6   1.131979   10.80.7.56 -> 18.211.133.65 TCP 54 64019 -> 443 [ACK] Seq=57 Ack=57 Win=510 Len=0
      7   3.000144   10.80.7.56 -> 18.211.133.65 TLSv1.2 110 Application Data
      8   3.093186 18.211.133.65 -> 10.80.7.56   TLSv1.2 110 Application Data
      9   3.133606   10.80.7.56 -> 18.211.133.65 TCP 54 64157 -> 443 [ACK] Seq=57 Ack=57 Win=511 Len=0
    10   5.568303   10.80.7.56 -> 18.211.133.65 TLSv1.2 112 Application Data
  3 packets dropped from Ethernet 6
  10 packets captured



  Here we run the function using "-FilterSet PublicIP" in order to capture only Internet bound traffic.  From that output we see an IP address of interest, and so run the tool again with "-host 18.211.133.65" to capture traffic specific to that IP Address.

.EXAMPLE
  PS C:\> tsharkStart -i 1,6 -FilterSet PrivateIPOnly -n -c 10
  Capturing on 2 interfaces
      1   0.000000   10.30.40.4 -> 10.30.73.152 TCP 66 64807 -> 5985 [SYN] Seq=0 Win=64896 Len=0 MSS=1352 WS=256 SACK_PERM=1
      2   0.000048   10.30.40.4 -> 10.30.73.152 TCP 66 [TCP Out-Of-Order] 64807 -> 5985 [SYN] Seq=0 Win=64896 Len=0 MSS=1352 WS=256 SACK_PERM=1
      3   0.070118 10.30.73.152 -> 10.30.40.4   TCP 66 5985 -> 64807 [SYN, ACK] Seq=0 Ack=1 Win=8192 Len=0 MSS=1460 WS=256 SACK_PERM=1
      4   0.070191   10.30.40.4 -> 10.30.73.152 TCP 54 64807 -> 5985 [ACK] Seq=1 Ack=1 Win=262144 Len=0
      5   0.070239   10.30.40.4 -> 10.30.73.152 TCP 54 [TCP Dup ACK 4#1] 64807 -> 5985 [ACK] Seq=1 Ack=1 Win=262144 Len=0
      6   0.070455   10.30.40.4 -> 10.30.73.152 TCP 1406 POST /wsman/SubscriptionManager/WEC HTTP/1.1  [TCP segment of a reassembled PDU]
      7   0.070455   10.30.40.4 -> 10.30.73.152 HTTP 1363 POST /wsman/SubscriptionManager/WEC HTTP/1.1
      8   0.070541   10.30.40.4 -> 10.30.73.152 TCP 1406 [TCP Out-Of-Order] 64807 -> 5985 [ACK] Seq=1 Ack=1 Win=262144 Len=1352
      9   0.070567   10.30.40.4 -> 10.30.73.152 TCP 1363 [TCP Retransmission] 64807 -> 5985 [PSH, ACK] Seq=1353 Ack=1 Win=262144 Len=1309
     10   0.145779 10.30.73.152 -> 10.30.40.4   TCP 54 5985 -> 64807 [ACK] Seq=1 Ack=2662 Win=131072 Len=0
  2 packets dropped from Local Area Connection* 13
  10 packets captured
  PS C:\>
  PS C:\> tsharkStart -i 1,6 -f "src net 10.0.0.0/8 and dst net 10.0.0.0/8 and not host 10.30.73.152" -n -c 10
  Capturing on 2 interfaces
      1   0.000000   10.80.7.56 -> 10.80.7.1    DNS 89 Standard query 0x8727 A ANWPORCBC03.corp.Roxboard.com
      2  -0.000945   10.30.40.4 -> 10.9.8.7     DNS 89 Standard query 0xf04c A ANWPORCBC03.corp.Roxboard.com
      3  -0.000868   10.30.40.4 -> 10.9.8.7     DNS 89 Standard query 0xf04c A ANWPORCBC03.corp.Roxboard.com
      4   0.000471    10.80.7.1 -> 10.80.7.56   DNS 89 Standard query response 0x8727 No such name A ANWPORCBC03.corp.Roxboard.com
      5   0.091011     10.9.8.7 -> 10.30.40.4   DNS 105 Standard query response 0xf04c A ANWPORCBC03.corp.Roxboard.com A 10.30.76.28
      6   0.093151   10.30.40.4 -> 10.30.76.28  TCP 66 64832 -> 445 [SYN] Seq=0 Win=64896 Len=0 MSS=1352 WS=256 SACK_PERM=1
      7   0.093214   10.30.40.4 -> 10.30.76.28  TCP 66 [TCP Out-Of-Order] 64832 -> 445 [SYN] Seq=0 Win=64896 Len=0 MSS=1352 WS=256 SACK_PERM=1
      8   0.183043  10.30.76.28 -> 10.30.40.4   TCP 66 445 -> 64832 [SYN, ACK] Seq=0 Ack=1 Win=8192 Len=0 MSS=1460 WS=256 SACK_PERM=1
      9   0.183140   10.30.40.4 -> 10.30.76.28  TCP 54 64832 -> 445 [ACK] Seq=1 Ack=1 Win=262144 Len=0
     10   0.183185   10.30.40.4 -> 10.30.76.28  TCP 54 [TCP Dup ACK 9#1] 64832 -> 445 [ACK] Seq=1 Ack=1 Win=262144 Len=0
  5 packets dropped from Local Area Connection* 13
  10 packets captured



  Here we run the function using "-FilterSet PrivateIPOnly" in order to capture only internal (RFC1918) traffic.  From that output we see an IP address we want to exclude from our capture, and so run the tool again with the appropriate "-f" Capture Filter syntax in order to continue to view 10.0.0.0/8 traffic while omitting traffic related to "10.30.73.152".

.EXAMPLE
  PS C:\> tsharkStart -i 1,6 -FilterSet Multicast -n -c 10
  Capturing on 2 interfaces
      1   0.000000    10.80.7.1 -> 233.89.188.1 UDP 60 37528 -> 10001 Len=4
      2   0.002459    10.80.7.1 -> 255.255.255.255 UDP 60 37528 -> 10001 Len=4
      3   8.065212    10.80.7.1 -> 233.89.188.1 UDP 60 47526 -> 10001 Len=4
      4   8.065251    10.80.7.1 -> 255.255.255.255 UDP 60 47526 -> 10001 Len=4
      5  10.011701    10.80.7.1 -> 233.89.188.1 UDP 60 37528 -> 10001 Len=4
      6  10.013328    10.80.7.1 -> 255.255.255.255 UDP 60 37528 -> 10001 Len=4
      7  18.566052    10.80.7.1 -> 233.89.188.1 UDP 60 47526 -> 10001 Len=4
      8  18.566087    10.80.7.1 -> 255.255.255.255 UDP 60 47526 -> 10001 Len=4
      9  20.020510    10.80.7.1 -> 233.89.188.1 UDP 60 37528 -> 10001 Len=4
     10  20.021257    10.80.7.1 -> 255.255.255.255 UDP 60 37528 -> 10001 Len=4
  10 packets captured



  Here we run the function using "-FilterSet Multicast" in order to capture only multicast traffic. 

.INPUTS
.OUTPUTS
.NOTES
  Name: Start-tshark.ps1
  Author: Travis Logue
  Version History: 3.0 | 2021-02-24 | Included the "-FilterSet" parameter and the "-Count" parameter
  Dependencies: tshark.exe parent directory needs to be in $env:Path
  Notes:
  - Good reference for tshark usage examples: https://www.cellstream.com/reference-reading/tipsandtricks/272-t-shark-usage-examples
  - Good reference for Wireshark/tshark capture filters: https://www.cellstream.com/reference-reading/tipsandtricks/379-top-10-wireshark-filters-2
  - Interesting syntax nuance - In order to ensure that the capture filter applies when multiple interfaces are selected, we have to make sure that the capture filter comes BEFORE the interface selection, otherwise the filter would apply only to the interface that it immediately followed.  Reference: https://ask.wireshark.org/question/10019/dumpcap-problem-with-multiple-interfaces-and-filter/
  - Good reference for starting a background job: https://codingbee.net/powershell/powershell-running-tasks-in-the-background
  

  .
#>
function Start-tshark {
  [CmdletBinding()]
  [Alias('tsharkStart')]
  param (
    [Parameter(HelpMessage='Reference the numeric value of the interface as seen by tshark. You can view these by using: Get-tsharkInterfaces.ps1, "tshark.exe -D", or "dumpcap.exe -D -M".')]
    [Alias('i')]
    [string[]]
    $Interface,
    [Parameter(HelpMessage='This parameter contains a Validate Set Attribute. Choose from the following options: "EthernetOnly","PublicIP","PrivateIPOnly","Multicast". You may use the <tab> key to toggle through or to auto-complete.')]
    [ValidateSet("EthernetOnly","PublicIP","PrivateIPOnly","Multicast")]
    [string]
    $FilterSet,
    [Parameter(HelpMessage='Reference the host IP Address for which to apply a Capture Filter.  This parameter is equivalent to: tshark -f "host <IP Address>". E.g. tshark -f "host 192.168.10.1"')]
    [Alias('host')]
    [string]
    $HostCaptureFilter,
    [Parameter(HelpMessage='Reference the network address and subnet mask for which to apply a Capture Filter.  This parameter is equivalent to: tshark -f "net <Network/CIDR notation>". E.g. tshark -f "net 10.0.0.0/8"')]
    [Alias('net')]
    [string]
    $NetworkCaptureFilter,
    [Parameter(HelpMessage='This parameter allows for any valid Capture Filter syntax.  For example, if you wanted the equivalent of: tshark -f "src port 53"; then use the syntax:  Start-tshark -f "src port 53".')]
    [Alias('f')]
    [string]
    $FreeHandCaptureFilter,
    [Parameter()]
    [Alias('w')]
    [string]
    $WriteCaptureFile,
    [Parameter()]
    [Alias('n')]
    [switch]
    $NoNameResolution,
    [Parameter(HelpMessage='Reference the number of packets you want to capture.')]
    [Alias('c')]
    [string]
    $Count
  )
  
  begin {}
  
  process {

    $exe = 'tshark.exe'
    $param = @()

    # NAME RESOLUTION - OFF
    if ($NoNameResolution) {
      $param += '-n'
    }

    # COUNT OF PACKETS TO CAPTURE
    if ($Count) {
      $param += '-c',"$Count"
    }

    # CAPTURE FILTER   
    #  - In order to ensure that the capture filter applies when multiple interfaces are selected, we have to make sure that the capture filter comes BEFORE the interface selection, otherwise the filter would apply only to the interface that it immediately followed.  Reference: https://ask.wireshark.org/question/10019/dumpcap-problem-with-multiple-interfaces-and-filter/

    if ($HostCaptureFilter) {
      $param += '-f',"`"host $HostCaptureFilter`""
    }
    if ($NetworkCaptureFilter) {
      $param += '-f',"`"net $NetworkCaptureFilter`""
    }
    if ($FreeHandCaptureFilter) {
      $param += '-f',"`"$FreeHandCaptureFilter`""
    }
    if ($FilterSet) {
      switch ($FilterSet) {
        
        "EthernetOnly" {
          $param += '-f','"not ip"'
          Write-Verbose "Ethernet Frames Only (All Non-IP Packets)" 
        }
        "PublicIP" { 
          $param += '-f','"ip and (not src net 10.0.0.0/8 and not src net 172.16.0.0/12 and not src net 192.168.0.0/16) or (not dst net 10.0.0.0/8 and not dst net 172.16.0.0/12 and not dst net 192.168.0.0/16) and not multicast and not broadcast"'
          Write-Verbose "IPv4 Conversations containing Public IP Addresses and excluding Multicast and Broadcast"
        }
        "PrivateIPOnly" { 
          $param += '-f','"ip and (src net 10.0.0.0/8 or src net 172.16.0.0/12 or src net 192.168.0.0/16) and (dst net 10.0.0.0/8 or dst net 172.16.0.0/12 or dst net 192.168.0.0/16)"'
          Write-Verbose "IPv4 Conversations containing Private IP Addresses (RFC1918) Only - Excluding Public IPs and Multicast"
        }
        "Multicast" { 
          $param += '-f','"ip and multicast"'
          Write-Verbose "IPv4 Conversations containing Multicast Addresses" 
        }

      }
    }

    # INTERFACE SELECTION
    function Get-tsharkInterfaces {      

      $tsharkListOfInterfaces = tshark.exe -D    
      $NetIPAddress = Get-NetIPAddress | Select-Object IPAddress,InterfaceAlias    
      foreach ($Interface in $tsharkListOfInterfaces) {          
        $IntRef,$DeviceIdentifier,$IntName  = $Interface -split "\s",3
        $IntRef = $IntRef.trimend('.')
        $IntName = $IntName -replace "^\(" -replace "\)$"          
        if ($IntName -in $NetIPAddress.InterfaceAlias) {
          
          $IPAddress = ($NetIPAddress | Where-Object {$_.InterfaceAlias -like $IntName}).IPAddress
  
          $prop = [ordered]@{
            IntRef = $IntRef
            IntName = $IntName
            IPAddress = $IPAddress
          }
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
  
      }      
    }

    if ($Interface) {
      foreach ($Int in $Interface) {
        $param += "-i", "$Int"
      }
    }
    else {
      $InterfacesWithIPAddresses = (Get-tsharkInterfaces).IntRef

      foreach ($Int in $InterfacesWithIPAddresses) {
        $param += "-i","$Int"
      }
    }

    # WRITE TO PCAP FILE
    if ($WriteCaptureFile) {
      $param += "-w","$WriteCaptureFile"
    }

    # INVOCATION
    #  - Here we use the 'call' operator to execute tshark.exe with a supplied set of parameter as determined above
    & $exe $param

  }
  
  end {}
}