<#
.SYNOPSIS
  The "Get-WinEventPlus" function allows for a variety of Windows Event Log queries to be made in a simple fashion with succinct syntax.  The "-Session" parameter allows you to query a remote machine's Event Logs over an existing PSSession.

.DESCRIPTION

.EXAMPLE
  PS C:\> gwe -ListLog *power*

  LogMode   MaximumSizeInBytes RecordCount LogName
  -------   ------------------ ----------- -------
  Circular            15728640        1947 Windows PowerShell
  Circular            15728640       12339 Microsoft-Windows-PowerShell/Operational
  Retain            1048985600           0 Microsoft-Windows-PowerShell/Admin
  Circular             1052672           0 Microsoft-Windows-PowerShell-DesiredStateConfiguration-FileDownloadManager/Operational
  Circular             1052672           0 Microsoft-Windows-Kernel-Power/Thermal-Operational



  Here we use the alias of "gwe" for "Get-WinEvent" in order to get a listing of the official log name based on a partial word match of '*power*'.  We will use the full log name when doing queries with the "Get-WinEventPlus" tool.

.EXAMPLE
  PS C:\> gwep -LogName 'Windows PowerShell' -BookEnds


    ProviderName: PowerShell

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  2/3/2021 7:16:16 AM            800 Information      Pipeline execution details for command line: . ...
  2/2/2021 5:12:56 PM            800 Information      Pipeline execution details for command line:               % { Get-ADUser -Fil...


  PS C:\> gwep -LogName 'Windows PowerShell' -BookEnds -Session (Get-PSSession)


    ProviderName: PowerShell

  TimeCreated                     Id LevelDisplayName Message                                  PSComputerName
  -----------                     -- ---------------- -------                                  --------------
  2/3/2021 7:15:28 AM            800 Information      Pipeline execution details for comman... RemDesktopPC
  1/25/2021 9:05:27 AM           800 Information      Pipeline execution details for comman... RemDesktopPC



  Here we run the function using its built-in alias of "gwep" and the switch parameter "-BookEnds".  The "-BookEnds" switch parameter retrieves the most recent and least recent logs from the log file, which allows us to see how far back the logs go.  In the examples here, we used the "-BookEnds" switch parameter on the local machine, and then used it again while interacting with a remote machine over an established PSSession.

.EXAMPLE
  PS C:\> gwep -LogName security -EventId 4625 | select -f 10


    ProviderName: Microsoft-Windows-Security-Auditing

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  2/2/2021 6:24:15 AM           4625 Information      An account failed to log on....
  1/29/2021 11:33:42 AM         4625 Information      An account failed to log on....
  1/29/2021 10:45:15 AM         4625 Information      An account failed to log on....
  1/29/2021 10:42:52 AM         4625 Information      An account failed to log on....
  1/29/2021 10:41:57 AM         4625 Information      An account failed to log on....
  1/29/2021 10:41:57 AM         4625 Information      An account failed to log on....
  1/29/2021 10:40:53 AM         4625 Information      An account failed to log on....
  1/29/2021 10:27:31 AM         4625 Information      An account failed to log on....
  1/29/2021 10:24:36 AM         4625 Information      An account failed to log on....
  1/29/2021 10:24:07 AM         4625 Information      An account failed to log on....


  
  Here we run the function using its built-in alias of "gwep". We specify the "-LogName" of 'Security' and the "-EventId" of '4625' in order to find the most recent failed logon attempts.

.EXAMPLE
  PS C:\> gwep -LogName 'System' -DaysPrior 3 -Oldest | select -f 10

    ProviderName: Microsoft-Windows-GroupPolicy

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 8:53:32 AM          1500 Information      The Group Policy settings for the computer were processed successfully. There ...

    ProviderName: Microsoft-Windows-Ntfs

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:03:52 AM            98 Information      Volume D: (\Device\HarddiskVolume7) is healthy.  No action is needed.
  1/31/2021 9:03:55 AM            98 Information      Volume E: (\Device\HarddiskVolume8) is healthy.  No action is needed.

    ProviderName: Microsoft-Windows-DistributedCOM

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:21:52 AM         10016 Warning          The machine-default permission settings do not grant Local Activation permissi...
  1/31/2021 9:22:03 AM         10016 Warning          The machine-default permission settings do not grant Local Activation permissi...

    ProviderName: Microsoft-Windows-Kernel-Power

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:22:21 AM           506 Information      The system is entering connected standby ...

    ProviderName: Microsoft-Windows-Kernel-General

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:22:21 AM             1 Information      The system time has changed to ‎2021‎-‎01‎-‎31T17:22:21.916530500Z from ‎2021‎...

    ProviderName: Microsoft-Windows-DNS-Client

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:22:26 AM          8015 Warning          The system failed to register host (A or AAAA) resource records (RRs) for netw...

    ProviderName: Microsoft-Windows-Time-Service

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/31/2021 9:27:24 AM           131 Warning          NtpClient was unable to set a domain peer to use as a time source because of D...
  1/31/2021 9:27:29 AM           131 Warning          NtpClient was unable to set a domain peer to use as a time source because of D...



  Here we run the function using its built-in alias of "gwep". We specify the "-Logname" of 'System' along with "-DaysPrior 3" and start with the "-Oldest" first.  We use "Select-Object -First 10" in order to display the first 10 of that set of logs that we retrieved.

.EXAMPLE
  PS C:\> Get-PSSession | ? ComputerName -eq "RemDesktopPC"

  Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
  -- ----            ------------    ------------    -----         -----------------     ------------
    1 WinRM1          RemDesktopPC    RemoteMachine   Opened        Microsoft.PowerShell     Available

  PS C:\> $RemDesktopPCSession = Get-PSSession | ? ComputerName -eq "RemDesktopPC"

  PS C:\> Copy-Item  -Path "$env:Windir\System32\winevt\Logs\Setup.evtx" -Destination '.\RemDesktopPC_Setup.evtx' -FromSession $RemDesktopPCSession

  PS C:\> gwep -Path .\RemDesktopPC_Setup.evtx | select -f 1; gwep -Path .\RemDesktopPC_Setup.evtx -Oldest | select -f 1

    ProviderName: Microsoft-Windows-Servicing

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  10/13/2020 11:57:14 AM           2 Information      Package KB4580325 was successfully changed to the Installed state.
  11/12/2019 4:47:11 PM            1 Information      Initiating changes for package KB4524569. Current state is Absent. Target state is Ins...

  PS C:\> gwep -LogName setup -BookEnds

    ProviderName: Microsoft-Windows-Servicing

  TimeCreated                     Id LevelDisplayName Message
  -----------                     -- ---------------- -------
  1/29/2021 9:42:12 AM             2 Information      Package KB4535680 was successfully changed to the Installed state.
  12/23/2019 1:12:08 PM            1 Information      Initiating changes for package KB4524569. Current state is Absent. Target state is Ins...



  Here we validate that we have a PSSession to a remote machine, and save that session object in a variable ($RemDesktopPCSession). We copy the "Setup.evtx" log from the remote system and place it on our local machine using the name of "RemDesktopPC_Setup.evtx".  We then call the "Get-WinEventPlus" function (via the built-in alias of "gwep") using the '-Path' parameter and specifying the logfile of "RemDesktopPC_Setup.evtx". We specify the retrieval of the first and last logs of that logfile.  For contrast, we also get the first and last logs of our local machine's "Setup" logfile using the "-LogName" parameter and the switch parameter "-Bookends".

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WinEventPlus.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-02-03 | Added the "-Bookends" and "-Oldest" Switch Parameters, Added "-Path" parameter, Created three Parameter Sets, Added examples
  Dependencies:
  Notes:
  - The base of this code was taken from the "Get-SysmonEvent" function... that function has more to it and can also be used as a good reference.
  - This was helpful in creating the correct syntax for leveraging the code over a PSSession / Invoke Command.  Specifically... we needed to use the "$using:" syntax everywhere that we were referencing a local variable, such as any argument values passed to the function itself:  https://adamtheautomator.com/invoke-command-remote/
  - This was helpful in giving the idea to use separate "Parameter Set" in order to make the '-LogName' parameter mandatory when using the '-BookEnds' switch parameter - "advanced function parameter mandatory only when switch used": https://community.idera.com/database-tools/powershell/ask_the_experts/f/learn_powershell-12/20448/advanced-function-parameter-mandatory-only-when-switch-used
  - This was helpful in explaining and giving examples for "Parameter Sets": https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.1


  .
#>
function Get-WinEventPlus {
  [CmdletBinding()]
  [Alias('gwep')]
  param (
    [Parameter(HelpMessage = 'Reference the name of the Event Log to query.  For a list of log names use the command "Get-WinEvent -ListLog *".', ParameterSetName = 'Default', Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'BookEnds', Position = 0)]
    [string[]]
    $LogName,
    [Parameter(HelpMessage = 'Specify how many days prior of logs to retrieve.', ParameterSetName = 'Default')]
    [int]
    $DaysPrior,
    [Parameter(HelpMessage = 'Specify how many hours prior of logs to retrieve.', ParameterSetName = 'Default')]
    [int]
    $HoursPrior,
    [Parameter(HelpMessage = 'Specify the Event ID(s) that you want to retrieve.', ParameterSetName = 'Default')]
    [int32[]]
    $EventId,
    [Parameter(HelpMessage = 'This Switch Parameter is used to retrieve the first and last logs for the given LogName(s).', Mandatory = $true, ParameterSetName = 'BookEnds')]
    [switch]
    $BookEnds,
    [Parameter(HelpMessage = 'This Switch Parameter is used to retrieve the oldest logs first, as opposed to the newest.')]
    [switch]
    $Oldest,
    [Parameter(HelpMessage = 'Reference the path to the .evtx log that you want to analyze.', ParameterSetName = 'PathToEvtx')]
    [string]
    $Path,
    [Parameter(HelpMessage = 'Gets the specified event logs. Enter the event log names in a comma-separated list. Wildcards are permitted. To get all the logs, enter a value of *.', Mandatory = $true, ParameterSetName = 'ListLog')]
    [string[]]
    $ListLog,
    [Parameter(HelpMessage = 'Reference the PSSession to run the command on. Using the $Session Parameter allows us to query Event Logs on remote machines over an existing PSSession', ParameterSetName = 'Default')]
    [Parameter(Mandatory = $false, ParameterSetName = 'BookEnds')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {

    # THIS FIRST CODE BLOCK IS USED WHEN A "PSSESSION" IS REFERENCED BY USING THE $Session PARAMETER
    if ($Session) {
      Invoke-Command -Session $Session -ScriptBlock {

        if ($using:BookEnds) {
        
          Get-WinEvent -LogName $using:LogName | Select-Object -First 1
          Get-WinEvent -LogName $using:LogName -Oldest | Select-Object -First 1
  
        }
        else {

          $hashtable = @{}

          # Timeframe selection
          if ($using:DaysPrior) {
            $hashtable.Add( 'StartTime', (Get-Date).AddDays(-$using:DaysPrior) )
            $hashtable.Add( 'EndTime', (Get-Date) ) 
          }
          elseif ($using:HoursPrior) {
            $hashtable.Add( 'StartTime', (Get-Date).AddHours(-$using:HoursPrior) )
            $hashtable.Add( 'EndTime', (Get-Date) ) 
          }  

          # Event ID selection
          if ($using:EventId) {
            $hashtable.Add( 'ID', $using:EventId )
          }

          # Event Log selection 
          $hashtable.Add('logname', "$using:LogName")

          # Final
          if ($using:Oldest) {
            Get-WinEvent -FilterHashtable $hashtable -Oldest
          }
          else {
            Get-WinEvent -FilterHashtable $hashtable
          }

        }
        
      }
      
    } 
    # THE CODE BLOCK BELOW IS USED BY DEFAULT WHEN A "PSSESSION" WAS *NOT* REFERENCED ABOVE BY USING THE $Session PARAMETER
    else {

      if ($ListLog) {
        Get-WinEvent -ListLog $ListLog
      }

      elseif ($BookEnds) {
        
        # Final
        Get-WinEvent -LogName $LogName | Select-Object -First 1
        Get-WinEvent -LogName $LogName -Oldest | Select-Object -First 1

      }
      elseif ($Path) {
        
        # Final
        if ($Oldest) {
          Get-WinEvent -Path $Path -Oldest
        }
        else {
          Get-WinEvent -Path $Path
        }

      }
      else {
        
        $hashtable = @{}

        # Timeframe selection
        if ($DaysPrior) {
          $hashtable.Add( 'StartTime', (Get-Date).AddDays(-$DaysPrior) )
          $hashtable.Add( 'EndTime', (Get-Date) ) 
        }
        elseif ($HoursPrior) {
          $hashtable.Add( 'StartTime', (Get-Date).AddHours(-$HoursPrior) )
          $hashtable.Add( 'EndTime', (Get-Date) ) 
        }

        # Event ID selection
        if ($EventId) {
          $hashtable.Add( 'ID', $EventId )
        }

        # Event Log selection 
        $hashtable.Add('logname', "$LogName")

        # Final
        if ($Oldest) {
          Get-WinEvent -FilterHashtable $hashtable -Oldest
        }
        else {
          Get-WinEvent -FilterHashtable $hashtable
        }
        

      }


      
    }
        

  }
  
  end {}
}