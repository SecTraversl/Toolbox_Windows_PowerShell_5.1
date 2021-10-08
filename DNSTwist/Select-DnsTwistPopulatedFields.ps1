<#
.SYNOPSIS
  The "Select-DnsTwistPopulatedFields" function takes the output from "Invoke-DnsTwistForDocker" and filters the output so that only Domains with at least one of the following records are returned: A, AAAA, MX, or NS.

.DESCRIPTION
.EXAMPLE
  PS C:\> $DnsTwistResults | Select-DnsTwistPopulatedFields | select -First 10 | ft

  fuzzer       domain-name   dns-a           dns-aaaa                               dns-mx                             dns-ns
  ------       -----------   -----           --------                               ------                             ------
  original*    Roxboard.com  10.30.240.164                                          d338925a.ess.gymratudanetworks.com some-ib-10-node0.Roxboard.com
  addition     Roxboarde.com 56.163.161.132                                         mx1.mailchannels.net               ns1.dreamhost.com
  addition     Roxboardk.com 84.102.136.180                                                                            ns45.domaincontrol.com
  addition     Roxboards.com 201.21.54.254   2606:4700:3030::ac43:aa04                                                 boyd.ns.cloudflare.com
  addition     Roxboardt.com 257.8.210.35                                           mail.efty.com                      ns1.eftydns.com
  addition     Roxboardx.com 39.189.205.91   2600:1f16:389:3100:366c:e45e:9097:14a4
  addition     Roxboardz.com 6.223.115.185                                                                             nsg1.namebrightdns.com
  bitsquatting Noxboard.com                                                                                            dns17.hichina.com
  bitsquatting Poxboard.com  213.168.131.241                                                                           ns23.domaincontrol.com
  bitsquatting Roxboand.com  125.255.119.110                                        eforward1.registrar-servers.com    dns1.registrar-servers.com



  Here we have a variable of "$DnsTwistResults" which contains the output from "Invoke-DnsTwistForDocker" for a given domain.  We pipe those objects to "Select-DnsTwistPopulatedFields" in order to filter out the domains that don't have at least one of the following records: A, AAAA, MX, or NS.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Select-DnsTwistPopulatedFields.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-26 | Initial Version
  Dependencies: Expects input object from "Invoke-DnsTwistForDocker.ps1"
  Notes:


  .
#>
function Select-DnsTwistPopulatedFields {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline=$true)]
    [psobject]
    $PSObject
  )
  
  begin {}
  
  process {
    $PSObject | Where-Object { $_.'dns-a' -or $_.'dns-aaaa' -or $_.'dns-mx' -or $_.'dns-ns' }
  }
  
  end {}
}