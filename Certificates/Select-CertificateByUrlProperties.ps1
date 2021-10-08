<#
.SYNOPSIS
  The "Select-CertificateByUrlProperties" is a pre-selected property filter for the objects output by the "Get-CertificateByUrlWithTimeLimit" function.

.DESCRIPTION
.EXAMPLE
  PS C:\> $RawText_From_email | select -f 10

  CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize
  the sender and know the content is safe.


  Navigate your ERP and CRM migration with expert guidance.
  Having trouble viewing this email? | View as web page <https://protect2.fireeye.com/v1/url?k=bab98db8-e522b551-bab91149-86e04
  58f6361-05a6cde9e9877ccf&q=1&e=138ff2a1-2d06-4aaf-b4b7-df52bf7fd3a4&u=https%3A%2F%2Finfo.microsoft.com%2Findex.php%2Femail%2F
  emailWebview%3Fmkt_tok%3DMTU3LUdRRS0zODIAAAF_IaCiDkqw129OV0xEx7EG2Qj-ahTZJVR3miuczHZUOxT4cOHAKTWg_JhNylox4kPcgJWZV_9_RBhhrq7i
  _x33B8nqdPJQ5x8ob0OeBUCO0fbI-5Ram6lu8R19%26md_id%3D1107062>
  <https://protect2.fireeye.com/v1/url?k=548be206-0b10daef-548b7ef7-86e0458f6361-a95ca0d46e0c1978&q=1&e=138ff2a1-2d06-4aaf-b4b
  7-df52bf7fd3a4&u=https%3A%2F%2Fdynamics.microsoft.com%2F>        <https://protect2.fireeye.com/v1/url?k=d49b595c-8b0061b5-d49
  bc5ad-86e0458f6361-19cc5f2cd29a41cd&q=1&e=138ff2a1-2d06-4aaf-b4b7-df52bf7fd3a4&u=https%3A%2F%2Fdynamics.microsoft.com%2F>

  <https://protect2.fireeye.com/v1/url?k=1b404f3a-44db77d3-1b40d3cb-86e0458f6361-2bf74ac477a7d755&q=1&e=138ff2a1-2d06-4aaf-b4b
  7-df52bf7fd3a4&u=https%3A%2F%2Femails.microsoft.com%2Fdc%2FIxWd3l0pySf6MeHrUZhbAhoIEcuVarezwm7wkOx4Dljeoox_mTn1MEsBq9EqNYj8qE
  qOQc9olvcwm0e60hY4gcvNxXDqsUmcO9aZN6icgK8O41QkZMu3aGK4w8a9D4B_6kTIyStapK2kR3s70HuL-v2lq4DYYxh3-aX_UZox8wU%3D%2FMTU3LUdRRS0zOD
  IAAAF_IaCiDmir3ZjB8FHjgaapyGpwNmW_-VKfnuDglX7Nw9gePwkYJBZnvEjq3Xd9w71fqpjEx90%3D>

  Simplify your migration with Microsoft
  ... <truncated> ...


  PS C:\> UrlFromText $RawText_From_email

  Number URL
  ------ ---
  Link1  https://protect2.fireeye.com/v1/url?k=bab98db8-e522b551-bab91149-86e0458f6361-05a6cde9e9877ccf&q=1&e=138ff2a1-2d06...
  Link2  https://protect2.fireeye.com/v1/url?k=548be206-0b10daef-548b7ef7-86e0458f6361-a95ca0d46e0c1978&q=1&e=138ff2a1-2d06...
  Link3  https://protect2.fireeye.com/v1/url?k=d49b595c-8b0061b5-d49bc5ad-86e0458f6361-19cc5f2cd29a41cd&q=1&e=138ff2a1-2d06...
  Link4  https://protect2.fireeye.com/v1/url?k=1b404f3a-44db77d3-1b40d3cb-86e0458f6361-2bf74ac477a7d755&q=1&e=138ff2a1-2d06...
  Link5  https://protect2.fireeye.com/v1/url?k=3c93d554-6308edbd-3c9349a5-86e0458f6361-d2dc978d41362382&q=1&e=138ff2a1-2d06...
  Link6  https://clouddamcdnprodep.azureedge.net/gdc/gdcsPvUDR/original
  Link7  https://protect2.fireeye.com/v1/url?k=83802089-dc1b1860-8380bc78-86e0458f6361-91ca3d8326b3f2d8&q=1&e=138ff2a1-2d06...
  Link8  https://clouddamcdnprodep.azureedge.net/gdc/gdcIaXA9y/original
  Link9  https://protect2.fireeye.com/v1/url?k=579fe20b-0804dae2-579f7efa-86e0458f6361-306c94f46ac717d3&q=1&e=138ff2a1-2d06...
  Link10 https://clouddamcdnprodep.azureedge.net/gdc/gdcUgRxgt/original
  Link11 https://protect2.fireeye.com/v1/url?k=327bb93c-6de081d5-327b25cd-86e0458f6361-71ca5cd7186306ec&q=1&e=138ff2a1-2d06...
  Link12 https://protect2.fireeye.com/v1/url?k=830aa635-dc919edc-830a3ac4-86e0458f6361-76e1708aa04c1b89&q=1&e=138ff2a1-2d06...
  Link13 https://protect2.fireeye.com/v1/url?k=2e22bffe-71b98717-2e22230f-86e0458f6361-2bb3fdc5f18f059f&q=1&e=138ff2a1-2d06...
  Link14 https://protect2.fireeye.com/v1/url?k=6d2958e5-32b2600c-6d29c414-86e0458f6361-ba6186252d473329&q=1&e=138ff2a1-2d06...
  Link15 https://protect2.fireeye.com/v1/url?k=bdd240f7-e249781e-bdd2dc06-86e0458f6361-d49b3ac0da9e4b9e&q=1&e=138ff2a1-2d06...
  Link16 https://emails.microsoft.com/trk?t=1&mid=MTU3LUdRRS0zODI6MDoxMTA2NDUzOjYwMDkyNzM6MTQzMTY5MTA6MTEwNzA2Mjo5OjMyNjUzM...


  PS C:\> UrlFromText $RawText_From_email -ConvertFireEyeUrlProtection

  Number URL
  ------ ---
  Link1  https://info.microsoft.com/index.php/email/emailWebview?mkt_tok=MTU3LUdRRS0zODIAAAF_IaCiDkqw129OV0xEx7EG2Qj-ahTZJV...
  Link2  https://dynamics.microsoft.com/
  Link3  https://dynamics.microsoft.com/
  Link4  https://emails.microsoft.com/dc/IxWd3l0pySf6MeHrUZhbAhoIEcuVarezwm7wkOx4Dljeoox_mTn1MEsBq9EqNYj8qEqOQc9olvcwm0e60h...
  Link5  https://emails.microsoft.com/dc/IxWd3l0pySf6MeHrUZhbAhoIEcuVarezwm7wkOx4Dljeoox_mTn1MEsBq9EqNYj8qEqOQc9olvcwm0e60h...
  Link6  https://clouddamcdnprodep.azureedge.net/gdc/gdcsPvUDR/original
  Link7  https://emails.microsoft.com/dc/qcYvJmJ-YNru4am3HWNVTDRyhw4AT14looqsel-lEOXygYKddAySspmwKdZd8-SaoIdYg4899DO_aX5ObB...
  Link8  https://clouddamcdnprodep.azureedge.net/gdc/gdcIaXA9y/original
  Link9  https://emails.microsoft.com/dc/IxWd3l0pySf6MeHrUZhbAgMVkqA45jrYKwk74FyRR8ShyUJ0VdHVBHpuEZvgWKHFqGX1_yV0OlXNGKbcwB...
  Link10 https://clouddamcdnprodep.azureedge.net/gdc/gdcUgRxgt/original
  Link11 https://emails.microsoft.com/dc/7lM4V2h3Ux1YIeo9OliDNWBQBNZBbDaosj51VAAgcSKIU8aMBP7YWmtaCOIUUh7k18tuhGGDPlBY5W5-ox...
  Link12 https://emails.microsoft.com/MTU3LUdRRS0zODIAAAF_IaCiDtpZInEIW0lQ068I278O9txGQelwlKmTqs15VItChczcvhGkGxdwcYBMCFObi...
  Link13 https://emails.microsoft.com/dc/YZdgvqwbGRw5vplqwcDuFAT39-RSqApAoBTg8JD6J69Q9XlJiBGUNKEP8wZ1xpt-oqgHbQNkJ4DZTh9iLC...
  Link14 https://emails.microsoft.com/MTU3LUdRRS0zODIAAAF_IaCiDl0wVt7xJL88hds06IUKwCAvKQLzX7AKt2W2VH4JNRQUhVqTk-wnKe9oKkTs2...
  Link15 https://emails.microsoft.com/MTU3LUdRRS0zODIAAAF_IaCiDrCF23yK6x8ra9t0D6G4JnQIwdRpcIOXY0KdNfJXQPKT0MQSoMo9jFuMmwSI_...
  Link16 https://emails.microsoft.com/trk?t=1&mid=MTU3LUdRRS0zODI6MDoxMTA2NDUzOjYwMDkyNzM6MTQzMTY5MTA6MTEwNzA2Mjo5OjMyNjUzM...


  PS C:\> $Certs_for_websites = $Links | CertByUrlWithTimeLimit

  VERBOSE: Action Job81 did not complete before timeout period of 00:00:05.
  VERBOSE: Action Job83 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job85 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job87 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job89 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job91 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job93 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job95 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job97 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job99 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job101 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job103 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job105 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job107 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job109 completed before timeout period. job ran: 00:00:01.
  VERBOSE: Action Job111 completed before timeout period. job ran: 00:00:01.


  PS C:\> $Certs_for_websites[4]

  WebResponseUri   : https://clouddamcdnprodep.azureedge.net/gdc/gdcsPvUDR/original
  WebCharacterSet  :
  WebServer        : ECAcc (sec/9696)
  WebLastModified  :
  WebStatusCode    : OK
  WebVersion       : 1.1
  WebMethod        : GET
  IsFromCache      : False
  CertThumbprint   : 2E14F09F3E811752D1AA480FD4EE02B70AE9894D
  CertValidFrom    : 11/15/2020 4:00:00 PM
  CertValidUntil   : 11/10/2021 3:59:59 PM
  CertSerialNumber : 0F1A5645982C89174055C760DF0EC6CA
  CertFormat       : X509
  CertSubject      : CN=*.vo.msecnd.net, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
  RunspaceId       : 3db7135f-eb0a-49c0-b50d-9ba805be93c3


  PS C:\> $Certs_for_websites | CertByUrlSelectProps |ft

  WebServer        CertValidUntil         CertThumbprint                           CertSubject
  ---------        --------------         --------------                           -----------
                   7/23/2022 5:21:28 PM   D1CEB12BD85116E1943A7873C52456E7C34BCA70 CN=dynamics.microsoft.com, O=Microsoft C...
                   7/23/2022 5:21:28 PM   D1CEB12BD85116E1943A7873C52456E7C34BCA70 CN=dynamics.microsoft.com, O=Microsoft C...
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  ECAcc (sec/9696) 11/10/2021 3:59:59 PM  2E14F09F3E811752D1AA480FD4EE02B70AE9894D CN=*.vo.msecnd.net, O=Microsoft Corporat...
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  ECAcc (sec/96C7) 11/10/2021 3:59:59 PM  2E14F09F3E811752D1AA480FD4EE02B70AE9894D CN=*.vo.msecnd.net, O=Microsoft Corporat...
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  ECAcc (sec/9735) 11/10/2021 3:59:59 PM  2E14F09F3E811752D1AA480FD4EE02B70AE9894D CN=*.vo.msecnd.net, O=Microsoft Corporat...
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com
  cloudflare       10/13/2021 11:00:58 AM 915BE29FE3B491D98CA61B7F2685B87390F0E1AC CN=emails.microsoft.com



  Here in this example we demonstrate a complete workflow of using 3 tools together to do an email investigation.  We first put the raw text of the email into the variable "$RawText_From_email" by using the Set-Clipboard cmdlet.  We then use the "Get-UrlFromText" function by calling its alias 'UrlFromText' and passing the contents of the email as an argument along with referencing the switch parameter of "-ConvertFireEyeUrlProtection" in order to see the original links in the email.  We then interrogate the certificates on the websites for each of those links with the "Get-CertificateByUrlWithTimeLimit" function by calling its alias 'CertByUrlWithTimeLimit'.  This function has a built-in timer that expires after a certain number of seconds (without this built-in timer the connection could hang for half an hour or longer because an expected response was not received).  Finally we take the contents in the variable "$Certs_for_websites" and pipe that into 'CertByUrlSelectProps' which is the alias of the "Select-CertificateByUrlProperties" function.  The result is a pre-selected set of properties of each website certificate, along with the visited link (found under the property "WebResponseUri").

.INPUTS
.OUTPUTS
.NOTES
  Name:  Select-CertificateByUrlProperties.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-08-26 | Initial Version
  Dependencies: 
  Notes:


  .
#>
function Select-CertificateByUrlProperties {
  [CmdletBinding()]
  [Alias('CertByUrlSelectProps')]
  param (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $Object
  )
  
  begin {}
  
  process {
    
    foreach ($ArrayItem in $Object) {
      
      $ArrayItem | Select-Object WebServer, CertValidUntil, CertThumbprint, CertSubject, WebResponseUri

    }

  }
  
  end {}
}