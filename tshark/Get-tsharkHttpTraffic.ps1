<#
.SYNOPSIS
  The "Get-tsharkHttpTraffic" function takes a packet capture and outputs metadata of the packets retrieved by the "http" Display Filter in tshark/Wireshark (specifically, information from HTTP clients seen in the capture).

.DESCRIPTION
.EXAMPLE
  PS C:\> *Httptr <tab>
  PS C:\> Get-tsharkHttpTraffic

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*Httptr" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $http = Get-tsharkHttpTraffic -Pcap .\myTest.pcap -NoDateTime
  PS C:\> $http | ft *

  IPSrc        SPort IPDst        DPort Proto Method UserAgent              Version  HttpHost                                          RequestUri
  -----        ----- -----        ----- ----- ------ ---------              -------  --------                                          ----------
  10.44.29.235 19432 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19433 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19434 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19435 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19436 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19437 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19435 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19437 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19436 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19474 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/SubscriptionManage...
  10.44.29.235 19474 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/SubscriptionManage...
  10.44.29.235 19475 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19475 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19475 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19474 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/SubscriptionManage...
  10.44.29.235 19475 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19474 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/SubscriptionManage...
  10.44.29.235 19437 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19436 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19480 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19481 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19481 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19482 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19483 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19483 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19484 3.81.243.131 80    6     GET                           HTTP/1.1 lexymv423-fx-agent-1.lex01.felix.apps.shauron.com /fpoll?id=KeZ6hcAXRE4fWZz...
  10.44.29.235 19485 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19486 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19486 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.44.29.235 19436 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...
  10.30.40.5   63352 10.44.29.235 5985  6     POST   Microsoft WinRM Client HTTP/1.1 RemDesktopPC:5985                                 /wsman?PSVersion=5.1.1836...
  10.44.29.235 19437 10.30.73.152 5985  6     POST   Microsoft WinRM Client HTTP/1.1 fordawin01.corp.Roxboard.com:5985                 /wsman/subscriptions/9E94...



  Here we run the function by referencing a packet capture and the switch parameter "-NoDateTime" to remove the Date/Time field from the results.  The output contains information retrieved using the "http" Display Filter in tshark/Wireshark, and specifically from HTTP clients.  Key aspects of the output include the Method, User Agent, HTTP Host, and Request URI properties. 

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


  PS C:\> $httpSocket | ? httphost -like '*RemDesktopPC*'

  DateTime    : 2020-12-30 02:10:50.408706
  IPSrcSocket : 10.30.40.5:63352
  IPDstSocket : 10.44.29.235:5985
  Proto       : 6
  Method      : POST
  UserAgent   : Microsoft WinRM Client
  HttpHost    : RemDesktopPC:5985
  RequestUri  : /wsman?PSVersion=5.1.18362.1171



  Here we run the function with the "-SocketFormat" switch parameter and we specify the "-TimeDisplay" format to be in 'UTC'.  Using the "-SocketFormat" paramater, the source IP Address/Port are grouped into one property and the destination IP Address/Port are grouped into another property.  Additionally, we are showing ways of filtering the output based on a partial string match in the "Method" property or the "HttpHost" property.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkHttpTraffic
  Author: Travis Logue
  Version History: 1.0 | 2020-12-30 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in determining how to get the 'DateTime' field to the desired format: https://ask.wireshark.org/question/16830/tshark-frametime-format/


  .
