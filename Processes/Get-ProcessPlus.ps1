<#
.SYNOPSIS
  The "Get-ProcessPlus" function pulls together multiple useful attributes of running processes in a single output.  Process name and ID, Parent Process name and ID, creation date of a process, the Owner of the process, and the command line used to invoke the process are key aspects of the output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $procs = Get-ProcessPlus
  PS C:\> $procs | select -f 15 | ft

  ComputerName  ProcessName          PID ProcessOwner                 ParentName          PPID CreationDate          Path                             CommandLine
  ------------  -----------          --- ------------                 ----------          ---- ------------          ----                             -----------
  LocLaptop-PC1 System Idle Process    0                              System Idle Process    0 12/5/2020 4:01:00 PM
  LocLaptop-PC1 System                 4                              System Idle Process    0 12/5/2020 4:01:00 PM
  LocLaptop-PC1 Secure System         56 NT AUTHORITY\SYSTEM          System                 4 12/5/2020 4:00:57 PM
  LocLaptop-PC1 Registry             104 NT AUTHORITY\SYSTEM          System                 4 12/5/2020 4:00:57 PM
  LocLaptop-PC1 smss.exe             500 NT AUTHORITY\SYSTEM          System                 4 12/5/2020 4:01:00 PM
  LocLaptop-PC1 csrss.exe            732 NT AUTHORITY\SYSTEM                               596 12/5/2020 4:01:08 PM
  LocLaptop-PC1 wininit.exe          868 NT AUTHORITY\SYSTEM                               596 12/5/2020 4:01:09 PM
  LocLaptop-PC1 csrss.exe            880 NT AUTHORITY\SYSTEM                               860 12/5/2020 4:01:09 PM
  LocLaptop-PC1 services.exe         944 NT AUTHORITY\SYSTEM          wininit.exe          868 12/5/2020 4:01:09 PM
  LocLaptop-PC1 LsaIso.exe           968 NT AUTHORITY\SYSTEM          wininit.exe          868 12/5/2020 4:01:09 PM
  LocLaptop-PC1 lsass.exe            976 NT AUTHORITY\SYSTEM          wininit.exe          868 12/5/2020 4:01:09 PM C:\Windows\system32\lsass.exe       C:\Windows...
  LocLaptop-PC1 svchost.exe          600 NT AUTHORITY\SYSTEM          services.exe         944 12/5/2020 4:01:09 PM C:\Windows\system32\svchost.exe     C:\Windows...
  LocLaptop-PC1 svchost.exe          572 NT AUTHORITY\SYSTEM          services.exe         944 12/5/2020 4:01:09 PM C:\Windows\system32\svchost.exe     C:\Windows...
  LocLaptop-PC1 fontdrvhost.exe     1028 Font Driver Host\UMFD-0      wininit.exe          868 12/5/2020 4:01:09 PM C:\Windows\system32\fontdrvhost.exe "fontdrvho...
  LocLaptop-PC1 svchost.exe         1092 NT AUTHORITY\NETWORK SERVICE services.exe         944 12/5/2020 4:01:09 PM C:\Windows\system32\svchost.exe     C:\Windows...



  Here the function is run without additional parameters.  The output consists of the processes on the local machine along with related information.

