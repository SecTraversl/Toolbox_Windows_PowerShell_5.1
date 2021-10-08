
<#
Requires:
- RegRipper (rip.exe)
- Convert-UnixTime_to_WindowsTime.ps1
#>

# Normal Location of NTUser.DAT:
# - C:\Users\john.smith\NTUSER.DAT

# Registry location for this artifact:
# - HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{GUID}\Count

function Analyze-UserAssist {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the path to RegRipper (rip.exe)',Mandatory=$true)]
    [String]
    $RegRipper,
    [Parameter(HelpMessage='Reference the path to the NTUser.DAT hive file',Mandatory=$true)]
    [string]
    $NTUserHive,
    [Parameter(HelpMessage='Reference the Username that corresponds to the NTUser.DAT hive file')]
    [string]
    $Username,
    [Parameter(HelpMessage='Reference the Hostname of the system that is being analyzed')]
    [string]
    $Hostname
  )
  
  begin {
    $UserAssist_Parsed_TLN = & $RegRipper -r $NTUserHive -p userassist_tln -u $Username -s $Hostname

    $ConvertToObjects = $UserAssist_Parsed_TLN | ConvertFrom-Csv  -Delimiter "|" -Header Time,Source,System,User,Description
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