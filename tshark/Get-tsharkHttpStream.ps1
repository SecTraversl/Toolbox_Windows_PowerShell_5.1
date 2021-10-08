<#
.SYNOPSIS
  The "Get-tsharkHttpStream" function takes a packet capture and a pair of sockets in order to display the equivalent output of Wireshark's "Follow HTTP Stream". 

.DESCRIPTION
.EXAMPLE
  PS C:\> $httpSocket = Get-tsharkHttpTraffic -Pcap .\myTest.pcap -SocketFormat -TimeDisplay UTC
  PS C:\> $httpSocket | ? method -eq 'GET'

  DateTime    : 2020-12-30 02:10:33.831333
  IPSrcSocket : 10.44.29.235:19484
  IPDstSocket : 3.81.243.131:80
  Proto       : 6
  Method      : GET
  UserAgent   :
  HttpHost    : lexymv423-fx-agent-1.lex01.felix.apps.shauron.com
  RequestUri  : /fpoll?id=KeZ6hcAXRE4fWZzK1SX6wA&b=353fd8e5


  PS C:\> Get-tsharkHttpStream -Pcap .\myTest.pcap -s1 10.44.29.235:19484 -s2 7.81.243.131:80

  ===================================================================
  Follow: http,ascii
  Filter: ((ip.src eq 10.44.29.235 and tcp.srcport eq 19484) and (ip.dst eq 7.81.243.131 and tcp.dstport eq 80)) or ((ip
  .src eq 7.81.243.131 and tcp.srcport eq 80) and (ip.dst eq 10.44.29.235 and tcp.dstport eq 19484))
  Node 0: 10.44.29.235:19484
  Node 1: 7.81.243.131:80
  146
  GET /fpoll?id=KeZ6hcAXRE4fWZzK1SX6wA&b=353fd8e5 HTTP/1.1

  Host: lexymv423-fx-agent-1.lex01.felix.apps.shauron.com

  Content-Length: 0

  x-cap: 1

          140
  HTTP/1.1 200 OK

  Server: nginx

  Date: Wed, 30 Dec 2020 02:10.44.GMT

  Content-Length: 33

  Connection: keep-alive

  Cache-control: no-cache

          33
  { "doPoll": "false", "flags": 0 }
  ===================================================================



  Here we first used another function and retrieved the sockets that we want to investigate further.  We then referenced each socket using the paramater aliases for "Socket1" and "Socket2" respectively.  The output is the ASCII of following the HTTP Stream conversation between the pair of sockets.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkHttpStream
  Author: Travis Logue
  Version History: 1.0 | 2020-12-30 | Initial Version
  Dependencies:
  Notes:
  - This contains helpful examples of using the "-z follow" directive: https://www.wireshark.org/docs/man-pages/tshark.html


  .
#>
function Get-tsharkHttpStream {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.')]
    [string]
    $Pcap,
    [Parameter(HelpMessage='Reference one the sockets in the HTTP Stream you want to follow.')]
    [Alias('s1')]
    [string]
    $Socket1,
    [Parameter(HelpMessage='Reference the other socket in the HTTP Stream you want to follow.')]
    [Alias('s2')]
    [string]
    $Socket2
  )
  
  begin {}
  
  process {
    
    $HttpStream = tshark.exe -r $Pcap -q -z follow,http,ascii,$Socket1,$Socket2
    Write-Output $HttpStream

  }
  
  end {}
}