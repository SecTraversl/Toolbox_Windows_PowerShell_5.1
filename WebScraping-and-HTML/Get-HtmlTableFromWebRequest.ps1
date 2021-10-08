<#
.SYNOPSIS
  The "Get-HtmlTableFromWebRequest" function takes a given "HtmlWebResponseObject" (the returned object when using 'Invoke-WebRequest -Uri'), looks for Hyperlinks, and returns the content of the HTML Table in the form of custom PSObjects, along with the Anchor Text and the Hyperlink values.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> *htmltab  <tab>
  PS C:\> Get-HtmlTableFromWebRequest

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*htmltab" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $URI = 'https://www.bleepingcomputer.com/news/security/microsoft-february-2021-patch-tuesday-fixes-56-flaws-1-zero-day/'
  PS C:\> $Webpage = Invoke-WebRequest -Uri $URI

  PS C:\> $HtmlTable = Get-HtmlTableFromWebRequest -WebRequest $Webpage

  PS C:\> $HtmlTable | sort severity | select severity,'cve id','cve title',hyperlink

  Severity  CVE ID         CVE Title                                                                      Hyperlink
  --------  ------         ---------                                                                      ---------
  Critical  CVE-2021-24091 Windows Camera Codec Pack Remote Code Execution Vulnerability                  https://portal.msrc.micros...
  Critical  CVE-2021-24078 Windows DNS Server Remote Code Execution Vulnerability                         https://portal.msrc.micros...
  Critical  CVE-2021-24093 Windows Graphics Component Remote Code Execution Vulnerability                 https://portal.msrc.micros...
  Critical  CVE-2021-24081 Microsoft Windows Codecs Library Remote Code Execution Vulnerability           https://portal.msrc.micros...
  Critical  CVE-2021-24077 Windows Fax Service Remote Code Execution Vulnerability                        https://portal.msrc.micros...
  Critical  CVE-2021-24074 Windows TCP/IP Remote Code Execution Vulnerability                             https://portal.msrc.micros...
  Critical  CVE-2021-24094 Windows TCP/IP Remote Code Execution Vulnerability                             https://portal.msrc.micros...
  Critical  CVE-2021-1722  Windows Fax Service Remote Code Execution Vulnerability                        https://portal.msrc.micros...
  Critical  CVE-2021-24088 Windows Local Spooler Remote Code Execution Vulnerability                      https://portal.msrc.micros...
  Critical  CVE-2021-24112 .NET Core Remote Code Execution Vulnerability                                  https://portal.msrc.micros...
  Critical  CVE-2021-26701 .NET Core Remote Code Execution Vulnerability                                  https://portal.msrc.micros...
  Important CVE-2021-24106 Windows DirectX Information Disclosure Vulnerability                           https://portal.msrc.micros...
  Important CVE-2021-24092 Microsoft Defender Elevation of Privilege Vulnerability                        https://portal.msrc.micros...
  Important CVE-2021-24102 Windows Event Tracing Elevation of Privilege Vulnerability                     https://portal.msrc.micros...
  Important CVE-2021-1727  Windows Installer Elevation of Privilege Vulnerability                         https://portal.msrc.micros...
  Important CVE-2021-24103 Windows Event Tracing Elevation of Privilege Vulnerability                     https://portal.msrc.micros...
  Important CVE-2021-26700 Visual Studio Code npm-script Extension Remote Code Execution Vulnerability    https://portal.msrc.micros...
  Important CVE-2021-1639  Visual Studio Code Remote Code Execution Vulnerability                         https://portal.msrc.micros...
  Important CVE-2021-24083 Windows Address Book Remote Code Execution Vulnerability                       https://portal.msrc.micros...
  Important CVE-2021-24098 Windows Console Driver Denial of Service Vulnerability                         https://portal.msrc.micros...
  Important CVE-2021-24079 Windows Backup Engine Information Disclosure Vulnerability                     https://portal.msrc.micros...
  Important CVE-2021-24096 Windows Kernel Elevation of Privilege Vulnerability                            https://portal.msrc.micros...


  PS C:\> $HtmlTable | sort severity,tag | select severity,'cve id',tag,'cve title',hyperlink,* -ea SilentlyContinue | epcsv -NTI 2021-02-10_Patch-Tuesday_To-Do_List.csv
  PS C:\>
  PS C:\> ls *to-do*

      Directory: C:\

  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a----        2/10/2021   7:46 PM          12000 2021-02-10_Patch-Tuesday_To-Do_List.csv


  Here we first use "Invoke-WebRequest" to retrieve the contents of the given webpage and storing into the variable "$Webpage".  We then reference the "$Webpage" variable when calling the 'Get-HtmlTableFromWebRequest' function.  The function searches and finds the only HTML table present on the website and turns that table into usable PowerShell objects.  We then select certain properties of the objects to be displayed.  Finally, we sort and select the properties in the final order that we want before using 'epcsv' (the alias of "Export-Csv") to output the objects into a .csv file for later use.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-HtmlTableFromWebRequest.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-10 | Initial Version
  Dependencies: 
  Notes:
  - This was very helpful in describing outerHTML, <a> elements / tags, innerHTML, innerText, outerText, and more: https://4sysops.com/archives/powershell-invoke-webrequest-parse-and-scrape-a-web-page/
  - This was where I got the core of the code below, it didn't get the Hyperlinks so I had to do some modifying: https://www.leeholmes.com/blog/2015/01/05/extracting-tables-from-powershells-invoke-webrequest/

  .
#>
function Get-HtmlTableFromWebRequest {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the "HtmlWebResponseObject" that was returned from running the cmdlet "Invoke-WebRequest -Uri <url_for_the_webpage>"', Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] 
    $WebRequest,  
    [Parameter(Mandatory = $false)]
    [int] 
    $TableNumber
  )
  
  begin {}
  
  process {
    
    ## Extract the tables out of the web request
    $tables = @($WebRequest.ParsedHtml.getElementsByTagName("TABLE"))

    if (-not ($TableNumber)) {
      $table = $tables[0]
    }
    else {
      $table = $tables[$TableNumber]
    }

    $rows = @($table.Rows)

    ## Go through all of the rows in the table
    foreach ($row in $rows) {

      $cells = @($row.Cells)   

      ## If we've found a table header, remember its titles
      if ($cells[0].tagName -eq "TH") {

        $TableHeaders = @($cells | % { ("" + $_.InnerText).Trim() })
        continue
      }

      ## If we haven't found any table headers, make up names "P1", "P2", etc.
      if (-not $TableHeaders) {

        $TableHeaders = @(1..($cells.Count + 2) | % { "P$_" })

      }

      ## Now go through the cells in the the row. For each, try to find the
      ## title that represents that column and create a hashtable mapping those
      ## titles to content

      $resultObject = [Ordered] @{}

      for ($counter = 0; $counter -lt $cells.Count; $counter++) {

        $title = $TableHeaders[$counter]
        if (-not $title) { continue }  
        $resultObject[$title] = ("" + $cells[$counter].InnerText).Trim()

        # 2021-02-10 - TL - I added this in order to get the Hyperlink as a property
        if ($cells[$counter].firstChild.tagName -eq 'a') {
          $resultObject['AnchorText'] = $cells[$counter].firstChild.innerText
          $resultObject['Hyperlink'] = $cells[$counter].firstChild.href
        }
      }

      ## And finally cast that hashtable to a PSCustomObject
      [PSCustomObject] $resultObject

    }

  }
  
  end {}
}