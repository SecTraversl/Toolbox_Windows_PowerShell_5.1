<#
.SYNOPSIS
  The "Get-Autoruns" function is a wrapper for "autorunsc64.exe", running a default set of parameters for the executable and converting the output to rich objects.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Autoruns = Get-Autoruns
  PS C:\> Get-CommandRuntime

  Minutes           : 5
  Seconds           : 57
  Milliseconds      : 828

  PS C:\> $Autoruns | ? Entry | select -Last 3


  Time           : 3/20/2002 1:00 PM
  Entry Location : HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  Entry          : OneDrive
  Enabled        : enabled
  Category       : Logon
  Profile        : LocLaptop-PC1\Administrator
  Description    : Microsoft OneDrive
  Signer         : (Verified) Microsoft Corporation
  Company        : Microsoft Corporation
  Image Path     : c:\users\administrator\appdata\local\microsoft\onedrive\onedrive.exe
  Version        : 19.232.1124.8
  Launch String  : "C:\Users\Administrator\AppData\Local\Microsoft\OneDrive\OneDrive.exe" /background
  VT detection   : 0|74
  VT permalink   : https://www.virustotal.com/gui/file/5b443c117d829ae7315c2d9624917522196535acb8eb12bb399c03b714615f7a/detection
  MD5            : 2EB728F7FBE31BA47775CCFEDD034441
  SHA-1          : 6E525BB02E751331D8BE9B7EFF0F1E24DB7F3CE1
  PESHA-1        : 3B749B73A6195B528AD45B378AEEFF45F4B995C2
  PESHA-256      : 1BD789F3941D104552F0E74F2E0EB0B8B4DCC1D353438A5B3D7952FB6B603C5A
  SHA-256        : 5B443C117D829AE7315C2D9624917522196535ACB8EB12BB399C03B714615F7A
  IMP            : 7E4962AE72E9B48FAAB02CDA0C36C6CE

  Time           : 7/20/2014 6:33 PM
  Entry Location : HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
  Entry          : WAB Migrate
  Enabled        : enabled
  Category       : Logon
  Profile        : LocLaptop-PC1\Administrator
  Description    : Windows Contacts
  Signer         : (Verified)
  Company        : Microsoft Corporation
  Image Path     : c:\program files\windows mail\wab.exe
  Version        : 10.0.19041.1
  Launch String  : %ProgramFiles%\Windows Mail\wab.exe /Upgrade
  VT detection   : 0|74
  VT permalink   : https://www.virustotal.com/gui/file/02ea7b9948dfc54980fd86dc40b38575c1f401a5a466e5f9fbf9ded33eb1f6a7/detection
  MD5            : DBB30349963DBF34B6A50E6A2C3F3644
  SHA-1          : CEBF338E946E24CD28C0D45EB04B69197A3D8429
  PESHA-1        : B7C4983C8A409AF70F0559D14EBD48F3D5F6B8A8
  PESHA-256      : 01BCF8C69773C57B29FA96FA3BBCD6E49F355A153B7113D257227DE670F6DDB9
  SHA-256        : 02EA7B9948DFC54980FD86DC40B38575C1F401A5A466E5F9FBF9DED33EB1F6A7
  IMP            : EBE0CE83B3C5863ACCA11795857482FC

  Time           : 11/9/2031 7:52 AM
  Entry Location : HKCU\Software\Microsoft\Internet Explorer\UrlSearchHooks
  Entry          : Microsoft Url Search Hook
  Enabled        : enabled
  Category       : Internet Explorer
  Profile        : LocLaptop-PC1\Administrator
  Description    : Internet Browser
  Signer         : (Verified)
  Company        : Microsoft Corporation
  Image Path     : c:\windows\system32\ieframe.dll
  Version        : 11.0.19041.1081
  Launch String  : HKCR\CLSID\{CFBFAE00-17A6-11D0-99CB-00C04FD64497}
  VT detection   : 0|74
  VT permalink   : https://www.virustotal.com/gui/file/e92392f7c037bcb40e868ac25f4f2307cb2b25bd91b55b3184ba3bb697de4714/detection
  MD5            : 5C89C88BC67063771D9B3D00FADA1505
  SHA-1          : F3CBA7160AB93B088B6EA56176D19DD013365B56
  PESHA-1        : 0F21C1CB68E3F9B479CAAEA177F53E24D6338FEC
  PESHA-256      : 5A0A12C6B5800C510EFB0B302C140E164EFAA928DD0A240536A564B3F6E5DCA0
  SHA-256        : E92392F7C037BCB40E868AC25F4F2307CB2B25BD91B55B3184BA3BB697DE4714
  IMP            : C8CBD50B136BFBBD0FEE1CC620EAA7B2



  Here we run the function and store the output into the variable "$Autoruns".  The function took almost 6 minutes to complete, and we displayed the last 3 entries which had a non-empty "Entry" value.  This is the latest version of "autoruns64.exe" as of 8/4/2021 and we still see that the "Time" property is often incorrect and should not necessarily be relied upon.  Nevertheless, there is a lot of valuable information in the output including "Entry Location", "Enabled", "Signer", "Image Path", "Launch String", "VT detection", "SHA-256", and "IMP".

