<#
.SYNOPSIS
  The "Get-WmicProcess" function is a WMIC command wrapper for getting a list of Processes and related information on one or many computers.  The ExecutablePath, ProcessId, ParentProcessId, HandleCount, and CommandLine are some key aspects of the output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $procs = Get-WmicProcess
  PS C:\> $procs | select -f 11 | ft

  ComputerName  Description         ExecutablePath                ProcessId ParentProcessId Handle HandleCount CommandLine                   WorkingSetSize WindowsVersion
  ------------  -----------         --------------                --------- --------------- ------ ----------- -----------                   -------------- --------------
  LocLaptop-PC1 System Idle Process                               0         0               0      0                                         8192           10.0.18363
  LocLaptop-PC1 System                                            4         0               4      6383                                      2510848        10.0.18363
  LocLaptop-PC1 Secure System                                     56        4               56     0                                         24317952       10.0.18363
  LocLaptop-PC1 Registry                                          104       4               104    0                                         48033792       10.0.18363
  LocLaptop-PC1 smss.exe                                          500       4               500    53                                        565248         10.0.18363
  LocLaptop-PC1 csrss.exe                                         732       596             732    764                                       2306048        10.0.18363
  LocLaptop-PC1 wininit.exe                                       868       596             868    162                                       3350528        10.0.18363
  LocLaptop-PC1 csrss.exe                                         880       860             880    906                                       3862528        10.0.18363
  LocLaptop-PC1 services.exe                                      944       868             944    841                                       10014720       10.0.18363
  LocLaptop-PC1 LsaIso.exe                                        968       868             968    43                                        1601536        10.0.18363
  LocLaptop-PC1 lsass.exe           C:\Windows\system32\lsass.exe 976       868             976    2172        C:\Windows\system32\lsass.exe 26906624       10.0.18363



  Here we run the function without additional parameters which, by default, queries the local machine.  The results of the function include process Description, ExecutablePath, Handles and more.  Of particular note is the "CommandLine" property which shows the full path and command line parameters used when the executable was invoked.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $procs = Get-WmicProcess -ComputerName $list
  PS C:\>
  PS C:\> Get-CommandRuntime
  Days              : 0
  Hours             : 0
  Minutes           : 0
  Seconds           : 57

  PS C:\> $procs | sort Description | select -f 16 | ft

  ComputerName                   Description                         ExecutablePath                                                           ProcessId ParentProcessId Handle HandleCount CommandLine
  ------------                   -----------                         --------------                                                           --------- --------------- ------ ----------- -----------
  RemDesktopPC.corp.Roxboard.com AdobeARM.exe                        C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe           19336     8244            19336  217         /Skip /Pro...
  LocLaptop-PC1                  AdobeARM.exe                        C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe           19336     8244            19336  217         /Skip /Pro...
  RemDesktopPC.corp.Roxboard.com agent_ovpnconnect_1594367036109.exe C:\Program Files\OpenVPN Connect\agent_ovpnconnect_1594367036109.exe     4488      944             4488   170         "C:\Progra...
  LocLaptop-PC1                  agent_ovpnconnect_1594367036109.exe C:\Program Files\OpenVPN Connect\agent_ovpnconnect_1594367036109.exe     4488      944             4488   170         "C:\Progra...
  LocLaptop-PC1                  ApplicationFrameHost.exe            C:\Windows\system32\ApplicationFrameHost.exe                             11740     572             11740  398         C:\Windows...
  RemDesktopPC.corp.Roxboard.com ApplicationFrameHost.exe            C:\Windows\system32\ApplicationFrameHost.exe                             11740     572             11740  398         C:\Windows...
  RemDesktopPC.corp.Roxboard.com AppUIMonitor.exe                                                                                             1324      6352            1324   55
  LocLaptop-PC1                  AppUIMonitor.exe                                                                                             1944      6676            1944   54
  RemDesktopPC.corp.Roxboard.com AppUIMonitor.exe                                                                                             1944      6676            1944   54
  RemDesktopPC.corp.Roxboard.com armsvc.exe                          C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\armsvc.exe             4480      944             4480   323         "C:\Progra...
  LocLaptop-PC1                  armsvc.exe                          C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\armsvc.exe             4480      944             4480   323         "C:\Progra...
  LocLaptop-PC1                  audiodg.exe                         C:\Windows\system32\AUDIODG.EXE                                          7412      3260            7412   445         C:\Windows...
  RemDesktopPC.corp.Roxboard.com audiodg.exe                         C:\Windows\system32\AUDIODG.EXE                                          7412      3260            7412   445         C:\Windows...
  RemDesktopPC.corp.Roxboard.com brave.exe                           C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe 20232     16080           20232  356         "C:\Progra...
  RemDesktopPC.corp.Roxboard.com brave.exe                           C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe 21584     16080           21584  412         "C:\Progra...
  RemDesktopPC.corp.Roxboard.com brave.exe                           C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe 2708      16080           2708   247         "C:\Progra...
  


  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer computers in the variable "$procs", sort the output based on the "Description" property, and use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicProcess
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicProcess {
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
      $param = "/node:`"$($Computer)`"",'process','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicProcessListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicProcessListFull.Count; $i++) {
        if ($WmicProcessListFull[$i] -like "CommandLine=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicProcessListFull[$i + $counter]
            $counter += 1
          } until ($WmicProcessListFull[$i+1 + $counter] -like "CommandLine=*" -or $WmicProcessListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^CommandLine=' { $CommandLine_Value = (($e -split "=",2).trim())[1] }
              '^CSName=' { $CSName_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^ExecutablePath=' { $ExecutablePath_Value = (($e -split "=",2).trim())[1] }
              '^ExecutionState=' { $ExecutionState_Value = (($e -split "=",2).trim())[1] }
              '^Handle=' { $Handle_Value = (($e -split "=",2).trim())[1] }
              '^HandleCount=' { $HandleCount_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^KernelModeTime=' { $KernelModeTime_Value = (($e -split "=",2).trim())[1] }
              '^MaximumWorkingSetSize=' { $MaximumWorkingSetSize_Value = (($e -split "=",2).trim())[1] }
              '^MinimumWorkingSetSize=' { $MinimumWorkingSetSize_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^OSName=' { $OSName_Value = (($e -split "=",2).trim())[1] }
              '^OtherOperationCount=' { $OtherOperationCount_Value = (($e -split "=",2).trim())[1] }
              '^OtherTransferCount=' { $OtherTransferCount_Value = (($e -split "=",2).trim())[1] }
              '^PageFaults=' { $PageFaults_Value = (($e -split "=",2).trim())[1] }
              '^PageFileUsage=' { $PageFileUsage_Value = (($e -split "=",2).trim())[1] }
              '^ParentProcessId=' { $ParentProcessId_Value = (($e -split "=",2).trim())[1] }
              '^PeakPageFileUsage=' { $PeakPageFileUsage_Value = (($e -split "=",2).trim())[1] }
              '^PeakVirtualSize=' { $PeakVirtualSize_Value = (($e -split "=",2).trim())[1] }
              '^PeakWorkingSetSize=' { $PeakWorkingSetSize_Value = (($e -split "=",2).trim())[1] }
              '^Priority=' { $Priority_Value = (($e -split "=",2).trim())[1] }
              '^PrivatePageCount=' { $PrivatePageCount_Value = (($e -split "=",2).trim())[1] }
              '^ProcessId=' { $ProcessId_Value = (($e -split "=",2).trim())[1] }
              '^QuotaNonPagedPoolUsage=' { $QuotaNonPagedPoolUsage_Value = (($e -split "=",2).trim())[1] }
              '^QuotaPagedPoolUsage=' { $QuotaPagedPoolUsage_Value = (($e -split "=",2).trim())[1] }
              '^QuotaPeakNonPagedPoolUsage=' { $QuotaPeakNonPagedPoolUsage_Value = (($e -split "=",2).trim())[1] }
              '^QuotaPeakPagedPoolUsage=' { $QuotaPeakPagedPoolUsage_Value = (($e -split "=",2).trim())[1] }
              '^ReadOperationCount=' { $ReadOperationCount_Value = (($e -split "=",2).trim())[1] }
              '^ReadTransferCount=' { $ReadTransferCount_Value = (($e -split "=",2).trim())[1] }
              '^SessionId=' { $SessionId_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^TerminationDate=' { $TerminationDate_Value = (($e -split "=",2).trim())[1] }
              '^ThreadCount=' { $ThreadCount_Value = (($e -split "=",2).trim())[1] }
              '^UserModeTime=' { $UserModeTime_Value = (($e -split "=",2).trim())[1] }
              '^VirtualSize=' { $VirtualSize_Value = (($e -split "=",2).trim())[1] }
              '^WindowsVersion=' { $WindowsVersion_Value = (($e -split "=",2).trim())[1] }
              '^WorkingSetSize=' { $WorkingSetSize_Value = (($e -split "=",2).trim())[1] }
              '^WriteOperationCount=' { $WriteOperationCount_Value = (($e -split "=",2).trim())[1] }
              '^WriteTransferCount=' { $WriteTransferCount_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            CommandLine = $CommandLine_Value
            CSName = $CSName_Value
            Description = $Description_Value
            ExecutablePath = $ExecutablePath_Value
            ExecutionState = $ExecutionState_Value
            Handle = $Handle_Value
            HandleCount = $HandleCount_Value
            InstallDate = $InstallDate_Value
            KernelModeTime = $KernelModeTime_Value
            MaximumWorkingSetSize = $MaximumWorkingSetSize_Value
            MinimumWorkingSetSize = $MinimumWorkingSetSize_Value
            Name = $Name_Value
            OSName = $OSName_Value
            OtherOperationCount = $OtherOperationCount_Value
            OtherTransferCount = $OtherTransferCount_Value
            PageFaults = $PageFaults_Value
            PageFileUsage = $PageFileUsage_Value
            ParentProcessId = $ParentProcessId_Value
            PeakPageFileUsage = $PeakPageFileUsage_Value
            PeakVirtualSize = $PeakVirtualSize_Value
            PeakWorkingSetSize = $PeakWorkingSetSize_Value
            Priority = $Priority_Value
            PrivatePageCount = $PrivatePageCount_Value
            ProcessId = $ProcessId_Value
            QuotaNonPagedPoolUsage = $QuotaNonPagedPoolUsage_Value
            QuotaPagedPoolUsage = $QuotaPagedPoolUsage_Value
            QuotaPeakNonPagedPoolUsage = $QuotaPeakNonPagedPoolUsage_Value
            QuotaPeakPagedPoolUsage = $QuotaPeakPagedPoolUsage_Value
            ReadOperationCount = $ReadOperationCount_Value
            ReadTransferCount = $ReadTransferCount_Value
            SessionId = $SessionId_Value
            Status = $Status_Value
            TerminationDate = $TerminationDate_Value
            ThreadCount = $ThreadCount_Value
            UserModeTime = $UserModeTime_Value
            VirtualSize = $VirtualSize_Value
            WindowsVersion = $WindowsVersion_Value
            WorkingSetSize = $WorkingSetSize_Value
            WriteOperationCount = $WriteOperationCount_Value
            WriteTransferCount = $WriteTransferCount_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,ExecutablePath,ProcessId,ParentProcessId,Handle,HandleCount,CommandLine,WorkingSetSize,WindowsVersion,ThreadCount,UserModeTime,KernelModeTime,WriteOperationCount,ReadOperationCount,OtherOperationCount,Priority,PrivatePageCount,SessionId,PageFileUsage,PageFaults,WriteTransferCount,ReadTransferCount,OtherTransferCount,PeakWorkingSetSize,PeakPageFileUsage,PeakVirtualSize,CSName,MaximumWorkingSetSize,MinimumWorkingSetSize,OSName,Name,QuotaNonPagedPoolUsage,QuotaPagedPoolUsage,QuotaPeakNonPagedPoolUsage,QuotaPeakPagedPoolUsage,TerminationDate,VirtualSize,Status,ExecutionState,InstallDate

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}