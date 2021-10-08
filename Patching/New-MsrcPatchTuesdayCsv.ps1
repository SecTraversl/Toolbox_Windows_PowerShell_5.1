<#
.SYNOPSIS
  The "New-MsrcPatchTuesdayCsv" function leverages the API for the Microsft Security Response Center (MSRC) by way of a PowerShell module named "MsrcSecurityUpdates".  Various data is retrieved and customized such that a robust .csv is created containing the CVE, Criticality, Impact, KB Article ID, Exploitation status, Exploitation likelihood, and more.

.DESCRIPTION
.EXAMPLE
  PS C:\> *patchtues* <tab>
  PS C:\> New-MsrcPatchTuesdayCsv

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*patchtues*" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> New-MsrcPatchTuesdayCsv -Year 2021 -Month Feb -Verbose

  VERBOSE: Calling https://api.msrc.microsoft.com/cvrf/2021-Feb?api-version=2016-08-01
  VERBOSE: GET https://api.msrc.microsoft.com/cvrf/2021-Feb?api-version=2016-08-01 with 0-byte payload
  VERBOSE: received -1-byte response of content type application/json; charset=utf-8

  VERBOSE:
  Now running...:  Export-Csv -NTI "2021-02_Patch-Tuesday_Full-Report.csv"

  PS C:\>
  PS C:\> ls *patch*


      Directory: C:\Users\mark.johnson\Documents\Temp\temp


  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a----        2/12/2021   8:01 AM         500747 2021-02_Patch-Tuesday_Full-Report.csv



  Here we run the function with the mandatory parameters of "-Year" and "-Month". The "-Month" parameter includes a Validate Set, which allows us to tab through the various hard-coded arguments. Once the information has been retrieved from the API and has been parsed, the final output is exported to a .csv using the "Year" and "Month" provided.

