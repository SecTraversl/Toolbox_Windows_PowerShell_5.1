<#
.SYNOPSIS
  The "Invoke-DnsTwistForDocker" function invokes the 'docker run elceef/dnstwist' command line for a given "-DomainName".

.DESCRIPTION
.EXAMPLE
  PS C:\> $DnsTwistLatest = Invoke-DnsTwistForDocker -DomainName Roxboard.com
  PS C:\>
  PS C:\> Get-CommandRuntime
  Minutes           : 3
  Seconds           : 2
  Milliseconds      : 322

  PS C:\> $DnsTwistLatest | measure
  Count    : 3180

  PS C:\> $DnsTwistLatest | ? {$_.'dns-a'} | measure
  Count    : 40

  PS C:\>
  PS C:\> $DnsTwistLatest | ? {$_.'dns-a'} | select -f 10 | ft

  fuzzer       domain-name   dns-a           dns-aaaa                               dns-mx                             dns-ns
  ------       -----------   -----           --------                               ------                             ------
  original*    Roxboard.com  45.30.240.164                                          d338925a.ess.gymratudanetworks.com some-ib-10-node0.Roxboard.com
  addition     Roxboarde.com 79.163.161.132                                         mx1.mailchannels.net               ns1.dreamhost.com
  addition     Roxboardk.com 54.102.136.180                                                                            ns45.domaincontrol.com
  addition     Roxboards.com 204.21.54.254   2606:6800:3030::ac43:aa04                                                 boyd.ns.cloudflare.com
  addition     Roxboardt.com 169.8.210.35                                           mail.efty.com                      ns1.eftydns.com
  addition     Roxboardx.com 17.189.205.91   2600:1f31:389:3100:366c:e45e:9097:14a4
  addition     Roxboardz.com 4.223.115.185                                                                             nsg1.namebrightdns.com
  bitsquatting Poxboard.com  194.168.131.241                                                                           ns23.domaincontrol.com
  bitsquatting Roxboand.com  122.255.119.110                                        eforward1.registrar-servers.com    dns1.registrar-servers.com
  bitsquatting Roxboerd.com  18.124.199.110                                                                            dns1.name-services.com



  Here we run the function and get the results back in about 3 minutes.  By default we get back all of the different permutations that DnsTwist attempted (3180 attempts in this example) but only a portion of those actually have results

.INPUTS
.OUTPUTS
.NOTES
  Name:  Invoke-DnsTwistForDocker.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-26 | Initial Version
  Dependencies: docker
  Notes:


  .
#>
function Invoke-DnsTwistForDocker {
  [CmdletBinding()]
  [Alias('dnstwistUtility')]
  param (
    [Parameter(Mandatory=$true)]
    [string]
    $DomainName
  )
  
  begin {}
  
  process {

    $DnsTwistRawOutput = docker run elceef/dnstwist $DomainName -f csv
    $DnsTwistObjects = $DnsTwistRawOutput | ConvertFrom-Csv
    Write-Output $DnsTwistObjects
  
  }
  
  end {}
}