.EXAMPLE
  PS C:\> $Autoruns | group Company,Signer -NoElement | sort count -Descending | select -First 10 | ft -AutoSize

  Count Name
  ----- ----
    613 Microsoft Corporation, Microsoft Corporation
    328 Microsoft Corporation, (Verified) Microsoft Windows
    308 Microsoft Corporation, (Verified)
    102 ,
     98 Microsoft Corporation, (Verified) Microsoft Corporation
     32 Microsoft Corporation, (Verified) Microsoft Windows Publisher
     16 VMware, Inc., (Verified) VMware, Inc.
      9 Intel Corporation, Intel Corporation
      7 Avago Technologies, (Verified) Microsoft Windows
      5 Mellanox, (Verified) Microsoft Windows


  PS C:\> $Autoruns | group Company,Signer -NoElement | sort count -Descending | select -Last 10 | ft -AutoSize

  Count Name
  ----- ----
      1 LSI, (Verified) Microsoft Windows
      1 Insecure.Com LLC., (Verified) Insecure.Com LLC
      1 shauron, Inc., (Verified) Microsoft Windows Early Launch Anti-malware Publisher
      1 Silicon Integrated Systems subd., (Verified) Microsoft Windows
      1 Marvell Semiconductor, Inc., (Verified) Microsoft Windows
      1 LSI Corporation, Inc., (Verified) Microsoft Windows
      1 PMC-Sierra, (Verified) Microsoft Windows
      1 Intel Corporation, (Verified) Intel(R) Embedded Subsystems and IP Blocks Group
      1 Microsoft                                                                , (Verified) Microsoft Corporation
      1 NXP, (Verified) Microsoft Windows Hardware Compatibility Publisher
  


  Here we grouped the entries primarily by "Company" and secondarily by "Signer".  We then sorted by the count and selected the first 10 entries in the first example, which gives us some of the most frequently occurring Company/Signer combinations.  Then in the second example we selected the last 10 entries to see some of the least frequently occuring Company/Signer combinatons.

.EXAMPLE
  PS C:\> $Autoruns | ? {$_.signer -notlike "*verified*"} | group Company -NoElement | sort count -Descending | ft -AutoSize

  Count Name
  ----- ----
    613 Microsoft Corporation
    102
      9 Intel Corporation
      2 Intel(R) Corporation
      2 Fraunhofer Institut Integrierte Schaltungen IIS
      2 Advanced Micro Devices, Inc
      1 Radius Inc.
      1 Igor Pavlov
      1 Microsoft subd.
      1 Apple Inc.
      1 ASIX Electronics subd.
      1 Windows (R) Win 7 DDK provider

  

  Here we are filtering out all entries that have the word 'verified' in the "Signer" property.  We then group by the "Company" property and sort the count to visualize the frequency of occurrence from greatest to least.

