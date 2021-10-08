<#
.SYNOPSIS
  The "Get-SchTasks" function runs the "schtasks.exe" program verbosely and converts the text into meaninful objects.

.DESCRIPTION
.EXAMPLE
  PS C:\> $SchTasks = Get-SchTasks
  PS C:\> $SchTasks[20]

  ComputerName                 : LocLaptop-PC1
  TaskName                     : Office 15 Subscription Heartbeat
  TaskToRun                    : %ProgramFiles%\Common Files\Microsoft Shared\Office16\OLicenseHeartbeat.exe
  Status                       : Ready
  ScheduledTaskState           : Enabled
  LastRunTime                  : 1/9/2021 6:20:34 AM
  NextRunTime                  : 1/10.30.1 12:27:28 AM
  Author                       : Microsoft Office
  ScheduleType                 : Daily
  IdleTime                     : Disabled
  RunAsUser                    : SYSTEM
  StartIn                      : N/A
  Comment                      : Task used to ensure that the Microsoft Office Subscription licensing is current.
  Folder                       : \Microsoft\Office
  FullName                     : \Microsoft\Office\Office 15 Subscription Heartbeat
  Info                         :
  LastResult                   : 0
  PowerManagement              : Stop On Battery Mode
  DeleteTaskIfNotRescheduled   : Disabled
  StopTaskIfRunsXHoursandXMins : 04:00:00
  LogonMode                    : Interactive/Background
  StartTime                    : 12:00:00 AM
  StartDate                    : 1/1/2010
  EndDate                      : N/A
  Days                         : Every 1 day(s)
  Months                       : N/A
  Repeat_Every                 : Disabled
  Repeat_Until_Time            : Disabled
  Repeat_Until_Duration        : Disabled
  Repeat_StopIfStillRunning    : Disabled
  Schedule                     : Scheduling data is not available in this format.
  HostName                     : LocLaptop-PC1



  Here we run the function and then select the object at Index [20] in the array of objects.  This shows all of the properties related to the TaskName of "Office 15 Subscription Heartbeat"