.EXAMPLE
  PS C:\> PS C:\> $remote_procs = Get-ProcessPlus -ComputerName RemDesktopPC

  Now running...:  'New-CimSession -ComputerName RemDesktopPC'

  Now running...:  'Remove-CimSession' to tear down the created CimSession

  PS C:\> Get-CommandRuntime
  Seconds           : 32

  PS C:\> $remote_procs | select -f 15 | ft

  ComputerName ProcessName          PID ProcessOwner              ParentName          PPID CreationDate          Path                             CommandLine
  ------------ -----------          --- ------------              ----------          ---- ------------          ----                             -----------
  {RemDesktopPC} System Idle Process    0                         System Idle Process    0 12/7/2020 1:35:15 PM
  {RemDesktopPC} System                 4                         System Idle Process    0 12/7/2020 1:35:15 PM
  {RemDesktopPC} Secure System         72 NT AUTHORITY\SYSTEM     System                 4 12/7/2020 1:35:13 PM
  {RemDesktopPC} Registry             124 NT AUTHORITY\SYSTEM     System                 4 12/7/2020 1:35:13 PM
  {RemDesktopPC} smss.exe             560 NT AUTHORITY\SYSTEM     System                 4 12/7/2020 1:35:15 PM
  {RemDesktopPC} csrss.exe            708 NT AUTHORITY\SYSTEM                          684 12/7/2020 1:35:22 PM
  {RemDesktopPC} wininit.exe          844 NT AUTHORITY\SYSTEM                          684 12/7/2020 1:35:24 PM
  {RemDesktopPC} csrss.exe            852 NT AUTHORITY\SYSTEM                          836 12/7/2020 1:35:24 PM
  {RemDesktopPC} services.exe         916 NT AUTHORITY\SYSTEM     wininit.exe          844 12/7/2020 1:35:24 PM
  {RemDesktopPC} winlogon.exe         952 NT AUTHORITY\SYSTEM                          836 12/7/2020 1:35:24 PM C:\WINDOWS\system32\winlogon.exe    winlogon.exe
  {RemDesktopPC} LsaIso.exe           976 NT AUTHORITY\SYSTEM     wininit.exe          844 12/7/2020 1:35:25 PM C:\WINDOWS\system32\lsaiso.exe      \??\C:\WINDOWS\system32\lsaiso.exe
  {RemDesktopPC} lsass.exe           1012 NT AUTHORITY\SYSTEM     wininit.exe          844 12/7/2020 1:35:25 PM C:\WINDOWS\system32\lsass.exe       C:\WINDOWS\system32\lsass.exe
  {RemDesktopPC} svchost.exe         1064 NT AUTHORITY\SYSTEM     services.exe         916 12/7/2020 1:35:25 PM C:\WINDOWS\system32\svchost.exe     C:\WINDOWS\system32\svchost.exe -k DcomLaun...
  {RemDesktopPC} svchost.exe         1096 NT AUTHORITY\SYSTEM     services.exe         916 12/7/2020 1:35:25 PM C:\WINDOWS\system32\svchost.exe     C:\WINDOWS\system32\svchost.exe -k DcomLaun...
  {RemDesktopPC} fontdrvhost.exe     1160 Font Driver Host\UMFD-1 winlogon.exe         952 12/7/2020 1:35:25 PM C:\WINDOWS\system32\fontdrvhost.exe "fontdrvhost.exe"



  Here we are specifying the "-ComputerName" of a remote machine in order to get the running processes and related information of those processes on that machine. The "-ComputerName" parameter is configured to automatically create a New-CimSession to the specified computer and then tear that CimSession down once complete (this method of interacting with a remote host via a CimSession was x5 faster than simply using the native "Get-CimInstance -ComputerName" parameter).