.EXAMPLE

  PS C:\> $JanuaryPatches = New-MsrcPatchTuesdayCsv -Year 2021 -Month Jan -Verbose -DontExportCsv
  VERBOSE: Calling https://api.msrc.microsoft.com/cvrf/2021-Jan?api-version=2016-08-01
  VERBOSE: GET https://api.msrc.microsoft.com/cvrf/2021-Jan?api-version=2016-08-01 with 0-byte payload
  VERBOSE: received -1-byte response of content type application/json; charset=utf-8

  PS C:\>
  PS C:\> Get-CommandRuntime
  Minutes           : 2
  Seconds           : 12

  PS C:\> $JanuaryPatches | ? exploited -eq 'yes' | select CVE,Severity,Impact,Exploited,FullProductName | ft

  CVE           Severity Impact                Exploited FullProductName
  ---           -------- ------                --------- ---------------
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 1607 for 32-bit Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 1607 for x64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 for x64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server, version 20H2 (Server Core Installation)
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 for 32-bit Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 7 for x64-based Systems Service Pack 1
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 8.1 for 32-bit systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 7 for 32-bit Systems Service Pack 1
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server 2016
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server 2016  (Server Core installation)
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 2004 for 32-bit Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 2004 for ARM64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server, version 1909 (Server Core installation)
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 1909 for x64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 1909 for ARM64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 20H2 for 32-bit Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 20H2 for ARM64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 20H2 for x64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows 10 Version 2004 for x64-based Systems
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server, version 2004 (Server Core installation)
  CVE-2021-1647 Critical Remote Code Execution Yes       Windows Defender on Windows Server 2008 for 32-bit Systems Service Pack 2 (...



  Here we specify the switch parameter of "-DontExportCsv" which, instead of exporting the objects to a .csv returns the output to the terminal.  We capture the returned objects in the variable "$JanuaryPatches", and then select the vulnerabilites that have already been exploited in 'the wild', displaying the 'FullProductName' that each CVE applies to with 'ft' (the alias for "Format-Table").

.INPUTS
.OUTPUTS
.NOTES
  Name: New-MsrcPatchTuesdayCsv.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-04-28 | Created Separate CVSS columns, improved sorting
  Dependencies: Module - MsrcSecurityUpdates
  Notes:
  - This is the github URL for the MsrcSecurityUpdates PowerShell Module: https://github.com/microsoft/MSRC-Microsoft-Security-Updates-API
  - This is helpful in understanding the Vulnerability Descriptions in the New Version of the MSRC - Security Update Guide: https://msrc-blog.microsoft.com/2020/11/09/vulnerability-descriptions-in-the-new-version-of-the-security-update-guide/

  .
#>
function New-MsrcPatchTuesdayCsv {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Reference the 4 digit year, e.g. '2021'.",Mandatory=$true,ParameterSetName='Default')]
    [string]
    $Year,
    [Parameter(HelpMessage="Reference the 3 letter month, e.g. 'Jan' for 'January'. This paramater contains a Validate Set Attribute. Choose from the following options: ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'). You may use the <tab> key to toggle through the available option or to auto-complete.",Mandatory=$true,ParameterSetName='Default')]
    [ValidateSet('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')]
    [string]
    $Month,
    [Parameter(HelpMessage="Reference")]
    [switch]
    $DontExportCsv
  )
  
  begin {}
  
  process {       

    $monthOfInterest = "$Year-$Month"

    # Here we are evaluating if the user of this function set the '-Verbose' flag.  If they did, $VerbosePreference will be set by PowerShell to "Continue", instead of what it is by default ("SilentlyContinue").  We then pass that preference onto this embedded function of "Get-MsrcCvrfDocument" so it will also follow the verbosity preference set by the user.

    Write-Host ""
    if ($VerbosePreference -eq 'Continue') {
      $CvrfDocument = Get-MsrcCvrfDocument -ID $monthOfInterest -Verbose
    }
    else {
      $CvrfDocument = Get-MsrcCvrfDocument -ID $monthOfInterest 
    }
    Write-Host ""
    

    $ExploitabilityIndex = Get-MsrcCvrfExploitabilityIndex -Vulnerability $CvrfDocument.Vulnerability
    $AffectedSoftware = Get-MsrcCvrfAffectedSoftware -Vulnerability $CvrfDocument.Vulnerability -ProductTree $CvrfDocument.ProductTree
    
    $AffectedSoftwareWithArticleID = $AffectedSoftware | Select-Object CVE,Severity,Impact,@{n="Article";e={$_.KBArticle.ID}},FullProductName,RestartRequired,Supercedence,KBArticle,'Known Issue',CvssScoreSet
    
    $SoftwareAndExploitabilityInfo = foreach ($sw in $AffectedSoftwareWithArticleID) {
      $joiner = $ExploitabilityIndex | Where-Object cve -eq $sw.cve
    
      $prop = [ordered]@{
        CVE = $sw.CVE
        Severity = $sw.Severity
        Impact = $sw.Impact
        Article = $sw.Article
        FullProductName = $sw.FullProductName
        VulnerabilityTitle = $joiner.title
        CvssBaseScore = $sw.CvssScoreSet.Base
        CvssTemporalScore = $sw.CvssScoreSet.Temporal
        PubliclyDisclosed = $joiner.PubliclyDisclosed
        Exploited = $joiner.Exploited
        LatestSoftwareRelease = $joiner.LatestSoftwareRelease
        OlderSoftwareRelease = $joiner.OlderSoftwareRelease
        Supercedence = if ($sw.Supercedence.GetType().BaseType.Name -ne 'Object') { $sw.Supercedence = $sw.Supercedence | Select-Object -Unique } else { $sw.Supercedence }  # Added to prevent "System.Object[]" value when exported to .csv
        KBArticle = if ($sw.KBArticle.Count -gt 1) { $sw.KBArticle = $sw.KBArticle -split ',' -join ' ' } else { $sw.KBArticle }  # Added to prevent "System.Object[]" value when exported to .csv
        'Known Issue' = if ($sw.'Known Issue'.Count -gt 1) { $sw.'Known Issue' = $sw.'Known Issue' -split ',' -join ' ' } else { $sw.'Known Issue' }  # Added to prevent "System.Object[]" value when exported to .csv

        RestartRequired = if ($sw.RestartRequired.GetType().BaseType.Name -ne 'Object') { $sw.RestartRequired = $sw.RestartRequired | Select-Object -Unique } else { $sw.RestartRequired }  # Added to prevent "System.Object[]" value when exported to .csv
        CvssScoreSet = $sw.CvssScoreSet
      }
    
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
    
    # Sorted by Severity and Impact first
    $SoftwareAndExploitabilityInfo = $SoftwareAndExploitabilityInfo | Sort-Object Severity,Impact

    # Sorted primarily by CvssBaseScore
    $SoftwareAndExploitabilityInfo = $SoftwareAndExploitabilityInfo | Sort-Object cvssbasescore,cve,impact,fullproductname,vulnerabilitytitle -Descending


    # Given the "YYYY-MM" information, we use Get-Date in order to retrieve the numeric value for that particular month
    $NumericMonth = if ((Get-Date $monthOfInterest).Month.ToString().Length -lt 2) {
      "0" + (Get-Date $monthOfInterest).Month.ToString()
    } 
    else {
      (Get-Date $monthOfInterest).Month.ToString()
    }

    
    if ($DontExportCsv) {
      $SoftwareAndExploitabilityInfo
    }
    else {
      Write-Verbose "Now running...:  Export-Csv -NTI `"$($Year)-$($NumericMonth)_Microsoft-MSRC-Patch-Tuesday_Full-Report.csv`"`n" 

      $SoftwareAndExploitabilityInfo | Export-Csv -NTI "$($Year)-$($NumericMonth)_Microsoft-MSRC-Patch-Tuesday_Full-Report.csv"
    }
    Write-Host ""


  }
  
  end {}
}