.INPUTS
.OUTPUTS
.NOTES
  Name: Parse-SchTasksFile.ps1
  Author: Travis Logue
  Version History: 1.1 | 2020-01-09 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Parse-SchTasks {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the file containing the output of "schtasks.exe" run with "/Query /V /FO:LIST" parameters.')]
    [string[]]
    $File
  )
  
  begin {}
  
  process {
 
    $Files = $File

    $AllResults = foreach ($Doc in $Files) {

      $Results = Get-Content $File | Where-Object {$_}   # We are using "Where-Object {$_} to remove the blank lines from the output of the .exe"
      $SchTasks = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $SchTasks.Count; $i++) {

        if ($SchTasks[$i] -match "^Folder:") {

          $FolderName = $SchTasks[$i] -replace "^Folder: "
  
          if ($SchTasks[$i+1] -match "^INFO:") {
            $Info = $SchTasks[$i+1] -replace "^INFO: "
  
            $prop = [ordered]@{
              #ComputerName = $Computer
              Folder = $FolderName
              Info = $Info
              HostName = $null
              FullName = $null
              TaskName = "Under the parent folder of '$FolderName', There are no scheduled tasks presently available at your access level."
              NextRunTime = $null
              Status = $null
              LogonMode = $null
              LastRunTime = $null
              LastResult = $null
              Author = $null
              TaskToRun = $null
              StartIn = $null
              Comment = $null
              ScheduledTaskState = $null
              IdleTime = $null
              PowerManagement = $null
              RunAsUser = $null
              DeleteTaskIfNotRescheduled = $null
              StopTaskIfRunsXHoursandXMins = $null
              Schedule = $null
              ScheduleType = $null
              StartTime = $null
              StartDate = $null
              EndDate = $null
              Days = $null
              Months = $null
              Repeat_Every = $null
              Repeat_Until_Time = $null
              Repeat_Until_Duration = $null
              Repeat_StopIfStillRunning = $null
            }

            $obj = New-Object -TypeName psobject -Property $prop
            Write-Output $obj

          }
          elseif ($SchTasks[$i + 1] -match "^Hostname:") {

            $counter = 0  

            while ($SchTasks[$i + 1 + $counter] -notmatch "^Folder:" -and $SchTasks[$i + 1 + $counter] -notlike "END OF THE LINE") {

              $ObjectArray = @()
              do {
                $ObjectArray += $SchTasks[$i + 1 + $counter]
                $counter += 1
              } until ($SchTasks[$i + 1 + $counter] -match "^Hostname:" -or $SchTasks[$i + 1 + $counter] -match "^Folder:" -or $SchTasks[$i + 1 + $counter] -like "END OF THE LINE") 

              foreach ($e in $ObjectArray) {
                switch -regex ($e) {
                  '^HostName:' { $HostName_Value = (($e -split ":",2).trim())[1] }
                  '^TaskName:' { $TaskName_Value = (($e -split ":",2).trim())[1] }
                  '^Next Run Time:' { $NextRunTime_Value = (($e -split ":",2).trim())[1] }
                  '^Status:' { $Status_Value = (($e -split ":",2).trim())[1] }
                  '^Logon Mode:' { $LogonMode_Value = (($e -split ":",2).trim())[1] }
                  '^Last Run Time:' { $LastRunTime_Value = (($e -split ":",2).trim())[1] }
                  '^Last Result:' { $LastResult_Value = (($e -split ":",2).trim())[1] }
                  '^Author:' { $Author_Value = (($e -split ":",2).trim())[1] }
                  '^Task To Run:' { $TaskToRun_Value = (($e -split ":",2).trim())[1] }
                  '^Start In:' { $StartIn_Value = (($e -split ":",2).trim())[1] }
                  '^Comment:' { $Comment_Value = (($e -split ":",2).trim())[1] }
                  '^Scheduled Task State:' { $ScheduledTaskState_Value = (($e -split ":",2).trim())[1] }
                  '^Idle Time:' { $IdleTime_Value = (($e -split ":",2).trim())[1] }
                  '^Power Management:' { $PowerManagement_Value = (($e -split ":",2).trim())[1] }
                  '^Run As User:' { $RunAsUser_Value = (($e -split ":",2).trim())[1] }
                  '^Delete Task If Not Rescheduled:' { $DeleteTaskIfNotRescheduled_Value = (($e -split ":",2).trim())[1] }
                  '^Stop Task If Runs X Hours and X Mins:' { $StopTaskIfRunsXHoursandXMins_Value = (($e -split ":",2).trim())[1] }
                  '^Schedule:' { $Schedule_Value = (($e -split ":",2).trim())[1] }
                  '^Schedule Type:' { $ScheduleType_Value = (($e -split ":",2).trim())[1] }
                  '^Start Time:' { $StartTime_Value = (($e -split ":",2).trim())[1] }
                  '^Start Date:' { $StartDate_Value = (($e -split ":",2).trim())[1] }
                  '^End Date:' { $EndDate_Value = (($e -split ":",2).trim())[1] }
                  '^Days:' { $Days_Value = (($e -split ":",2).trim())[1] }
                  '^Months:' { $Months_Value = (($e -split ":",2).trim())[1] }
                  '^Repeat: Every:' { $Repeat_Every_Value = (($e -split ":",3).trim())[-1] }
                  '^Repeat: Until: Time:' { $Repeat_Until_Time_Value = (($e -split ":",4).trim())[-1] }
                  '^Repeat: Until: Duration:' { $Repeat_Until_Duration_Value = (($e -split ":",4).trim())[-1] }
                  '^Repeat: Stop If Still Running:' { $Repeat_StopIfStillRunning_Value = (($e -split ":",3).trim())[-1] }
                }
              }

              $prop = [ordered]@{
                #ComputerName = $Computer
                Folder = $FolderName
                Info = $null
                HostName = $HostName_Value
                FullName = $TaskName_Value
                TaskName = $TaskName_Value | Split-Path -Leaf
                NextRunTime = $NextRunTime_Value
                Status = $Status_Value
                LogonMode = $LogonMode_Value
                LastRunTime = $LastRunTime_Value
                LastResult = $LastResult_Value
                Author = $Author_Value
                TaskToRun = $TaskToRun_Value
                StartIn = $StartIn_Value
                Comment = $Comment_Value
                ScheduledTaskState = $ScheduledTaskState_Value
                IdleTime = $IdleTime_Value
                PowerManagement = $PowerManagement_Value
                RunAsUser = $RunAsUser_Value
                DeleteTaskIfNotRescheduled = $DeleteTaskIfNotRescheduled_Value
                StopTaskIfRunsXHoursandXMins = $StopTaskIfRunsXHoursandXMins_Value
                Schedule = $Schedule_Value
                ScheduleType = $ScheduleType_Value
                StartTime = $StartTime_Value
                StartDate = $StartDate_Value
                EndDate = $EndDate_Value
                Days = $Days_Value
                Months = $Months_Value
                Repeat_Every = $Repeat_Every_Value
                Repeat_Until_Time = $Repeat_Until_Time_Value
                Repeat_Until_Duration = $Repeat_Until_Duration_Value
                Repeat_StopIfStillRunning = $Repeat_StopIfStillRunning_Value
              }             
      
              $obj = New-Object -TypeName psobject -Property $prop
              Write-Output $obj

            }         
          

          }
  

        }

      }

    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,TaskName,TaskToRun,Status,ScheduledTaskState,LastRunTime,NextRunTime,Author,ScheduleType,IdleTime,RunAsUser,StartIn,Comment,Folder,FullName,Info,LastResult,PowerManagement,DeleteTaskIfNotRescheduled,StopTaskIfRunsXHoursandXMins,LogonMode,StartTime,StartDate,EndDate,Days,Months,Repeat_Every,Repeat_Until_Time,Repeat_Until_Duration,Repeat_StopIfStillRunning,Schedule,HostName

    Write-Output $SpecificSelectionOrder

  }
  
  end {}
}