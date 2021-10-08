
<#
.SYNOPSIS
  Installs the Sysmon service/driver.  Can also -Uninstall both the 32-bit/64-bit versions. *NOTE* - In my testing, I already had Sysmon installed... when I tried to remove the 32-bit I had to reboot to finish the uninstall;  and when I tried to remove the 64-bit I had to reboot to finish the uninstall.  After the reboot and complete uninstall, I was able to install the new version of Sysmon.
.DESCRIPTION
.EXAMPLE
  PS C:\> Install-Sysmon -Uninstall32Bit

  
  Uninstalls the current Sysmon / SysmonDrv.sys.  A reboot is required to do the new installation - at least in my testing thus far.

.EXAMPLE
  PS C:\> Install-Sysmon

    System Monitor v12.02 - System activity monitor
    Copyright (C) 2014-2020 Mark Russinovich and Thomas Garnier
    Sysinternals - www.sysinternals.com

    Loading configuration file with schema version 4.22
    Sysmon schema version: 4.40
    Configuration file validated.
    Sysmon64_v12.02_2020-11-04 installed.
    SysmonDrv installed.
    Starting SysmonDrv.
    SysmonDrv started.
    Starting Sysmon64_v12.02_2020-11-04..
    Sysmon64_v12.02_2020-11-04 started.


  This is an example of using the tool either 1.) If Sysmon was never on the machine or 2.) After using  "Install-Sysmon -Uninstall" and then rebooting

.INPUTS
.OUTPUTS
.NOTES
  # UNINSTALL NOTES: I had 'sysmon.exe' (the 32-bit version) v.8 installed on my machine.  It did not have a "-u force" parameter, so I just did "-u".  Here is what I noticed... 1. First when I tried to "-u | -u force" uninstall the "sysmon.exe" v.8 with "sysmon64.exe" v.12 {this is shown below with "#& $Path -u force"}... it looked like it stopped the service and marked it for deletion - but it could not stop the "SysmonDrv.sys" System Monitor driver.  2. Then I tried simply calling the installed "sysmon.exe" using "-u"... and it seemed to maybe get a little more progress, but it couldn't stop the "SysmonDrv.sys" either.  3. After that, I did some research on why, but what finally got the "SysmonDrv.sys" stopped / removed was doing a shutdown/restart.

  # UNINSTALL NOTES UPDATE: Interesting thing happened... on the machine running Sysmon64.exe... after I went through the "uninstall" steps above and still got the feedback that the "SysmonDrv.sys" couldn't be stopped ... the next day (I still had not rebooted that machine, so therefore assumed that Sysmon64 had not been uninstalled yet) I tried querying the Sysmon service and noticed that it wasn't working.  I ran "gsv *sysmon*" and got nothing returned to me, which led me to believe that the service actually had been uninstalled.  Then, I simply ran "Install-Sysmon" again ... and it worked!!!  I am thinking that the "uninstall" had already been set in motion, but needed time to complete and the few minutes that I gave it while initially testing had not been enough.  I had exited the RDP session after my initial attempts yesterday, and when I RDP'd in today received success when invoking "Install-Sysmon".
    # OUTPUT IS BELOW
        Ω Temp> Install-Sysmon

          System Monitor v12.02 - System activity monitor
          Copyright (C) 2014-2020 Mark Russinovich and Thomas Garnier
          Sysinternals - www.sysinternals.com

          Loading configuration file with schema version 4.22
          Sysmon schema version: 4.40
          Configuration file validated.
          Sysmon64_v12.02_2020-11-04 installed.
          SysmonDrv installed.
          Starting SysmonDrv.
          SysmonDrv started.
          Starting Sysmon64_v12.02_2020-11-04..
          Sysmon64_v12.02_2020-11-04 started.
          Ω Temp>
          ¢ Temp> uptime
            
            Days              : 33



  # INSTALL SUCCESS:  After the steps above (in "# UNINSTALL NOTES:") and the reboot of the machine 32-bit Sysmon.exe, on the first try, this worked
    § Temp> Install-Sysmon

    System Monitor v12.02 - System activity monitor
    Copyright (C) 2014-2020 Mark Russinovich and Thomas Garnier
    Sysinternals - www.sysinternals.com

    Loading configuration file with schema version 4.22
    Sysmon schema version: 4.40
    Configuration file validated.
    Sysmon64_v12.02_2020-11-04 installed.
    SysmonDrv installed.
    Starting SysmonDrv.
    SysmonDrv started.
    Starting Sysmon64_v12.02_2020-11-04..
    Sysmon64_v12.02_2020-11-04 started.

#>

