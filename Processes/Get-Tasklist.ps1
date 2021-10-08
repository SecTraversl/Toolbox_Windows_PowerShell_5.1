<#
.SYNOPSIS
  This is a wrapper for tasklist.exe which includes a Validate Set Attribute including options such as: "Verbose" (the Default), "Services", "DLLs", and "Apps".  
.DESCRIPTION
.EXAMPLE
  PS C:\> $tasks = Get-Tasklist
  PS C:\> $tasks | select -f 10 | ft

  Image Name          PID Session Name Session# Mem Usage Status  User Name           CPU Time Window Title
  ----------          --- ------------ -------- --------- ------  ---------           -------- ------------
  System Idle Process 0   Services     0        8 K       Unknown NT AUTHORITY\SYSTEM 66:30:05 N/A
  System              4   Services     0        3,336 K   Unknown N/A                 0:03:36  N/A
  Secure System       56  Services     0        23,748 K  Unknown NT AUTHORITY\SYSTEM 0:00:00  N/A
  Registry            104 Services     0        86,912 K  Unknown NT AUTHORITY\SYSTEM 0:00:02  N/A
  smss.exe            500 Services     0        1,068 K   Unknown NT AUTHORITY\SYSTEM 0:00:00  N/A
  csrss.exe           732 Services     0        4,216 K   Unknown NT AUTHORITY\SYSTEM 0:00:02  N/A
  wininit.exe         868 Services     0        5,676 K   Unknown NT AUTHORITY\SYSTEM 0:00:00  N/A
  csrss.exe           880 Console      1        4,840 K   Running NT AUTHORITY\SYSTEM 0:00:14  N/A
  services.exe        944 Services     0        13,600 K  Unknown NT AUTHORITY\SYSTEM 0:08:36  N/A
  LsaIso.exe          968 Services     0        2,796 K   Unknown NT AUTHORITY\SYSTEM 0:00:00  N/A



  Here we run the function with its defaults ("-Parameter Verbose" is the default).  The function returns the processes on the local computer, PID, User Name that is running the process, and more.

.EXAMPLE
  PS C:\> $Services = Get-Tasklist Services
  PS C:\> $Services | select -f 10 | ft

  Image Name  PID  Services
  ----------  ---  --------
  lsass.exe   976  KeyIso,Netlogon,SamSs,VaultSvc
  svchost.exe 600  PlugPlay
  svchost.exe 572  BrokerInfrastructure,DcomLaunch,Power,SystemEventsBroker
  svchost.exe 1092 RpcEptMapper,RpcSs
  svchost.exe 1140 LSM
  svchost.exe 1384 HvHost
  svchost.exe 1460 nsi
  svchost.exe 1468 W32Time
  svchost.exe 1508 BTAGService
  svchost.exe 1516 BthAvctpSvc



  Here we run the function by specifying "-Parameter Services".  The output shown are all processes related to Services on the local machine.

.EXAMPLE
  PS C:\> $dlls = Get-Tasklist DLLs
  PS C:\> $dlls | select -f 10 | ft

  Image Name      PID  Modules
  ----------      ---  -------
  lsass.exe       976  ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,RPCRT4.dll,lsasrv.dll,msvcrt.dll,WS2_32.dll,SspiCli.dll,sechost.dll,WLD...
  svchost.exe     600  ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,sechost.dll,RPCRT4.dll,ucrtbase.dll,umpnpmgr.dll,msvcrt.dll,WLDP.DLL,co...
  svchost.exe     572  ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,sechost.dll,RPCRT4.dll,ucrtbase.dll,umpo.dll,UMPDC.dll,WLDP.DLL,msvcrt....
  fontdrvhost.exe 1028 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,msvcp_win.dll,ucrtbase.dll,win32u.dll
  svchost.exe     1092 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,sechost.dll,RPCRT4.dll,ucrtbase.dll,rpcepmap.dll,WLDP.DLL,msvcrt.dll,co...
  svchost.exe     1140 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,sechost.dll,RPCRT4.dll,ucrtbase.dll,lsm.dll,msvcrt.dll,combase.dll,bcry...
  winlogon.exe    1204 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,msvcrt.dll,sechost.dll,RPCRT4.dll,combase.dll,ucrtbase.dll,bcryptPrimit...
  fontdrvhost.exe 1272 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,msvcp_win.dll,ucrtbase.dll,win32u.dll
  dwm.exe         1352 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,apphelp.dll,ucrtbase.dll,advapi32.dll,msvcrt.dll,sechost.dll,RPCRT4.dll...
  svchost.exe     1384 ntdll.dll,KERNEL32.DLL,KERNELBASE.dll,sechost.dll,RPCRT4.dll,ucrtbase.dll,combase.dll,bcryptPrimitives.dll,ke...



  Here we run the function by specifying "-Parameter DLLs".  The output shown are all processes that have DLLs loaded on the local machine.

