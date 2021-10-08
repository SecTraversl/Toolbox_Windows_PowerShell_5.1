<#
.SYNOPSIS
  The "Update-GeoIPLookupTable" function takes the output objects from the "Invoke-PulseVpnLogIPAddressEnrichment.ps1" function, finds any IP addresses that do not have a resolved "Org" within that array, and updates the current GeoIPLookupTable.csv with the new entries.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-Content ..\GeoIPLookupTable.csv | measure
  Count    : 436

  PS C:\> $SuccessesEnriched = Invoke-PulseVpnLogIPAddressEnrichment -Csv .\pulse-logs_agent-login-succeeded.csv -GeoIPLookupTable ..\GeoIPLookupTable.csv

  PS C:\> Update-GeoIPLookupTable -EnrichedLogs $SuccessesEnriched -GeoIPLookupTable '..\GeoIPLookupTable.csv'

  PS C:\> Get-CommandRuntime 
  Minutes           : 1
  Seconds           : 11

  PS C:\> Get-Content ..\old_GeoIPLookupTable.csv | measure
  Count    : 436

  PS C:\> Get-Content ..\GeoIPLookupTable.csv | measure
  Count    : 586



  First we measure the current GeoIPLookupTable.csv to get an idea of the current number of the rows in the file.  Then we run the function "Invoke-PulseVpnLogIPAddressEnrichment" and save the results into a variable of "$SuccessesEnriched".  We then take the objects rendered by "Invoke-PulseVpnLogIPAddressEnrichment" and reference them when using the function "Update-GeoIPLookupTable".  The function take a little over a minute to run, and after it is finished we have two spreadsheets, the first is the "old_GeoIPLookupTable.csv" and the second is the updated one, now called "GeoIPLookupTable.csv".

.EXAMPLE
  PS C:\> $Successes = Invoke-PulseVpnLogIPAddressEnrichment -Csv .\pulse-logs_agent-login-succeeded.csv -GeoIPLookupTable ..\GeoIPLookupTable.csv
  PS C:\> Get-CommandRuntime
  Minutes           : 5
  Seconds           : 26
  PS C:\>
  PS C:\> $MissingInfo = $Successes | ? {-not ($_.org)}
  PS C:\> $MissingInfo | sort IPAddress -Unique | measure
  Count    : 118

  PS C:\> ls ..\GeoIPLookupTable.csv

      Directory: C:\Users\mark.johnson\Documents\Temp\Sec Ops\Pulse Logs Analysis

  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a----        1/15/2021   3:43 PM         156560 GeoIPLookupTable.csv

  PS C:\> gc ..\GeoIPLookupTable.csv |measure
  Count    : 891

  PS C:\> Update-GeoIPLookupTable -EnrichedLogs $Successes -GeoIPLookupTable ..\GeoIPLookupTable.csv
  PS C:\>
  PS C:\> ls ..\*geoiplookuptable*

      Directory: C:\Users\mark.johnson\Documents\Temp\Sec Ops\Pulse Logs Analysis

  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a----        1/15/2021   7:02 PM         177385 GeoIPLookupTable.csv
  -a----        1/15/2021   3:43 PM         156560 old_GeoIPLookupTable.csv

  PS C:\> gc ..\old_GeoIPLookupTable.csv |measure
  Count    : 891

  PS C:\> gc ..\GeoIPLookupTable.csv |measure
  Count    : 1009

  PS C:\> 1009 - 891
  118

  

  We first run the "Invoke-PulseVpnLogIPAddressEnrichment" function and capture the returned object in the variable "$Successes". We then run the "Update-GeoIPLookupTable" function, referencing the "$Successes" variable in order to evaluate any entries that are missing content for the "Org" property.  As shown above, we inspected the old and new GeoIPLookupTable.csv spreadsheets and the result was an exact match for the number of unique IP addresses that were missing from the data found in the "$Successes" variable.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Update-GeoIPLookupTable.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-01-15 | Initial Version
  Dependencies:  Get-GeoIP.ps1 | MyDateTime.ps1
  Notes:

  
  .
#>
function Update-GeoIPLookupTable {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the logs that were output from the "Invoke-PulseVpnLogIPAddressEnrichment" function.',Mandatory=$true)]
    [psobject]
    $EnrichedLogs,
    [Parameter(HelpMessage='Reference the path of the GeoIPLookupTable.csv.',Mandatory=$true)]
    [string]
    $GeoIPLookupTable
  )
  
  begin {}
  
  process {

    $oldTable = Import-Csv $GeoIPLookupTable


    $GeoIPLookupTableFullPath = (Get-Item $GeoIPLookupTable).FullName
    $DirectoryOfGeoIPLookupTable = $GeoIPLookupTableFullPath | Split-Path

    $SeedLookupToEnsureHostnameIsPopulated = '24.0.125.224'

    $LeftoverGeoIPLookups = @()
    $LeftoverGeoIPLookups += $SeedLookupToEnsureHostnameIsPopulated
    $LeftoverGeoIPLookups += ($EnrichedLogs | ? {-not ($_.org)}).IPAddress

    $ResolvedLeftoverGeoIPLookups = $LeftoverGeoIPLookups | % {Get-GeoIP  $_}
    $ResolvedLeftoverGeoIPLookups | Add-Member -MemberType NoteProperty -Name LookupDate -Value (MyDateTime -YearMonthDay)

    Move-Item -Path $GeoIPLookupTableFullPath -Destination ("$DirectoryOfGeoIPLookupTable\old_GeoIPLookupTable.csv")

    $newTable = $oldTable + $ResolvedLeftoverGeoIPLookups | Sort-Object {[version]$_.IP} -Unique

    $newTable | Export-Csv -NTI ($GeoIPLookupTableFullPath)

  }
  
  end {}
}