function Install-Sysmon {
  [CmdletBinding()]
  param (
    [Parameter()]
    [switch]
    $Uninstall32Bit,
    [Parameter()]
    [switch]
    $Uninstall64Bit,
    [Parameter(HelpMessage='This parameter is not needed for the normal "install" use of this function, since the function will look for / ask for a specific configuration by default.  Nevertheless, if a different config / updated config is desired this parameter is useful in doing so.')]
    [string]
    $ConfigUpdate,
    [Parameter(HelpMessage='This Switch Parameter is used to print out the current config.')]
    [switch]
    $PrintCurrentConfig,
    [Parameter(HelpMessage='Reference the PSSession to run the command on.')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {

    # THIS FIRST CODE BLOCK IS USED WHEN A "PSSESSION" IS REFERENCED BY USING THE $Session PARAMETER
    if ($Session) {
      Invoke-Command -Session $Session -ScriptBlock {
        if ($using:Uninstall32Bit) {      
        
          # This below didn't seem to work...
          #$NewSysmon = gci c:\windows\sysmon64*
          #& $NewSysmon -u force

          <#  THE REASON WHY ↑ DIDN'T WORK IS FOUND HERE ↓
          
            PS C:\> # At this time in another terminal... ran the following...
              PS C:\> #  Install-Sysmon -Session (Get-PSSession) -Uninstall32Bit

              PS C:\> <# Received the following output...
              >> ¿ Temp> Install-Sysmon -Session (Get-PSSession) -Uninstall32Bit
              >> ?
              >> System Monitor v12.02 - System activity monitor
              >> Copyright (C) 2014-2020 Mark Russinovich and Thomas Garnier
              >> Sysinternals - www.sysinternals.com
              >>
              >> Stopping SysmonDrv..........................................................
              >> .....
              >> SysmonDrv failed to stop.
              >> SysmonDrv removed.
              >> Removing service files.
              >> NotSpecified: (:String) [], RemoteException
              >>     + CategoryInfo          : NotSpecified: (:String) [], RemoteException
              >>     + FullyQualifiedErrorId : NativeCommandError
              >>     + PSComputerName        : rwdsecjump01
              >>
              >> #>
              <#
              PS C:\>
              PS C:\> Invoke-Command -ComputerName $Target -ScriptBlock {gsv *sysmon*}

              Status   Name               DisplayName                            PSComputerName
              ------   ----               -----------                            --------------
              Running  Sysmon             Sysmon                                 rwdsecjump01

              
              PS C:\>
              PS C:\> # Above, I tried 'uninstalling' the old sysmon with the new sysmon64.exe binary... and that didn't seem to work
              PS C:\> # Then I referenced the currently installed 32-bit sysmon.exe binary on the remote machine...
              PS C:\>
              PS C:\>
              >> ¢ Temp> Install-Sysmon -Session (Get-PSSession) -Uninstall32Bit
              >> ?
              >> System Monitor v8.00 - System activity monitor
              >> Copyright (C) 2014-2018 Mark Russinovich and Thomas Garnier
              >> Sysinternals - www.sysinternals.com
              >>
              >> Stopping Sysmon..
              >> Sysmon stopped.
              >> Sysmon removed.
              >> Stopping the service failed:
              >> The service has not been started.
              >> DeleteService failed:
              >> The specified service has been marked for deletion.
              >> Removing service files................
              >> Failed to delete CcmTemp\SysmonDrv.sys
              >> NotSpecified: (:String) [], RemoteException
              >>     + CategoryInfo          : NotSpecified: (:String) [], RemoteException
              >>     + FullyQualifiedErrorId : NativeCommandError
              >>     + PSComputerName        : rwdsecjump01
              >>
              
              #>

              <#
              # Here we see that the Sysmon service is no longer running

              PS C:\>
              PS C:\> Invoke-Command -ComputerName $Target -ScriptBlock {gsv *sysmon*}
              PS C:\>
              PS C:\>
                        
              #>
          #>

          # This worked, as shown above...
          $CcmSysmon = gci C:\Windows\CcmTemp\Sysmon.exe
          & $CcmSysmon -u

              <#  Here was the output of the successful commands above
              
                  ¢ Temp> Install-Sysmon -Session (Get-PSSession) -Uninstall32Bit
                  ﻿
                  System Monitor v8.00 - System activity monitor
                  Copyright (C) 2014-2018 Mark Russinovich and Thomas Garnier
                  Sysinternals - www.sysinternals.com

                  Stopping Sysmon..
                  Sysmon stopped.
                  Sysmon removed.
                  Stopping the service failed:
                  The service has not been started.
                  DeleteService failed:
                  The specified service has been marked for deletion.
                  Removing service files................
                  Failed to delete CcmTemp\SysmonDrv.sys
                  NotSpecified: (:String) [], RemoteException
                      + CategoryInfo          : NotSpecified: (:String) [], RemoteException
                      + FullyQualifiedErrorId : NativeCommandError
                      + PSComputerName        : rwdsecjump01
              
              #>

        }
        else {
          # This requires the new Sysmon64.exe to be on the remote machine, and the SOS config file.  See "Notes - Invoke-Command, Kansa PSDrive, queries about sysmon install on remote machine.txt" for details on doing that
          $NewSysmon = gci c:\windows\sysmon64*
          $config = gci c:\windows\sysmonconfig*

          & $NewSysmon -accepteula -i $config

              <# Here was the output of the successful commands above:
              
                ¢ Temp> Install-Sysmon -Session (Get-PSSession)

                System Monitor v12.02 - System activity monitor
                Copyright (C) 2014-2020 Mark Russinovich and Thomas Garnier
                Sysinternals - www.sysinternals.com

                Loading configuration file with schema version 4.22
                Sysmon schema version: 4.40
                Configuration file validated.
                Sysmon64_v12.02_2020-11-04 installed.
                SysmonDrv installed.
                Starting SysmonDrv.
                SysmonDrv started.
                Starting Sysmon64_v12.02_2020-11-04..
                Sysmon64_v12.02_2020-11-04 started.
                NotSpecified: (:String) [], RemoteException
                    + CategoryInfo          : NotSpecified: (:String) [], RemoteException
                    + FullyQualifiedErrorId : NativeCommandError
                    + PSComputerName        : rwdsecjump01
                                  
              #>
              


        }
      }        
    }
    # THE CODE BLOCK BELOW IS USED WHEN BY DEFAULT WHEN A "PSSESSION" WAS *NOT* REFERENCED ABOVE BY USING THE $Session PARAMETER
    else {

      $Path = (Get-ChildItem "$HOME\Programs + Other*\SysInternals\Sysmon*\Sysmon64*")[-1].FullName

      if (-not (Test-Path -Path $Path -PathType Leaf)) {
        $Path = Read-Host "The default search cannot find the latest Sysmon64*.exe, please provide the full path to the .exe"
        Write-Host "`nTrying again using the following: '$Path' `n" -ForegroundColor Green -BackgroundColor Black
      }
  
      $Config = (Get-ChildItem "$HOME\Programs + Other*\SysInternals\Sysmon*\sysmonconfig-export*")[-1].FullName
  
      if (-not (Test-Path -Path $Config -PathType Leaf)) {
        $Config = Read-Host "The default search cannot find the latest sysmonconfig-export*.xml, please provide the full path to the .xml config file"
        Write-Host "`nTrying again using the following: '$Config' `n" -ForegroundColor Green -BackgroundColor Black
      }   
      
  
      if ($Uninstall32Bit) {      
  
        # NOTES: I had 'sysmon.exe' (the 32-bit version) v.8 installed on my machine.  It did not have a "-u force" parameter, so I just did "-u".  Here is what I noticed... 1. First when I tried to "-u | -u force" uninstall the "sysmon.exe" v.8 with "sysmon64.exe" v.12 {this is shown below with "#& $Path -u force"}... it looked like it stopped the service and marked it for deletion - but it could not stop the "SysmonDrv.sys" System Monitor driver.  2. Then I tried simply calling the installed "sysmon.exe" using "-u"... and it seemed to maybe get a little more progress, but it couldn't stop the "SysmonDrv.sys" either.  3. After that, I did some research on why, but what finally got the "SysmonDrv.sys" stopped / removed was doing a shutdown/restart.
  
        $CurrentSysmon = Get-ChildItem "C:\Windows\Sysmon.exe"
        & $CurrentSysmon -u #force
        #& $Path -u force
  
      }
      elseif ($Uninstall64Bit) {
  
        & $Path -u force  # endeavoring to use the new Sysmon64.exe to uninstall the previous one.
  
        # - I tried the code below, and it didn't gain me any ground, so I am staying with ↑      
        #$CurrentSysmon = Get-ChildItem "C:\Windows\Sysmon64.exe"
        #& $CurrentSysmon -u force  # endeavoring to use the old Sysmon64.exe to uninstall itself.
  
      }
      elseif ($ConfigUpdate) {
        & $Path -c $ConfigUpdate
      }
      elseif ($PrintCurrentConfig) {
        & $Path -c
      }
      else {
        & $Path -accepteula -i $Config
      }
  
    }


  }
  
  end {}
}