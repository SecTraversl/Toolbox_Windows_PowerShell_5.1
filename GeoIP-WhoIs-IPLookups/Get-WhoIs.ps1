<#
.SYNOPSIS
  The "Get-WhoIs" function queries the 'http://whois.arin.net/' API in order to retrieve WhoIs information about the specified IP Address.  We also added a DNS PTR lookup to further enrich the results.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-WhoIs -IPAddress 217.170.205.14, 219.91.110.131

  IPAddress           : 217.170.205.14
  PtrRecord           : tor-exit-5014.nortor.no
  registrationDate    : 2000-06-05T00:00:00-04:00
  customerRef_handle  :
  customerRef_name    :
  name                : 217-RIPE
  startAddress        : 217.0.0.0
  endAddress          : 217.255.255.255
  cidrLength          : 8
  orgRef_handle       : RIPE
  orgRef_name         : RIPE Network Coordination Centre
  parentNetRef_handle :
  parentNetRef_name   :
  updateDate          : 2009-03-25T13:20:27-04:00
  originAS            :

  IPAddress           : 219.91.110.131
  PtrRecord           : NK219-91-110-131.adsl.dynamic.apol.com.tw
  registrationDate    :
  customerRef_handle  :
  customerRef_name    :
  name                : APNIC5
  startAddress        : 219.0.0.0
  endAddress          : 219.255.255.255
  cidrLength          : 8
  orgRef_handle       : APNIC
  orgRef_name         : Asia Pacific Network Information Centre
  parentNetRef_handle :
  parentNetRef_name   :
  updateDate          : 2010-07-30T10:08:03-04:00
  originAS            :



  Here we run the function and reference two different IP Addresses.  In return, we receive the results of the DNS PTR record lookup (if one is available, and in this case there is a PTR record for both of these IPs), as well as various WhoIs information about the organization and network associated with each IP Address.

.EXAMPLE
  PS C:\> Get-WhoIs 40.107.220.52 -Verbose
  VERBOSE: Starting Get-WhoIs
  VERBOSE: GET http://whois.arin.net/rest/ip/40.107.220.52 with 0-byte payload
  VERBOSE: received 2887-byte response of content type application/xml;charset=UTF-8


  IPAddress           : 40.107.220.52
  registrationDate    : 2015-02-23T14:30:24-05:00
  customerRef_handle  :
  customerRef_name    :
  name                : MSFT
  startAddress        : 40.96.0.0
  endAddress          : 40.111.255.255
  cidrLength          : 12
  orgRef_handle       : MSFT
  orgRef_name         : Microsoft Corporation
  parentNetRef_handle : NET-40-0-0-0-0
  parentNetRef_name   : NET40
  updateDate          : 2015-05-27T14:38:53-04:00
  originAS            :



  Here we run the function using the 'Common Parameter' of "-Verbose".  This allows us to see the what is occurring as the function executes.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-WhoIs.ps1
  Author:  Travis Logue
  Version History:  4.0 | 2021-03-10 | Added PTR Lookup; Added logic to validate the actual 'startAddress','endAddress', and 'cidrLength' when getting an Array of results in those fields from RIPE and APNIC; such that the final is a scalar value for each of those respective properties
  Dependencies:
  Notes:
    - This was where I found the initial code used as the base for the function below - "Identifying Website Visitor IP Addresses Using PowerShell" by Jeff Hicks: https://www.petri.com/powershell-problem-solver


  .
#>
function Get-WhoIs {
  [CmdletBinding()]
  [Alias('WhoIs')]
  param (
    [parameter(Position = 0, Mandatory, HelpMessage = "Enter an IPv4 Address.",
      ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Address")]
    [ValidatePattern("^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")]
    [string[]]$IPAddress       
  )
  
  begin {}
  
  process {

    $AllIPAddresses = foreach ($IP in $IPAddress) {

      Write-Verbose "Starting $($MyInvocation.Mycommand)"  
      $baseURL = 'http://whois.arin.net/rest'
      #default is XML anyway
      $header = @{"Accept" = "application/xml" }
      $url = "$baseUrl/ip/$ip"
      $r = Invoke-Restmethod $url -Headers $header
  
      $ArinResults = $r.net
  
      $PtrLookup = Resolve-DnsName $IP -Type PTR -ErrorAction SilentlyContinue
  
      $prop = [ordered]@{
  
        IPAddress = $IP
        PtrRecord = try { $PtrLookup.NameHost } catch { $null };
        registrationDate    = $ArinResults.registrationDate
        customerRef_handle  = if ($ArinResults.customerRef.handle) {
          $ArinResults.customerRef.handle
        }
        else {
          $null
        }
        customerRef_name    = if ($ArinResults.customerRef.name) {
          $ArinResults.customerRef.name
        }
        else {
          $null
        }
        name                = $ArinResults.name
        startAddress        = $ArinResults.netBlocks.netBlock.startAddress
        endAddress          = $ArinResults.netBlocks.netBlock.endAddress
        cidrLength          = $ArinResults.netBlocks.netBlock.cidrLength
        orgRef_handle       = if ($ArinResults.orgRef.handle) {
          $ArinResults.orgRef.handle
        }
        else {
          $null
        }
        orgRef_name         = if ($ArinResults.orgRef.name) {
          $ArinResults.orgRef.name
        }
        else {
          $null
        }
        parentNetRef_handle = $ArinResults.parentNetRef.handle
        parentNetRef_name   = $ArinResults.parentNetRef.name
        updateDate          = $ArinResults.updateDate
        originAS            = if ($ArinResults.originASes.originAS) {
          $ArinResults.originASes.originAS
        }
        else {
          $null
        }
  
      }
  
      # Added this section for v3.0 of this code. See notes above. 2021-01-22
      $WhoIsTemp = New-Object -TypeName psobject -Property $prop
  
  
      if ($WhoIsTemp.startAddress.Count -gt 1) {
        $NetRanges = for ($i = 0; $i -lt $WhoIsTemp.startAddress.Count; $i++) {
          $prop = [ordered]@{
            startAddress = $WhoIsTemp.startAddress[$i]
            endAddress = $WhoIsTemp.endAddress[$i]
            cidrLength = $WhoIsTemp.cidrLength[$i]
          }
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      
        foreach ($Range in $NetRanges) {
          $Sorted = $Range.startAddress,$Range.endAddress,$WhoIsTemp.IPAddress | Sort-Object {[version]$_}
          
          if ($WhoIsTemp.IPAddress -eq $Sorted[1]) {
            $Winner = $Range
        }
      
        $WhoIsTemp.startAddress = $Winner.startAddress
        $WhoIsTemp.endAddress = $Winner.endAddress
        $WhoIsTemp.cidrLength = $Winner.cidrLength
        }
  
      }   
      
      Write-Output $WhoIsTemp
    }


    Write-Output $AllIPAddresses

  }
  
  end {}

}