.EXAMPLE
  PS C:\> $Autoruns | ? {$_.Entry -notlike $null -and  $_.Signer -Like $null} | measure
  Count    : 14

  PS C:\> $Autoruns | ? {$_.Entry -notlike $null -and  $_.Signer -Like $null} | select "Entry Location",Entry,Category,Profile

  Entry Location                                                            Entry                                         Category   Profile
  --------------                                                            -----                                         --------   -------
  HKLM\System\CurrentControlSet\Services                                    agent_ovpnconnect                             Services   System-wide
  HKLM\System\CurrentControlSet\Services                                    CimFS                                         Drivers    System-wide
  HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers            Adobe Type Manager                            Drivers    System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wowarmhw                                     Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _xtajit                                       Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wow64cpu                                     Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wowarmhw                                     Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _xtajit                                       Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           wow64                                         Known DLLs System-wide
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           wow64win                                      Known DLLs System-wide
  Task Scheduler                                                            \npcapwatchdog                                Tasks      System-wide
  Task Scheduler                                                            \Microsoft\Windows\HelloFace\FODCleanupTask   Tasks      System-wide
  Task Scheduler                                                            \Microsoft\Windows\NetTrace\GatherNetworkInfo Tasks      System-wide
  HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Logon Printer ReMap                                 Logon      CORP\Jannus.Fugal



  Here we filter for objects that are have a populated "Entry" property and that DO NOT have a populated "Signer" property.  We then select specific properties to display about each of these objects.

.EXAMPLE
  PS C:\> $Autoruns | ? {$_.Entry -notlike $null -and $_.'vt detection' -NotLike "*|*"} | measure
  Count    : 9

  PS C:\> $Autoruns | ? {$_.Entry -notlike $null -and $_.'vt detection' -NotLike "*|*"} | select "Entry Location",Entry,'VT detection',"Image Path"

  Entry Location                                                            Entry              VT detection Image Path
  --------------                                                            -----              ------------ ----------
  HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers            Adobe Type Manager              File not found: atmfd.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wowarmhw          Unknown      c:\windows\system32\wowarmhw.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _xtajit            Unknown      c:\windows\system32\xtajit.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wow64cpu          Unknown      c:\windows\syswow64\wow64cpu.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _wowarmhw          Unknown      c:\windows\syswow64\wowarmhw.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           _xtajit            Unknown      c:\windows\syswow64\xtajit.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           wow64              Unknown      c:\windows\syswow64\wow64.dll
  HKLM\System\CurrentControlSet\Control\Session Manager\KnownDlls           wow64win           Unknown      c:\windows\syswow64\wow64win.dll
  HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Logon Printer ReMap                   File not found: \\subd.MyDomain.com\SysVol\subd.MyDomain.com\Policies\{DC414195-DC1D-4269-B9AD-92EF07D40781}\User\Scripts\Logon\invoke.bat



  Here we filter for objects that are have a populated "Entry" property and that DO NOT have a standard "VT detection" property.  This leaves us with a short list of files to perhaps scrutinize further since the file is either not found or the file hash is 'Unknown' by Virus Total.  We then select specific properties to display about each of these objects.

