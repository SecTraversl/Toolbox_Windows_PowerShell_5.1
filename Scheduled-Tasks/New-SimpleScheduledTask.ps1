<#
.SYNOPSIS
  The "New-SimpleScheduledTask" function stitches together functionality from 3 cmdlets in order to create a simple scheduled task using one command line tool.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: New-SimpleScheduledTask.ps1
  Author: Travis Logue
  Version History: 1.0 | 2020-01-12 | Initial Version
  Dependencies:
  Notes:
  - This was the reference article I used to build the code below: https://adamtheautomator.com/powershell-scheduled-task/

  .
#>
function New-SimpleScheduledTask {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the name for the scheduled task you are creating.',Mandatory=$true)]
    [string]
    $TaskName,
    [Parameter(HelpMessage='Reference the description for the scheudled task you are creating.')]
    [string]
    $Description,
    [Parameter(HelpMessage='Reference the program that you want to execute.',Mandatory=$true)]
    [Alias('Execute')]
    [string]
    $ProgramToExecute,
    [Parameter(HelpMessage='Reference the arguments to run with the program, if any.')]
    [Alias('Args')]
    [string]
    $ArgumentsForProgram,
    [Parameter(HelpMessage="Reference the time frame for task execution. This paramater contains a Validate Set Attribute - Choose from the following options: 'Once','Weekly','Daily','AtLogOn','AtStartup'. You may use the <tab> key to toggle through the available option or to auto-complete.",Mandatory=$true)]
    [ValidateSet('Once','Weekly','Daily','AtLogOn','AtStartup')]
    [string]
    $TriggerTimeFrame,
    [Parameter(HelpMessage='Reference the DateTime for the task to run (Applies to "Once","Weekly", and "Daily" TriggerTimeFrame.')]
    [DateTime]
    $AtDateTime,
    [Parameter(HelpMessage='Reference the interval in terms of weeks for the task to run. "1" will cause the task to run once a week. (Applies to "Weekly" TriggerTimeFrame.')]
    [Int32]
    $WeeksInterval,
    [Parameter(HelpMessage='Reference the days of the week for the task to run. Options include: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday. (Applies to "Weekly" TriggerTimeFrame.')]
    [DayOfWeek[]]
    $DaysOfWeek,
    [Parameter(HelpMessage='Reference the User whom, when they logon, will cause the task to run (Applies to "AtLogon" TriggerTimeFrame.')]
    [string]
    $UserAtLogOn
  )
  
  begin {}
  
  process {

    if ($ArgumentsForProgram) {
      $TaskAction = New-ScheduledTaskAction -Execute $ProgramToExecute -Argument $ArgumentsForProgram
    }
    $TaskAction = New-ScheduledTaskAction -Execute $ProgramToExecute 

    switch ($TriggerTimeFrame) {
      'Once' { $TaskTrigger = New-ScheduledTaskTrigger -Once -At $AtDateTime}
      'AtStartup' { $TaskTrigger = New-ScheduledTaskTrigger -AtStartup }
      'AtLogOn' { $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $UserAtLogOn }
      'Daily' { $TaskTrigger = New-ScheduledTaskTrigger -Daily -At $AtDateTime }
      'Weekly' { $TaskTrigger = New-ScheduledTaskTrigger -Weekly -At $AtDateTime -WeeksInterval $WeeksInterval -DaysOfWeek $DaysOfWeek }
    
    }
    
    if ($Description) {
      Register-ScheduledTask -TaskName $TaskName -Description $Description -Action $TaskAction -Trigger $TaskTrigger
    }
    else {
      Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger
    }



    Write-Host "`nScheduled Task by name of '$TaskName' has been registered at this time`n"
    Write-Host "`nTo confirm task registration, run the command...  'Get-ScheduledTaskInfo -TaskName $TaskName'`n" -ForegroundColor Yellow -BackgroundColor black
    Write-Host "`nTo run the task immediately, run the command...  'Start-ScheduledTask -TaskName $TaskName'`n" -ForegroundColor Yellow -BackgroundColor black
    Write-Host "`nTo unregister/delete the task, run the command...  'Unregister-ScheduledTask -TaskName $TaskName -Force'`n" -ForegroundColor Yellow -BackgroundColor black

  }
  
  end {}
}