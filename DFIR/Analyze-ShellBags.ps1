
<#
Requires:
- RegRipper (rip.exe)
- Convert-UnixTime_to_WindowsTime.ps1
#>

# Normal Location of UsrClass.DAT:
# - C:\Users\john.smith\AppData\Local\Microsoft\Windows\UsrClass.dat

# Registry location(s) for this artifact:
# - HKCU:\Software\Microsoft\Windows\Shell\BagMRU\
# - HKCU:\Software\Microsoft\Windows\Shell\Bags\


# "Explorer" location(s) for this artifact {NOTE...Perhaps this is only available if you have mounted the drive of a dead system for analysis... I was not able to browse here on my live system}
# - USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\Bags
# - USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\BagMRU


function Analyze-ShellBags {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the path to RegRipper (rip.exe)',Mandatory=$true)]
    [String]
    $RegRipper,
    [Parameter(HelpMessage='Reference the path to the UsrClass.DAT hive file',Mandatory=$true)]
    [string]
    $UsrClassHive,
    [Parameter(HelpMessage='Reference the Username that corresponds to the NTUser.DAT hive file')]
    [string]
    $Username,
    [Parameter(HelpMessage='Reference the Hostname of the system that is being analyzed')]
    [string]
    $Hostname
  )
  
  begin {
    $ShellBags_tln = & $RegRipper -r $UsrClassHive -p shellbags_tln -u $Username -s $Hostname

    $ConvertToObjects = $ShellBags_tln | ConvertFrom-Csv  -Delimiter "|" -Header Time,Source,System,User,Description
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
  
  end {
    
  }
}