<#
.SYNOPSIS
  WMIC wrapper for getting a Software Inventory on a local machine, a comma separated group of remote machines, or even a file list of remote machines.   If using the "-RemoteHost" parameter... *IMPORTANT* - If the hostname has a "-" or a "/" then wrap the hostname in double quotes and then single quotes (backticks are used in this example in place of single quotes), e.g.: <function-name> -RemoteHost `"RemLaptop-PC1"`,desktopPC'.  If using the "-HostListFile" parameter... *IMPORTANT* - The first line of the file needs be blank (press "Enter" to put a <CR><LF> on the first line) and put each host on a new line.
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-WmicSoftwareInventory -RemoteHost '"RemLaptop-PC1"',desktopPC | more

  Node          Name                                                                    Vendor                     Version
  ----          ----                                                                    ------                     -------
  RemLaptop-PC1 GoTo Opener                                                             LogMeIn                    Inc.
  RemLaptop-PC1 Microsoft DCF MUI (English) 2016                                        Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Professional Plus 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Visio Professional 2016                                       Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft OneNote MUI (English) 2016                                    Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office 32-bit Components 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Shared 32-bit MUI (English) 2016                       Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office OSM MUI (English) 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office OSM UX MUI (English) 2016                              Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft InfoPath MUI (English) 2016                                   Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Visio MUI (English) 2016                                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Access MUI (English) 2016                                     Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Shared Setup Metadata MUI (English) 2016               Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Excel MUI (English) 2016                                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Access Setup Metadata MUI (English) 2016                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft PowerPoint MUI (English) 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Publisher MUI (English) 2016                                  Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Outlook MUI (English) 2016                                    Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Groove MUI (English) 2016                                     Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Word MUI (English) 2016                                       Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Skype for Business MUI (English) 2016                         Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Proofing (English) 2016                                Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Shared MUI (English) 2016                              Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1 Microsoft Office Proofing Tools 2016 - English                          Microsoft Corporation      16.0.4266.1001



  If there is a "-" or a "/" in the Hostname, WMIC requires it to be wrapped in double "quotes".  Here we are requesting the Software Inventory for two machines. 

.EXAMPLE
  PS C:\> gc .\systems4.txt

  RemLaptop-PC1
  desktopPC
  PS C:\>
  PS C:\>
  PS C:\> Get-WmicSoftwareInventory -HostListFile systems4.txt | more

  Node                     Name                                                                    Vendor                     Version
  ----                     ----                                                                    ------                     -------
  RemLaptop-PC1            GoTo Opener                                                             LogMeIn                    Inc.
  RemLaptop-PC1            Microsoft DCF MUI (English) 2016                                        Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office Professional Plus 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Visio Professional 2016                                       Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft OneNote MUI (English) 2016                                    Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office 32-bit Components 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office Shared 32-bit MUI (English) 2016                       Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office OSM MUI (English) 2016                                 Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office OSM UX MUI (English) 2016                              Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft InfoPath MUI (English) 2016                                   Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Visio MUI (English) 2016                                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Access MUI (English) 2016                                     Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Office Shared Setup Metadata MUI (English) 2016               Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Excel MUI (English) 2016                                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft Access Setup Metadata MUI (English) 2016                      Microsoft Corporation      16.0.4266.1001
  RemLaptop-PC1            Microsoft PowerPoint MUI (English) 2016                                 Microsoft Corporation      16.0.4266.1001



  Here we have a file containing a blank line for the first line, then two hosts thereafter on their own line.  While we have to double " quote " any entry with "-" or "\" in the previous example, here when using this file that is not needed.
  
.INPUTS
.OUTPUTS
.NOTES
  - This was helpful in determining the correct syntax to manually parse a string with the correct format to make it a DateTime Object, and then display it a different way: https://stackoverflow.com/questions/38717490/convert-a-string-to-datetime-in-powershell
#>
function Get-WmicSoftwareInventory {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference a remote host for which you want to create a WMIC Software Inventory. *IMPORTANT* - If the hostname has a "-" or a "/" then wrap the hostname in double quotes and then single quotes (backticks are used in this example in place of single quotes), e.g.: <function-name> -RemoteHost `"RemLaptop-PC1"`,desktopPC')]
    [string[]]
    $RemoteHost,
    [Parameter(HelpMessage='Reference a file containg a list of hosts for which you want to create WMIC Software Inventories. *IMPORTANT* - The first line of the file needs be blank (press "Enter" to put a <CR><LF> on the first line) and put each host on a new line.')]
    [string]
    $HostListFile
  )
  
  begin {}
  
  process {
    if ($RemoteHost) {
      if ($RemoteHost.Length -gt 1) {
        $RemoteHost = $RemoteHost -join ","
      }
      $wmic = wmic /node:$RemoteHost product get Name,Version,Vendor,InstallDate,InstallLocation,IdentifyingNumber,PackageCache /format:csv
    }
    elseif ($HostListFile) {
      $wmic = wmic /node:@$HostListFile product get Name,Version,Vendor,InstallDate,InstallLocation,IdentifyingNumber,PackageCache /format:csv
    }
    else {
      $wmic = wmic product get Name,Version,Vendor,InstallDate,InstallLocation,IdentifyingNumber,PackageCache /format:csv
    }

    $final = $wmic | ? {$_} | ConvertFrom-Csv | 
    Select-Object `
      Node,Name,Version,Vendor,
      @{n='InstallDate';e={$date = $_.InstallDate; [datetime]::ParseExact($date, 'yyyyMMdd', $null).ToString('yyyy-MM-dd')}},
      InstallLocation,IdentifyingNumber,PackageCache
    Write-Output $final
  }
  
  end {}
}