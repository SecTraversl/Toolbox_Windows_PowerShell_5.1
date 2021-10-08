<#
.SYNOPSIS
  The "Get-WmicStartupProgram" function is a WMIC command wrapper for getting a list of startup programs, particularly those found in the "Startup" folder and the "Run" registry keys.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Startup = Get-WmicStartupProgram
  PS C:\> $Startup | ? description -like "*Lync*"

  ComputerName : LocLaptop-PC1
  Description  : Lync
  User         : CORP\mark.johnson
  Command      : "C:\Program Files\Microsoft Office\Office16\lync.exe" /fromrunkey
  Location     : HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  UserSID      :
  SettingID    :
  Caption      : Lync
  Name         : Lync



  Here we run the function without additional parameters which, by default, queries the local machine.  We then specifically filtered for a Startup program with a Description property containing "Lync" and displayed all of the properties of that object.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Startup = Get-WmicStartupProgram -ComputerName $list
  PS C:\> $Startup | ft -Property ComputerName,Description,User,Location

  ComputerName                   Description                 User                         Location
  ------------                   -----------                 ----                         --------
  LocLaptop-PC1                  OneDriveSetup               NT AUTHORITY\LOCAL SERVICE   HKU\S-1-5-19\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  LocLaptop-PC1                  OneDriveSetup               NT AUTHORITY\NETWORK SERVICE HKU\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  LocLaptop-PC1                  Send to OneNote             CORP\mark.johnson            Startup
  LocLaptop-PC1                  OneDrive                    CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  com.squirrel.slack.slack    CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  Lync                        CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  Zoom                        CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  com.squirrel.Teams.Teams    CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  RingCentral Meetings        CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  LocLaptop-PC1                  SecurityHealth              Public                       HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  LocLaptop-PC1                  SurfaceDTX.exe              Public                       HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  LocLaptop-PC1                  Logitech Download Assistant Public                       HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  RemDesktopPC.corp.Roxboard.com OneDriveSetup               NT AUTHORITY\LOCAL SERVICE   HKU\S-1-5-19\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  RemDesktopPC.corp.Roxboard.com OneDriveSetup               NT AUTHORITY\NETWORK SERVICE HKU\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  RemDesktopPC.corp.Roxboard.com RingCentral                 CORP\mark.johnson            Startup
  RemDesktopPC.corp.Roxboard.com Send to OneNote             CORP\mark.johnson            Startup
  RemDesktopPC.corp.Roxboard.com OneDrive                    CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  RemDesktopPC.corp.Roxboard.com com.squirrel.Teams.Teams    CORP\mark.johnson            HKU\S-1-5-21-102932503-109117628-3773961456-57276\SOFTWARE\Microsoft\Windows\CurrentVersi...
  RemDesktopPC.corp.Roxboard.com SecurityHealth              Public                       HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  RemDesktopPC.corp.Roxboard.com Veeam.EndPoint.Tray.exe     Public                       HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Startup" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we also specified particular properties that we wanted "Format-Table" to display.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicStartupProgram
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicStartupProgram {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $wmic = 'wmic.exe'
    [array]$param = @()

    # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes    
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    $AllResults = foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"",'startup','get','/format:list'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicStartupListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicStartupListFull.Count; $i++) {
        if ($WmicStartupListFull[$i] -like "Caption=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicStartupListFull[$i + $counter]
            $counter += 1
          } until ($WmicStartupListFull[$i+1 + $counter] -like "Caption=*" -or $WmicStartupListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^Command=' { $Command_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^Location=' { $Location_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^SettingID=' { $SettingID_Value = (($e -split "=",2).trim())[1] }
              '^User=' { $User_Value = (($e -split "=",2).trim())[1] }
              '^UserSID=' { $UserSID_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            Caption = $Caption_Value
            Command = $Command_Value
            Description = $Description_Value
            Location = $Location_Value
            Name = $Name_Value
            SettingID = $SettingID_Value
            User = $User_Value
            UserSID = $UserSID_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,User,Command,Location,UserSID,SettingID,Caption,Name

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}