<#
.SYNOPSIS
  The "Get-WmicSysDriver" function is a WMIC command wrapper for getting a list of installed drivers and related information on one or many computers.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Drivers = Get-WmicSysDriver
  PS C:\> $Drivers | select -f 10 | ft

  ComputerName  Description                         ServiceType   PathName                                 State   StartMode ErrorControl AcceptStop
  ------------  -----------                         -----------   --------                                 -----   --------- ------------ ----------
  LocLaptop-PC1 1394 OHCI Compliant Host Controller Kernel Driver C:\Windows\system32\drivers\1394ohci.sys Stopped Manual    Normal       FALSE
  LocLaptop-PC1 3ware                               Kernel Driver C:\Windows\system32\drivers\3ware.sys    Stopped Manual    Normal       FALSE
  LocLaptop-PC1 Microsoft ACPI Driver               Kernel Driver C:\Windows\system32\drivers\ACPI.sys     Running Boot      Critical     TRUE
  LocLaptop-PC1 ACPI Devices driver                 Kernel Driver C:\Windows\system32\drivers\AcpiDev.sys  Stopped Manual    Normal       FALSE
  LocLaptop-PC1 Microsoft ACPIEx Driver             Kernel Driver C:\Windows\system32\Drivers\acpiex.sys   Running Boot      Critical     TRUE
  LocLaptop-PC1 ACPI Processor Aggregator Driver    Kernel Driver C:\Windows\system32\drivers\acpipagr.sys Running Manual    Normal       TRUE
  LocLaptop-PC1 ACPI Power Meter Driver             Kernel Driver C:\Windows\system32\drivers\acpipmi.sys  Stopped Manual    Normal       FALSE
  LocLaptop-PC1 ACPI Wake Alarm Driver              Kernel Driver C:\Windows\system32\drivers\acpitime.sys Stopped Manual    Normal       FALSE
  LocLaptop-PC1 Acx01000                            Kernel Driver C:\Windows\system32\drivers\Acx01000.sys Stopped Manual    Normal       FALSE
  LocLaptop-PC1 ADP80XX                             Kernel Driver C:\Windows\system32\drivers\ADP80XX.SYS  Stopped Manual    Normal       FALSE



  Here we run the function without additional parameters which, by default, queries the local machine.  Driver Description, PathName, State, and StartMode are key components of the output.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\> 
  PS C:\> $Drivers = Get-WmicSysDriver -ComputerName $list
  PS C:\> $Drivers | Where-Object ServiceType -NotLike "Kernel Driver" | sort pathname | ft

  ComputerName                   Description                                   ServiceType        PathName
  ------------                   -----------                                   -----------        --------
  LocLaptop-PC1                  fe_avk                                        File System Driver \??\C:\ProgramData\FireEye\xagt\exts\MalwareProtection\sandbox\fe_avk.sys
  RemDesktopPC.corp.Roxboard.com fe_avk                                        File System Driver \??\C:\ProgramData\FireEye\xagt\exts\MalwareProtection\sandbox\fe_avk.sys
  RemDesktopPC.corp.Roxboard.com AppvStrm                                      File System Driver C:\WINDOWS\system32\drivers\AppvStrm.sys
  LocLaptop-PC1                  AppvStrm                                      File System Driver C:\Windows\system32\drivers\AppvStrm.sys
  RemDesktopPC.corp.Roxboard.com AppvVemgr                                     File System Driver C:\WINDOWS\system32\drivers\AppvVemgr.sys
  LocLaptop-PC1                  AppvVemgr                                     File System Driver C:\Windows\system32\drivers\AppvVemgr.sys
  LocLaptop-PC1                  AppvVfs                                       File System Driver C:\Windows\system32\drivers\AppvVfs.sys
  RemDesktopPC.corp.Roxboard.com AppvVfs                                       File System Driver C:\WINDOWS\system32\drivers\AppvVfs.sys
  RemDesktopPC.corp.Roxboard.com Windows Bind Filter Driver                    File System Driver C:\WINDOWS\system32\drivers\bindflt.sys
  LocLaptop-PC1                  Windows Bind Filter Driver                    File System Driver C:\Windows\system32\drivers\bindflt.sys
  LocLaptop-PC1                  Browser                                       File System Driver C:\Windows\system32\DRIVERS\bowser.sys
  RemDesktopPC.corp.Roxboard.com Browser                                       File System Driver C:\WINDOWS\system32\DRIVERS\bowser.sys
  LocLaptop-PC1                  CD/DVD File System Reader                     File System Driver C:\Windows\system32\DRIVERS\cdfs.sys
  RemDesktopPC.corp.Roxboard.com CD/DVD File System Reader                     File System Driver C:\WINDOWS\system32\DRIVERS\cdfs.sys
  LocLaptop-PC1                  Windows Cloud Files Filter Driver             File System Driver C:\Windows\system32\drivers\cldflt.sys
  RemDesktopPC.corp.Roxboard.com Windows Cloud Files Filter Driver             File System Driver C:\WINDOWS\system32\drivers\cldflt.sys
  LocLaptop-PC1                  DFS Namespace Client Driver                   File System Driver C:\Windows\system32\Drivers\dfsc.sys
  RemDesktopPC.corp.Roxboard.com DFS Namespace Client Driver                   File System Driver C:\WINDOWS\system32\Drivers\dfsc.sys



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Drivers" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we see filter for drivers that are *NOT* like "Kernel Driver" and then sort by PathName.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicSysDriver
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicSysDriver {
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
      $param = "/node:`"$($Computer)`"",'sysdriver','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicSysDriverListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicSysDriverListFull.Count; $i++) {
        if ($WmicSysDriverListFull[$i] -like "AcceptPause=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicSysDriverListFull[$i + $counter]
            $counter += 1
          } until ($WmicSysDriverListFull[$i+1 + $counter] -like "AcceptPause=*" -or $WmicSysDriverListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AcceptPause=' { $AcceptPause_Value = (($e -split "=",2).trim())[1] }
              '^AcceptStop=' { $AcceptStop_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DesktopInteract=' { $DesktopInteract_Value = (($e -split "=",2).trim())[1] }
              '^DisplayName=' { $DisplayName_Value = (($e -split "=",2).trim())[1] }
              '^ErrorControl=' { $ErrorControl_Value = (($e -split "=",2).trim())[1] }
              '^ExitCode=' { $ExitCode_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^PathName=' { $PathName_Value = (($e -split "=",2).trim())[1] }
              '^ServiceSpecificExitCode=' { $ServiceSpecificExitCode_Value = (($e -split "=",2).trim())[1] }
              '^ServiceType=' { $ServiceType_Value = (($e -split "=",2).trim())[1] }
              '^Started=' { $Started_Value = (($e -split "=",2).trim())[1] }
              '^StartMode=' { $StartMode_Value = (($e -split "=",2).trim())[1] }
              '^StartName=' { $StartName_Value = (($e -split "=",2).trim())[1] }
              '^State=' { $State_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^SystemName=' { $SystemName_Value = (($e -split "=",2).trim())[1] }
              '^TagId=' { $TagId_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AcceptPause = $AcceptPause_Value
            AcceptStop = $AcceptStop_Value
            Description = $Description_Value
            DesktopInteract = $DesktopInteract_Value
            DisplayName = $DisplayName_Value
            ErrorControl = $ErrorControl_Value
            ExitCode = $ExitCode_Value
            InstallDate = $InstallDate_Value
            Name = $Name_Value
            PathName = $PathName_Value
            ServiceSpecificExitCode = $ServiceSpecificExitCode_Value
            ServiceType = $ServiceType_Value
            Started = $Started_Value
            StartMode = $StartMode_Value
            StartName = $StartName_Value
            State = $State_Value
            Status = $Status_Value
            SystemName = $SystemName_Value
            TagId = $TagId_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,ServiceType,PathName,State,StartMode,ErrorControl,AcceptStop,AcceptPause,StartName,ExitCode,DesktopInteract,ServiceSpecificExitCode,Started,DisplayName,InstallDate,Name,Status,SystemName,TagId

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}