#>
function Get-tsharkHttpTraffic {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.')]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This Switch Parameter is used if you want the output to be in socket format, e.g. ')]
    [switch]
    $SocketFormat,
    [Parameter(HelpMessage='This Switch Parameter is used to remove the Date/Time Field from the output.')]
    [Alias("NDT")]
    [switch]
    $NoDateTime,
    [Parameter(HelpMessage='This paramater contains a Validate Set Attribute. The following options are available: "LocalTime","UTC". The default selection is "LocalTime". You may use the <tab> key to toggle through the available option or to auto-complete.')]
    [ValidateSet("LocalTime","UTC")]
    [string]
    $TimeDisplay = "LocalTime"
  )
  
  begin {}
  
  process {

    switch ($TimeDisplay) {
      "LocalTime" { $TimeFormat = "ad" }
      "UTC" { $TimeFormat = "ud" }
    }

    if ($NoDateTime) {
      $HttpConvos = tshark.exe -r $Pcap -Y http -T fields -e ip.src -e tcp.srcport -e ip.dst -e tcp.dstport -e ip.proto -e http.request.method -e http.user_agent -e http.request.version -e http.host -e http.request.uri

      $ObjectForm = $HttpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'IPSrc','SPort','IPDst','DPort','Proto','Method','UserAgent','Version', 'HttpHost','RequestUri'
    }
    else {
      $HttpConvos = tshark.exe -r $Pcap -Y http -T fields -t $TimeFormat -e _ws.col.Time -e ip.src -e tcp.srcport -e ip.dst -e tcp.dstport -e ip.proto -e http.request.method -e http.user_agent -e http.request.version -e http.host -e http.request.uri

      $ObjectForm = $HttpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'DateTime','IPSrc','SPort','IPDst','DPort','Proto','Method','UserAgent','Version', 'HttpHost','RequestUri'
    }

    
    $PacketsWithMethod = $ObjectForm | Where-Object {$_.Method}

    if ($SocketFormat) {
      if ($NoDateTime) {
        $PacketsWithMethod | Select-Object `
        @{n='IPSrcSocket';e={"$($_.IPSrc):$($_.SPort)"}},
        @{n='IPDstSocket';e={"$($_.IPDst):$($_.DPort)"}},
        Proto,Method,UserAgent,HttpHost,RequestUri
      }
      else {
        $PacketsWithMethod | Select-Object `
        DateTime,
        @{n='IPSrcSocket';e={"$($_.IPSrc):$($_.SPort)"}},
        @{n='IPDstSocket';e={"$($_.IPDst):$($_.DPort)"}},
        Proto,Method,UserAgent,HttpHost,RequestUri
      }
    }
    else {
      $PacketsWithMethod
    }

  }
  
  end {}
}


<#
♥ pcap> tshark -t.
        "ad"   for absolute with YYYY-MM-DD date
        "adoy" for absolute with YYYY/DOY date
        "d"    for delta
        "dd"   for delta displayed
        "e"    for epoch
        "r"    for relative
        "u"    for absolute UTC
        "ud"   for absolute UTC with YYYY-MM-DD date
        "udoy" for absolute UTC with YYYY/DOY date




#>


<# STRING DATETIME CONVERSION WORKSHEET #>

<#
≈ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format yyyy-MM-dd_HHmm
2020-12-29_1810
♣ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HHmm"
2020-12-29 1810
☼ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HHmmss"
2020-12-29 181014
♣ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HHmm.ssss"
2020-12-29 1810.14
¿ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HH:mm.ssss"
2020-12-29 18:10.14
¿ Temp> $string =  "Dec 29, 2020 18:10:14.353287000"
♦ Temp> $string = "Dec 29, 2020 18:10:14.353287000 Pacific Standard Time"
¿ Temp> $string -replace " \D$"
Dec 29, 2020 18:10:14.353287000 Pacific Standard Time
Ω Temp> $string -replace " \D+$"
Dec 29, 2020 18:10:14.353287000
♦ Temp> $Matches
§ Temp>
♣ Temp>
ß Temp> $string -match " \D+$"
True
§ Temp> $Matches

Name                           Value
----                           -----
0                               Pacific Standard Time


♠ Temp> $Matches.Values
 Pacific Standard Time
§ Temp>
¿ Temp>
ß Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HH:mm.msmsmsms"
2020-12-29 18:10.1014101410141014
♠ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HH:msmsmsms"
2020-12-29 18:1014101410141014
ƒ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HH:mm:ss.msmsmsms"
2020-12-29 18:10:14.1014101410141014
♥ Temp>

♠ Temp> get-date "Dec 29, 2020 18:10:14.353287000" -Format "yyyy-MM-dd HH:mm:ss"
2020-12-29 18:10:14

#>