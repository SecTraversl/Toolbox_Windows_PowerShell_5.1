<#
.SYNOPSIS
  The "New-DnsTwistReportBrief" function uses dnstwist on a given domain name, and returns variations of that domain name that contain at least one of the following records: A, AAAA, MX, or NS.

.DESCRIPTION
.EXAMPLE
  PS C:\> $DnsTwistExampleReportBrief = New-DnsTwistReportBrief -DomainName example.com
  PS C:\> $DnsTwistExampleReportBrief | select -f 15 | ft

  fuzzer    domain-name  dns-a           dns-aaaa                               dns-mx                       dns-ns
  ------    -----------  -----           --------                               ------                       ------
  original* example.com  93.184.216.34   2606:2800:220:1:248:1893:25c8:1946                                  a.iana-servers.net
  addition  examplea.com 3.223.115.185                                                                       nsg1.namebrightdns.com
  addition  exampleb.com 3.223.115.185                                                                       ns1.namebrightdns.com
  addition  examplec.com 3.223.115.185                                                                       nsg1.namebrightdns.com
  addition  exampled.com 91.195.241.137                                         localhost                    ns1.sedoparking.com
  addition  exampleg.com 202.181.185.161                                        mx.zoho.com                  ns6.timway.com
  addition  examplei.com 18.189.205.91   2600:1f16:389:3100:366c:e45e:9097:14a4
  addition  examplel.com 138.201.138.240 2a01:4f8:172:35ec::2                   mail.examplel.com            b.ns14.net
  addition  exampleq.com 192.241.217.167                                                                     ns1.slicehost.net
  addition  exampler.com 66.111.4.53                                            in1-smtp.messagingengine.com ns1.messagingengine.com
  addition  examples.com 3.211.72.104                                           alt1.aspmx.l.google.com      ns-1064.awsdns-05.org
  addition  examplet.com 34.102.136.180                                         mailstore1.secureserver.net  ns23.domaincontrol.com
  addition  exampleu.com 204.11.56.48                                                                        ns1626.ztomy.com
  addition  examplew.com 52.0.217.44                                                                         ns1.dynadot.com
  addition  examplex.com 52.128.23.153                                          localhost                    ns1.uniregistrymarket.link



  Here we run the function for "example.com" which returns the domains containing at least one of the following records: A, AAAA, MX, or NS.

.INPUTS
.OUTPUTS
.NOTES
  Name:  New-DnsTwistReportBrief.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-05 | Initial Version
  Dependencies: Invoke-DnsTwistForDocker.ps1 | Select-DnsTwistPopulatedFields.ps1 
  Notes:


  . 
#>
function New-DnsTwistReportBrief {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [string]
    $DomainName
  )
  
  begin {}
  
  process {
    Invoke-DnsTwistForDocker -DomainName $DomainName | Select-DnsTwistPopulatedFields
  }
  
  end {}
}