<#
.SYNOPSIS
  This function tests WMI and DCOM access by querying the "Win32_ComputerSystem" class and retrieving the "Name" property of the computer.
.DESCRIPTION
.EXAMPLE
  PS C:\> $uplist = ipcsv .\Uplist_2020-12-09.csv
  PS C:\> $NewTestAll = Test-WmiDcom -ComputerName ($uplist.dnshostname)
  PS C:\> Get-CommandRuntime
  Days              : 0
  Hours             : 0
  Minutes           : 2
  Seconds           : 37
  
  PS C:\> $uplist | measure
  Count    : 165
  
  PS C:\> $NewTestAll | measure
  Count    : 3
  PS C:\>
  PS C:\> $NewTestAll | ft

  Domain            Manufacturer Model      Name            PrimaryOwnerName TotalPhysicalMemory
  ------            ------------ -----      ----            ---------------- -------------------
  corp.Roxboard.com Microsoft... Surface... LocLaptop-PC1   admin                     8507445248
  corp.Roxboard.com Dell Inc.    Latitud... RBRUGCSARPONT-L staff                     8490827776
  corp.Roxboard.com LENOVO       4157D51    RemDesktopPC    Windows User             25760673792



  Here we are importing a list of reachable hosts from a .csv, then feeding the "DnsHostName" of those hosts to the 'Test-WmiDcom' function.  The computer name and other properties about the computer are returned for those systems that we have WMI / DCOM access to with the current credentials of the PowerShell terminal.

.INPUTS
.OUTPUTS
.NOTES
  Notes: 
  - This was helpful in creating a "catch all" for any Error and writing valuable output about the Error to the screen: https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-exceptions?view=powershell-7.1


  .
#>
function Test-WmiDcom {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the ComputerName(s) to test for WMI / DCOM access.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {
    try {
      Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName -AsJob <#| Wait-Job -Timeout 7#> | Receive-Job -Wait <#-ErrorVariable err#> -ErrorAction Ignore
    }
    # By using the final catch below and writing " $($PSItem.Exception) " to the screen, I was able to derive the correct Error class to catch - which was in this case: [System.Runtime.InteropServices.COMException]
    catch [System.Runtime.InteropServices.COMException] {
      # This is here in order to prevent this particular Error class from being displayed to the screen
    }
    catch {
      Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
    }
  }
  
  end {}
}