.EXAMPLE
  PS C:\> New-RemoteSession -ComputerName RemDesktopPC
  PS C:\> $RemoteMachine_Services = Get-Tasklist -Session (Get-PSSession) -Parameter Services
  PS C:\> $RemoteMachine_Services | select -f 10 | ft

  Image Name  PID  Services                                                 PSComputerName RunspaceId
  ----------  ---  --------                                                 -------------- ----------
  lsass.exe   996  KeyIso,Netlogon,SamSs,VaultSvc                           RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1040 PlugPlay                                                 RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1072 BrokerInfrastructure,DcomLaunch,Power,SystemEventsBroker RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1232 RpcEptMapper,RpcSs                                       RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1288 LSM                                                      RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1432 TermService                                              RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1456 nsi                                                      RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1452 lmhosts                                                  RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1468 W32Time                                                  RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1
  svchost.exe 1496 HvHost                                                   RemDesktopPC   dd05f825-e60f-4547-b2fe-61c6c0ed86f1



  Here we are creating a new PSSession, then referencing that existing session and returning the processes that relate to services on that remote computer.  

.EXAMPLE
  PS C:\> $apps = Get-Tasklist Apps
  PS C:\> $apps | select -f 10 | ft -AutoSize

  Image Name                                               PID   Session Name Session# Mem Usage Status    User Name         CPU Time Window Title                Package
                                                                                                                                                                  Name
  ----------                                               ---   ------------ -------- --------- ------    ---------         -------- ------------                -----------
  StartMenuExperienceHost.exe (App)                        8288  Console      1        111,092 K Running   CORP\mark.johnson 0:00:08  Start                       Microsof...
  RuntimeBroker.exe (runtimebroker07f4358a809ac99a64a67c1) 8428  Console      1        46,312 K  Unknown   CORP\mark.johnson 0:00:02  N/A                         Microsof...
  SearchUI.exe (CortanaUI)                                 8552  Console      1        201,984 K Suspended CORP\mark.johnson 0:00:25  Cortana                     Microsof...
  RuntimeBroker.exe (runtimebroker07f4358a809ac99a64a67c1) 8844  Console      1        93,948 K  Running   CORP\mark.johnson 0:00:18  N/A                         Microsof...
  ShellExperienceHost.exe (App)                            7656  Console      1        123,484 K Running   CORP\mark.johnson 0:00:03  New notification            Microsof...
  RuntimeBroker.exe (runtimebroker07f4358a809ac99a64a67c1) 2212  Console      1        48,628 K  Running   CORP\mark.johnson 0:00:00  OLEChannelWnd               Microsof...
  LockApp.exe (WindowsDefaultLockScreen)                   10124 Console      1        103,176 K Suspended CORP\mark.johnson 0:00:18  Windows Default Lock Screen Microsof...
  RuntimeBroker.exe (runtimebroker07f4358a809ac99a64a67c1) 8664  Console      1        54,344 K  Running   CORP\mark.johnson 0:00:04  N/A                         Microsof...
  YourPhone.exe (App)                                      2120  Console      1        124,264 K Suspended CORP\mark.johnson 0:00:00  N/A                         Microsof...
  RuntimeBroker.exe (runtimebroker07f4358a809ac99a64a67c1) 3400  Console      1        19,384 K  Unknown   CORP\mark.johnson 0:00:00  N/A                         Microsof...



  Here we are returning processes that are specifically Windows Apps. 

.INPUTS
.OUTPUTS
.NOTES
  General notes
#>
function Get-Tasklist {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='This "-Parameter" contains a ValidateSet Attribute; to scroll through options press <tab>. DEFAULT option is "Verbose", other options are "Services","DLLs", and "Apps".')]
    [ValidateSet("Verbose","Services","DLLs","Apps")]
    [string]
    $Parameter = "Verbose",
    [Parameter(HelpMessage='Reference the PSSession to run the command on.')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {
    
    switch ($Parameter) {
      "Verbose" { 
        function CodeToRun {
          param ()
          $Command = tasklist.exe /v /FO:CSV
          $ResultsAsObjects = $Command | ? {$_} | ConvertFrom-Csv
          Write-Output $ResultsAsObjects 
        }
        $MyFunction = ${function:CodeToRun}
      }
      "Services" { 
        function CodeToRun {
          param ()
          $Command = tasklist.exe /SVC /FO:CSV
          $ResultsAsObjects = $Command | ? {$_} | ConvertFrom-Csv 
          $ResultsAsObjects = $ResultsAsObjects | ? {$_.Services -notlike "N/A"}
          Write-Output $ResultsAsObjects 
        }
        $MyFunction = ${function:CodeToRun}
      }
      "DLLs" { 
        function CodeToRun {
          param ()
          $Command = tasklist.exe /M /FO:CSV 
          $ResultsAsObjects = $Command | ? {$_} | ConvertFrom-Csv
          $ResultsAsObjects = $ResultsAsObjects | ? {$_.Modules -notlike "N/A"}
          Write-Output $ResultsAsObjects 
        }
        $MyFunction = ${function:CodeToRun}
      }
      "Apps" {
        function CodeToRun {
          param ()
          $Command = tasklist.exe /APPS /V /FO:CSV 
          $ResultsAsObjects = $Command | ? {$_} | ConvertFrom-Csv
          Write-Output $ResultsAsObjects 
        }
        $MyFunction = ${function:CodeToRun}
      }
    }

    if ($Session) {
      Invoke-Command -Session $Session -ScriptBlock ${function:CodeToRun}
    }
    else {
      & $MyFunction
    }

  }
  
  end {}
}