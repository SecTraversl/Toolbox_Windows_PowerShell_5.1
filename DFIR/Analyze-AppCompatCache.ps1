
<#
Requires:
- RegRipper (rip.exe)
- Convert-UnixTime_to_WindowsTime.ps1
#>

# Normal Location of the SYSTEM hive:
# C:\Windows\System32\config\SYSTEM

# Registry path for AppCompatCache aka "Shim Cache"
# 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\'

# We tried using the 'appcompatcach_tln' plugin, but that version from 2019 wasn't outputting correctly
# - instead we found success with the 'shimcache_tln' plugin, which is what we use below


function Analyze-AppCompatCache {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the path to RegRipper (rip.exe)',Mandatory=$true)]
    [String]
    $RegRipper,
    [Parameter(HelpMessage='Reference the path to the SYSTEM hive',Mandatory=$true)]
    [string]
    $SystemHive,    
    [Parameter(HelpMessage='Reference the Hostname of the system that is being analyzed')]
    [string]
    $Hostname
  )
  
  begin {
    # This is analysis on the Amcache for the whole system, not particular to a specific user. Hence no -u Username is specified
    
    $ShimCache_tln = & $RegRipper -r $SYSTEM_hive -p shimcache_tln  -s $Hostname

    $ConvertToObjects = $ShimCache_tln | ConvertFrom-Csv  -Delimiter "|" -Header Time,Source,System,User,Description
  }
  
  process {
    foreach ($item in $ConvertToObjects) {
      $Time = Convert-UnixTime_to_WindowsTime ($item.Time)

      $prop = [ordered]@{
        Time = $Time
        Source = $item.Source
        System = $item.System
        User = $item.User
        Description = $item.Description
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
  }
  
  end {}
}