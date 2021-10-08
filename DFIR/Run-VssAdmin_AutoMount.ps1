

<#
Requires:
- Get-VssAdminListShadows.ps1
- Get-Number.ps1

#>


function Run-VssAdmin_AutoMount {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the name you want the Directory to be called, and the full path if you are not currently in the directory you wish to make the mount point.  EXAMPLE-1: "DemoDirectory" will create a new Directory named "DemoDirectory" in the current folder.  EXAMPLE-2: This will also work-- Run-VssAdmin_AutoMount -MountDirectoryFullPathAndName "$((pwd).path)\demo" ',Mandatory=$true)]
    [string]
    $MountDirectoryFullPathAndName,
    [Parameter(HelpMessage='This is a "ValidateSet" with hard coded arguments for either "MostRecent" or "LeastRecent".  DEFAULT is "MostRecent"')]
    [ValidateSet("MostRecent","LeastRecent")]
    [string]
    $VolumeShadowCopy = "MostRecent"

  )
  
  begin {
    $vss = Get-VssAdminListShadows
  }
  
  process {
    if ($VolumeShadowCopy -eq "MostRecent") {
      $ChosenVS = $vss | Where-Object {$_.CreationTime -like (Get-Number -Highest ($vss.creationtime))}
    }
    elseif ($VolumeShadowCopy -eq "LeastRecent") {
      $ChosenVS = $vss | Where-Object {$_.CreationTime -like (Get-Number -Lowest ($vss.creationtime))}
    }
  }
  
  end {
    # Had to do a little extra specific quoting here.  "mklink" needs to have "double quotes" around the Argument (which is the Full Path) you give to the '/d' Parameter; particularly when you are giving a Full Path which has spaces in it.  
    # - EXAMPLE: "C:\Users\john.smith\Documents\Temp\DFIR testing\Volume Shadow Stuff\demo"

    'mklink /d "' + "$($MountDirectoryFullPathAndName)" + '" ' + "$($ChosenVS.ShadowCopyVolume + '\')" | cmd.exe
  }
}