.EXAMPLE
  PS C:\> $Autoruns | group 'vt detection' -NoElement | sort count -Descending

  Count Name
  ----- ----
   1245 0|74
    206 0|73
     90
     36 0|75
     22 0|72
     16 0|76
     14 1|74
      7 Unknown
      3 0|66
      3 0|71
      1 0|59
      1 2|74
      1 0|60
      1 0|67

  PS C:\> $VT_Detected = $Autoruns | ? {$_.'vt detection' -notlike $null -and $_.'vt detection' -notmatch "0\||Unknown"}

  PS C:\> $VT_Detected | select 'Image Path',MD5,Entry,'Entry Location' | sort MD5

  Image Path                                          MD5                              Entry                                                              Entry Location
  ----------                                          ---                              -----                                                              --------------
  c:\windows\system32\btwrsupportservice.exe          02123BE5D4D5CA48E93AC914EC936DC4 BcmBtRSupport                                                      HKLM\System\Curr...
  c:\users\Jannus.Fugal\appdata\local\slack\slack.exe 54BE8C215502647A0833EE1EBD9FD238 com.squirrel.slack.slack                                           HKCU\SOFTWARE\Mi...
  c:\windows\psexesvc.exe                             75B55BB34DAC9D02740B9AD6B6820360 PSEXESVC                                                           HKLM\System\Curr...
  c:\windows\system32\xblauthmanager.dll              75EBC3A65D03A7F9395B63AD77C2757B XblAuthManager                                                     HKLM\System\Curr...
  c:\windows\system32\ngctasks.dll                    7E769301930A1EE1B5A55EA374A53121 \Microsoft\Windows\CertificateServicesClient\KeyPreGenTask         Task Scheduler
  c:\windows\system32\ngctasks.dll                    7E769301930A1EE1B5A55EA374A53121 \Microsoft\Windows\CertificateServicesClient\CryptoPolicyTask      Task Scheduler
  c:\windows\system32\ngctasks.dll                    7E769301930A1EE1B5A55EA374A53121 \Microsoft\Windows\CertificateServicesClient\AikCertEnrollTask     Task Scheduler
  c:\windows\system32\workfoldersshell.dll            8569DDC60C1C90FF91F92FE60E1FDAC3 WorkFolders                                                        HKLM\Software\Cl...
  c:\windows\system32\workfoldersshell.dll            8569DDC60C1C90FF91F92FE60E1FDAC3 WorkFolders                                                        HKLM\Software\Cl...
  c:\windows\system32\workfoldersshell.dll            8569DDC60C1C90FF91F92FE60E1FDAC3 \Microsoft\Windows\Work Folders\Work Folders Logon Synchronization Task Scheduler
  c:\windows\system32\workfoldersshell.dll            8569DDC60C1C90FF91F92FE60E1FDAC3 WorkFolders                                                        HKLM\Software\Cl...
  c:\windows\system32\workfoldersshell.dll            8569DDC60C1C90FF91F92FE60E1FDAC3 \Microsoft\Windows\Work Folders\Work Folders Maintenance Work      Task Scheduler
  c:\windows\system32\ipsecsvc.dll                    B142CEA84B7894B529333184C282E0A7 PolicyAgent                                                        HKLM\System\Curr...
  c:\windows\system32\ehstorshell.dll                 D6785045028A42CA3EF85111F137DD6F EnhancedStorageShell                                               HKLM\Software\Cl...
  c:\windows\system32\ehstorshell.dll                 D6785045028A42CA3EF85111F137DD6F EnhancedStorageShell                                               HKLM\Software\Mi...


  PS C:\> $VT_Detected | sort MD5 -Unique | select 'Image Path',Company,Signer,'VT Detection'

  Image Path                                          Company                 Signer                              VT detection
  ----------                                          -------                 ------                              ------------
  c:\windows\system32\btwrsupportservice.exe          Broadcom Corporation.   (Verified) Broadcom Corporation     1|74
  c:\users\Jannus.Fugal\appdata\local\slack\slack.exe Slack Technologies Inc. (Verified) Slack Technologies, Inc. 2|74
  c:\windows\psexesvc.exe                             Sysinternals            (Verified) Microsoft Corporation    1|74
  c:\windows\system32\xblauthmanager.dll              Microsoft Corporation   Microsoft Corporation               1|74
  c:\windows\system32\ngctasks.dll                    Microsoft Corporation   (Verified)                          1|74
  c:\windows\system32\workfoldersshell.dll            Microsoft Corporation   (Verified)                          1|74
  c:\windows\system32\ipsecsvc.dll                    Microsoft Corporation   Microsoft Corporation               1|74
  c:\windows\system32\ehstorshell.dll                 Microsoft Corporation   Microsoft Corporation               1|74

  PS C:\> $VT_Detected | sort MD5 -Unique | % {& 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' -incognito $_.'vt permalink' }



  Here we first identified and filtered for Autoruns entries that have at least one "VT Detection" hit.  From there we show how there are a number of instances were the same binary is referenced, but that have a different "Entry Location" (e.g. different registry keys where the same binary is referenced).  Then we isolate only the unique binaries that have a "VT Detection" hit, and identify their Image Path, Company, and Signer information. Finally, we open the Virus Total "VT permalink" URLs with a Chrome browser tab to see the additional information that VT has for each entry.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-Autoruns.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-08-04 | The Time field contained odd entries in v13.98; downloaded v13.100, which still has odd entries
  Dependencies: Autorunsc64.exe
  Notes:
  - 2021-08-04 - I found strange "Time" entries in v13.98 of Autoruns (These strange "Time" entries also exist for v13.100), here are some references from others who saw the same thing:
      https://answers.microsoft.com/en-us/windows/forum/all/autoruns-displays-decades-old-timestamps/07a082aa-7dfd-4fbe-a2a3-f1530c379a99
      https://www.reddit.com/r/sysadmin/comments/dsmnd4/sysinternals_autoruns_returning_strange_timestamps/f6qykcy/

  - Good post with additional references about ASEPs that can exist outside of the typical Autoruns locations:  https://social.technet.microsoft.com/Forums/en-US/39a4df7d-5941-49ef-bbab-a07dd450412e/auto-start-locations-can-asep-be-elsewhere?forum=autoruns
      ASEPs Abused in the Wild: https://twitter.com/search?f=tweets&vertical=default&q=from%3A%40huntresslabs%20%23foothold%20OR%20%23footholds%20OR%20%23persistence
      Evading Autoruns - video: https://www.youtube.com/watch?v=AEmuhCwFL5I&feature=youtu.be
      Evading Autoruns - slides: https://github.com/huntresslabs/evading-autoruns/blob/master/Evading_Autoruns_Slides.pdf
      Follow Up Blog Highlighting Windows 10: https://medium.com/@KyleHanslovan/re-evading-autoruns-pocs-on-windows-10-dd810d7e8a3f
  
  .
#>
function Get-Autoruns {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the path to AutorunsC64.exe.  The default search path is the current directory.')]
    [String]
    $AutorunsPath
  )
  
  begin {}
  
  process {

    if ($AutorunsPath) {      
      if ( (Test-Path $AutorunsPath -PathType Leaf) -and ($AutorunsPath.EndsWith('autorunsc64.exe')) ) {
        $exe = $AutorunsPath
      }
      else {
        $exit = $true
      }
    }
    elseif (Test-Path '.\autorunsc64.exe') {
      $exe = '.\autorunsc64.exe'
    }
    else {
      Write-Host "No '-AutorunsPath' specified and '.\autorunsc64.exe' not found in current directory." -BackgroundColor Black -ForegroundColor Yellow
      $Answer = Read-Host "Do you want to download it from Microsoft? [y/n]"
      
      if ($Answer.ToLower().StartsWith('y')) {
        
        Invoke-WebRequest 'https://download.sysinternals.com/files/Autoruns.zip' -OutFile '.\autoruns.zip'
        Expand-Archive -Path '.\autoruns.zip' -DestinationPath '.\autoruns'
        $exe = '.\autoruns\autorunsc64.exe'
      }
      else {
        $exit = $true
      }
    }

    if (-not ($exit)) {
      
      # This was from the original code on github ~2018... it didn't work as expected so I made some modifications:  $param = '-nobanner', '/accepteula', '-a *', '-c', '-h', '-s', '-v', '-vt', '*'

      #$param = '/accepteula', '-a', '*', '-c', '-h', '-s', '-v', '-vt', '*'
      $param = '-nobanner', '/accepteula', '-a', '*', '-c', '-h', '-s', '-v', '-vt', '*'

      <# Autorunsc64.exe flags #>
      # -nobanner    Don't output the banner (breaks CSV parsing)
      # /accepteula  Automatically accept the EULA
      # -a *         Record all entries
      # -c           Output as CSV
      # -h           Show file hashes
      # -s           Verify digital signatures
      # -v           Query file hashes againt Virustotal (no uploading)
      # -vt          Accept Virustotal Terms of Service
      #  *           Scan all user profiles

      $Content = & $exe $param
      $ObjectForm = $Content | ConvertFrom-Csv
      Write-Output $ObjectForm

    }
    elseif ($exit) {
      Write-Host "Exit flag was triggered. Exiting..." -ForegroundColor Yellow -BackgroundColor Black
    } 

  }
  
  end {}
}