.EXAMPLE
  PS C:\> $cred = New-PSCredential -Username a-mark.johnson

  The '-Username' supplied did not specify the associated Domain, so the default of 'corp' has been specified as the Domain.
  If you want to specify a Domain, rerun this function with the '-Domain' parameter.

  If the account is a local user account, rerun this function with the '-LocalAccount' parameter (and if the Local Account is on a remote machine, also use '-LocalAcc
  ountHostname').

  Since some applications will not work properly without specifying the Domain, the -Username value has been updated to:  corp\a-mark.johnson

  Please enter in the password: ******************************
  PS C:\>
  PS C:\> $elevated_session = New-CimSession -Credential $cred -ComputerName RemJumpbox01
  PS C:\>
  PS C:\> $procs = Get-ProcessPlus -CimSession $elevated_session
  PS C:\>
  PS C:\> Get-CommandRuntime
  Seconds           : 20

  PS C:\> $procs | select -f 15 | ft

  ComputerName ProcessName          PID ProcessOwner                 ParentName          PPID CreationDate          Path                             CommandLine
  ------------ -----------          --- ------------                 ----------          ---- ------------          ----                             -----------
  RemJumpbox01 System Idle Process    0                              System Idle Process    0 10/21/2020 8:28:09 AM
  RemJumpbox01 System                 4                              System Idle Process    0 10/21/2020 8:28:09 AM
  RemJumpbox01 smss.exe             380 NT AUTHORITY\SYSTEM          System                 4 10/21/2020 8:28:09 AM
  RemJumpbox01 csrss.exe            464 NT AUTHORITY\SYSTEM                               456 10/21/2020 8:28:10 AM
  RemJumpbox01 wininit.exe          532 NT AUTHORITY\SYSTEM                               456 10/21/2020 8:28:11 AM
  RemJumpbox01 csrss.exe            540 NT AUTHORITY\SYSTEM                               524 10/21/2020 8:28:11 AM
  RemJumpbox01 winlogon.exe         608 NT AUTHORITY\SYSTEM                               524 10/21/2020 8:28:11 AM C:\Windows\system32\winlogon.exe winlogon.exe
  RemJumpbox01 services.exe         660 NT AUTHORITY\SYSTEM          wininit.exe          532 10/21/2020 8:28:12 AM
  RemJumpbox01 lsass.exe            668 NT AUTHORITY\SYSTEM          wininit.exe          532 10/21/2020 8:28:12 AM C:\Windows\system32\lsass.exe    C:\Windows\sy...
  RemJumpbox01 svchost.exe          756 NT AUTHORITY\SYSTEM          services.exe         660 10/21/2020 8:28:13 AM C:\Windows\system32\svchost.exe  C:\Windows\sy...
  RemJumpbox01 svchost.exe          812 NT AUTHORITY\NETWORK SERVICE services.exe         660 10/21/2020 8:28:13 AM C:\Windows\system32\svchost.exe  C:\Windows\sy...
  RemJumpbox01 LogonUI.exe          912 NT AUTHORITY\SYSTEM          winlogon.exe         608 10/21/2020 8:28:13 AM C:\Windows\system32\LogonUI.exe  "LogonUI.exe"...
  RemJumpbox01 svchost.exe          940 NT AUTHORITY\NETWORK SERVICE services.exe         660 10/21/2020 8:28:13 AM C:\Windows\System32\svchost.exe  C:\Windows\Sy...
  RemJumpbox01 dwm.exe              972 Window Manager\DWM-1         winlogon.exe         608 10/21/2020 8:28:13 AM C:\Windows\system32\dwm.exe      "dwm.exe"
  RemJumpbox01 svchost.exe         1016 NT AUTHORITY\SYSTEM          services.exe         660 10/21/2020 8:28:13 AM C:\Windows\System32\svchost.exe  C:\Windows\Sy...



  Here we are creating a PSCredential using an elevated account, then using that PSCredential to create a New-CimSession, then referencing that CimSession with the "Get-ProcessPlus" function.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ProcessPlus
  Author: Travis Logue
  Version History: 1.2 | 2021-03-29 | Added 'gpp' function alias
  Dependencies:
  Notes:


  .
#>
function Get-ProcessPlus {
  [CmdletBinding()]
  [Alias('gpp')]
  param (
    [Parameter(HelpMessage = 'Specifies computer on which you want to run the CIM operation. Multiple operations are being performed on the same computer; consequently using this parameter will automatically create a CIM session since it gives better performance.')]
    [string[]]
    $ComputerName,
    [Parameter(HelpMessage = 'Specifies the CIM session to use for this cmdlet. Enter a variable that contains the CIM session or a command that creates or gets the CIM session, such as the New-CimSession or Get-CimSession cmdlets. For more information, see about_CimSessions.')]
    [CimSession[]]
    $CimSession      
  )
  
  begin {}
  
  process {    

    if ($ComputerName) {
      Write-Host "`nNow running...:  'New-CimSession -ComputerName $ComputerName'`n" -BackgroundColor Black -ForegroundColor Yellow
      # In my testing it is x5 faster to just create a New-CimSession than to try to run this function with the native "-ComputerName" parameter built into Get-CimInstance
      $Session = New-CimSession -ComputerName $ComputerName
      $procs = gcim -ClassName win32_Process -CimSession $Session
      $HostName = $ComputerName
    }
    elseif ($CimSession) {
      $procs = gcim -ClassName win32_Process -CimSession $CimSession
      $HostName = $CimSession.ComputerName
    }
    else {
      $procs = gcim -ClassName win32_Process
      $HostName = HOSTNAME.EXE
    }

    
    foreach ($proc in $procs) {

      try {
        $GetOwner = $proc | Invoke-CimMethod -MethodName GetOwner
      }
      catch [Microsoft.Management.Infrastructure.CimException] {
        # The comments below act as documentation.  This catch block is here to stop the "Owner not found" error from appearing when this function is run.  It is normal for some system processes to not have a parent process or owner, and I didn't want to see errors related to those situations. What I discovered was that simply having this catch block here with "catch [Microsoft.Management.Infrastructure.CimException]" was enough for the errors to stop being displayed to Standard Output in the terminal.

        #if ($PSItem.Exception.Message -like "*No instance found with given property values.*") {
        #  Write-Host "Ignoring the Error for 'Owner not found'" -BackgroundColor Black -ForegroundColor Yellow
        #}
      }
      catch [Microsoft.Management.Infrastructure.CimCmdlets.InvokeCimMethodCommand] {
        # Also, though I did have success with the Catch above... I also found this $Error[0] to be occurring...
      }      

      $joiner_FindingParentProcessName = $procs | Where-Object { $_.ProcessID -eq $proc.ParentProcessID }
      $prop = [ordered]@{
        ComputerName = $HostName
        ProcessName  = $proc.ProcessName
        PID          = $proc.ProcessID
        ProcessOwner = if ($GetOwner.User) { "$($GetOwner.Domain)\$($GetOwner.User)" } else { $null }
        ParentName   = $joiner_FindingParentProcessName.ProcessName
        PPID         = $proc.ParentProcessID
        CreationDate = $proc.CreationDate
        Path         = $proc.Path
        CommandLine  = $proc.CommandLine
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }  

    if ($ComputerName) {
      Write-Host "`nNow running...:  'Remove-CimSession' to tear down the created CimSession`n" -BackgroundColor Black -ForegroundColor Yellow
      # If we didn't do this the Session created by this function would continue to exist
      Remove-CimSession $Session
    }

  }
  
  end {}

}