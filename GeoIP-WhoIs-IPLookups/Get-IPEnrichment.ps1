<#
.SYNOPSIS
  The "Get-IPEnrichment" function takes one or many IP Addresses and returns information such as the PTR Record, WhoIs information, and GeoIP information for each address. This tool has an automatic 'Save to .csv' option ("-CreateIPEnrichmentCsv") which allows for a permanent record of these lookups.  These records include the date stamp the lookup occurred, so that multiple .csv files can be merged into a usable 'historical record lookup database', and entries may be purged after 90 days (or any criteria you desire).
  
.DESCRIPTION
.EXAMPLE
  PS C:\> $Enriched = Get-IPEnrichment -IPAddress 13.108.238.149
  PS C:\> $Enriched

  IPAddress           : 13.108.238.149
  PtrRecord           : smtp06-iad-sp2.mta.salesforce.com
  City                : Washington
  Region              : Washington, D.C.
  Code                : US
  Country             : United States of America
  Continent           : NA
  Org                 : AS14340 Salesforce.com, Inc.
  WhoIsName           : SALESF-3
  RegistrationDate    : 2014-11-18T13:44:13-05:00
  CustomerRef_handle  :
  CustomerRef_name    :
  StartAddress        : 13.108.0.0
  EndAddress          : 13.111.255.255
  CidrLength          : 14
  OrgRef_handle       : SALESF-3
  OrgRef_name         : Salesforce.com, Inc.
  ParentNetRef_handle : NET-13-0-0-0-0
  ParentNetRef_name   : NET13
  UpdateDate          : 2015-02-11T11:37:01-05:00
  OriginAS            : AS14340
  LookupDate          : 2021-03-10


  PS C:\> IPEnrich 13.108.238.149

  IPAddress           : 13.108.238.149
  PtrRecord           : smtp06-iad-sp2.mta.salesforce.com
  City                : Washington
  Region              : Washington, D.C.
  Code                : US
  Country             : United States of America
  Continent           : NA
  Org                 : AS14340 Salesforce.com, Inc.
  WhoIsName           : SALESF-3
  RegistrationDate    : 2014-11-18T13:44:13-05:00
  CustomerRef_handle  :
  CustomerRef_name    :
  StartAddress        : 13.108.0.0
  EndAddress          : 13.111.255.255
  CidrLength          : 14
  OrgRef_handle       : SALESF-3
  OrgRef_name         : Salesforce.com, Inc.
  ParentNetRef_handle : NET-13-0-0-0-0
  ParentNetRef_name   : NET13
  UpdateDate          : 2015-02-11T11:37:01-05:00
  OriginAS            : AS14340
  LookupDate          : 2021-03-10



  Here we run the function two ways.  First we use the full function name of "Get-IPEnrichment" and we supply a single IP Address as the argument for the "-IPAddress" parameter.  In return, we get various information from GeoIP and WhoIS lookups about the IP Address we supplied.  In the second example we run the function using the built-in alias of "IPEnrich" and reference the IP Address we want to lookup.  The "-IPAddress" parameter is at position 0, so we don't need to explicitly tell the function that is the parameter we are using; and as you can see, we can the same results as before.  

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-IPEnrichment.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-03-10 | Added "-CreateIPEnrichmentCsv" and more
  Dependencies: Get-WhoIs.ps1 | Get-GeoIP.ps1 | Get-CountryCodesAndContinents.ps1
  Notes:


  .
#>
function Get-IPEnrichment {
  [CmdletBinding()]
  [Alias('IPEnrich')]
  param (
    [Parameter()]
    [string[]]
    $IPAddress,
    [Parameter(HelpMessage='This Switch Parameter is used to automatically save the results to a .csv with the following name: "IPEnrichmentResults_$(Get-Date -Format yyyy-MM-dd_HHmm).csv";  E.g. "IPEnrichmentResults_2021-03-12_1743.csv"')]
    [switch]
    $CreateIPEnrichmentCsv
  )
  
  begin {}
  
  process {


    if ($IPAddress) {

      $FinalLookupResults = foreach ($IP in $IPAddress) {
        
        if ($GeoIPLookupTable) {
          $LookupTable = Import-Csv -Path $GeoIPLookupTable
          $GeoIPResults = $LookupTable | ? IP -eq $IP
        }
        else {
          $GeoIPResults = Get-GeoIP $IP
        }
    
        $CountryAndContinentResults = Get-CountryCodesAndContinents -CountryCode ($GeoIPResults.Country)
    
        $WhoIsResults = Get-WhoIs $IP

        $LookupDate = Get-Date -Format yyyy-MM-dd

        $prop = [ordered]@{
          IPAddress           = $IP
          PtrRecord           = $GeoIPResults.hostname
          City                = $GeoIPResults.city
          Region              = $GeoIPResults.region
          Code                = $GeoIPResults.country
          Country             = $CountryAndContinentResults.CountryName
          Continent           = $CountryAndContinentResults.ContinentCode
          Org                 = $GeoIPResults.org
          WhoIsName           = $WhoIsResults.name
          RegistrationDate    = $WhoIsResults.registrationDate
          CustomerRef_handle  = $WhoIsResults.customerRef_handle
          CustomerRef_name    = $WhoIsResults.customerRef_name
          StartAddress        = $WhoIsResults.startAddress
          EndAddress          = $WhoIsResults.endAddress
          CidrLength          = $WhoIsResults.cidrLength
          OrgRef_handle       = $WhoIsResults.orgRef_handle
          OrgRef_name         = $WhoIsResults.orgRef_name
          ParentNetRef_handle = $WhoIsResults.parentNetRef_handle
          ParentNetRef_name   = $WhoIsResults.parentNetRef_name
          UpdateDate          = $WhoIsResults.updateDate
          OriginAS            = $WhoIsResults.originAS
          LookupDate          = $LookupDate
        }
    
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj



      }


      if ($CreateIPEnrichmentCsv) {
        Write-Host "`nExporting the IPEnrichment Results to the file:...  'IPEnrichmentResults_$(Get-Date -Format yyyy-MM-dd_HHmm).csv' `n" -BackgroundColor Black -ForegroundColor Yellow
        $FinalLookupResults | Export-Csv -NoTypeInformation "IPEnrichmentResults_$(Get-Date -Format yyyy-MM-dd_HHmm).csv"

        Write-Output $FinalLookupResults
      }
      else {

        Write-Output $FinalLookupResults

      }


    }



  }
  
  end {}
}