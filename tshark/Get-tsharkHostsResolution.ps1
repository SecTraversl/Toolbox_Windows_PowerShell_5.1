<#
.SYNOPSIS
  The "Get-tsharkHostsResolution" function takes a packet capture and outputs all of the URI to IP Address pairings that occur in the capture.

.DESCRIPTION
.EXAMPLE
  PS C:\> $URIs = Get-tsharkHostsResolution -Pcap .\myTest.pcap
  PS C:\> $URIs | more

  IPAddress       URI
  ---------       ---
  99.86.84.112    a.impactradius-go.com
  104.28.22.242   static1.brave.com
  52.94.230.46    ws-na.assoc-amazon.com
  104.31.76.155   jdhitsolutions.com
  52.94.240.125   www.assoc-amazon.com
  172.67.161.91   static1.brave.com
  199.232.9.7     p.ssl.fastly.net
  99.86.84.50     d1vbftvkf37ah3.cloudfront.net
  99.86.84.10     a.impactradius-go.com
  151.101.130.110 dualstack.f4.shared.global.fastly.net
  99.86.84.129    a.impactradius-go.com
  52.46.129.238   rcm-na.assoc-amazon.com
  40.89.244.234   external-content.duckduckgo.com
  31.13.93.19     star.c10r.facebook.com
  151.101.1.7     dualstack.p.ssl.global.fastly.net
  10.44.29.220    MPM-Music-Paging.local
  151.101.193.7   dualstack.p.ssl.global.fastly.net
  44.238.227.223  go-updater-1830831421.us-west-2.elb.amazonaws.com
  172.217.9.141   accounts.google.com
  172.217.9.163   www.gstatic.com



  Here we run the function by referencing a packet capture that we had already obtained.  The output contains various URIs that had been resolved while the packet capture was running, along with their respective IP Addresses.

.EXAMPLE
  PS C:\> Get-tsharkHostsResolution -Pcap .\myTest.pcap -TextOutput
  # TShark hosts output
  #
  # Host data gathered from .\myTest.pcap

  172.217.14.170  fonts.googleapis.com
  151.101.66.110  dualstack.f4.shared.global.fastly.net
  151.101.194.110 dualstack.f4.shared.global.fastly.net
  151.101.1.7     dualstack.p.ssl.global.fastly.net
  151.101.129.7   dualstack.p.ssl.global.fastly.net
  192.0.78.22     public-api.wordpress.com
  192.0.78.23     public-api.wordpress.com
  199.232.9.7     p.ssl.fastly.net
  35.201.76.231   pluralsight.pxf.io
  104.28.22.242   static1.brave.com
  172.217.1.134   dart.l.doubleclick.net
  10.44.29.220    MPM-Music-Paging.local
  52.94.240.125   www.assoc-amazon.com
  104.31.77.155   jdhitsolutions.com
  216.58.194.36   www.google.com
  172.67.149.64   jdhitsolutions.com
  52.46.129.238   rcm-na.assoc-amazon.com
  52.141.221.14   links.duckduckgo.com
  99.86.84.129    a.impactradius-go.com
  99.86.84.29     a.impactradius-go.com
  99.86.84.10     a.impactradius-go.com



  Here we run the function using the switch parameter "-TextOutput".  This returns an IP Address to URI pairing in a format that can be used as a "hosts" file.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkHostsResolution
  Author: Travis Logue
  Version History: 1.0 | 2020-12-30 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-tsharkHostsResolution {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.')]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This Switch Parameter is used to simply get a text output that can be used to create a "hosts" file.')]
    [switch]
    $TextOutput
  )
  
  begin {}
  
  process {

    $HostsOutput = tshark.exe -r $Pcap -q -z hosts

    if ($TextOutput) {
      Write-Output $HostsOutput
    }
    else {
      $ObjectForm = $HostsOutput | ConvertFrom-Csv -Delimiter "`t" -Header "IPAddress","URI"
      Write-Output $ObjectForm
    }

  }
  
  end {}
}