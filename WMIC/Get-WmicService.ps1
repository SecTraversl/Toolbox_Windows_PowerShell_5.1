<#
.SYNOPSIS
  The "Get-WmicService" function is a WMIC command wrapper for getting a list of attributes from one or many computers.  State, StartMode, StartName (indicating the identity under which the service is run), PathName, and Description are some key aspects of the output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Service = Get-WmicService
  PS C:\> $Service | ? name -eq 'Appinfo'

  ComputerName            : LocLaptop-PC1
  DisplayName             : Application Information
  Name                    : Appinfo
  State                   : Running
  ProcessId               : 3748
  StartMode               : Manual
  ExitCode                : 0
  DelayedAutoStart        : FALSE
  StartName               : LocalSystem
  ServiceType             : Share Process
  PathName                : C:\Windows\system32\svchost.exe -k netsvcs -p
  Description             : Facilitates the running of interactive applications with additional administrative privileges.  If this service
                            is stopped, users will be unable to launch applications with the additional administrative privileges they may
                            require to perform desired user tasks.
  Started                 : TRUE
  AcceptPause             : FALSE
  AcceptStop              : TRUE
  DesktopInteract         : FALSE
  ErrorControl            : Normal
  Status                  : OK
  CheckPoint              : 0
  ServiceSpecificExitCode : 0
  TagId                   : 0
  CreationClassName       : Win32_Service
  SystemCreationClassName : Win32_ComputerSystem
  Caption                 : Application Information
  SystemName              : LocLaptop-PC1
  InstallDate             :
  WaitHint                :



  Here we run the function without additional parameters which, by default, queries the local machine.  We then filter specifically for the service with a Name property of "Appinfo".  ProcessId, PathName for the service, StartMode, StartName (indicating here that the well-known identity of "LocalSystem" owns this service), and more are displayed.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\> $Service = Get-WmicService -ComputerName $list
  PS C:\>
  PS C:\> Get-CommandRuntime
  Hours             : 0
  Minutes           : 1
  Seconds           : 0

  PS C:\> $Service | ? state -eq 'Running' | Sort-Object Name,ProcessId | ft | more

  ComputerName                   DisplayName                                      Name                                State   ProcessId StartMode
  ------------                   -----------                                      ----                                -----   --------- ---------
  LocLaptop-PC1                  OpenVPN Agent agent_ovpnconnect                  agent_ovpnconnect                   Running 4492      Auto
  LocLaptop-PC1                  Application Information                          Appinfo                             Running 3748      Manual
  RemDesktopPC.corp.Roxboard.com Application Information                          Appinfo                             Running 6080      Manual
  RemDesktopPC.corp.Roxboard.com Windows Audio Endpoint Builder                   AudioEndpointBuilder                Running 2448      Auto
  LocLaptop-PC1                  Windows Audio Endpoint Builder                   AudioEndpointBuilder                Running 3064      Auto
  LocLaptop-PC1                  Windows Audio                                    Audiosrv                            Running 3464      Auto
  RemDesktopPC.corp.Roxboard.com Windows Audio                                    Audiosrv                            Running 3596      Auto
  LocLaptop-PC1                  Base Filtering Engine                            BFE                                 Running 2540      Auto
  RemDesktopPC.corp.Roxboard.com Base Filtering Engine                            BFE                                 Running 732       Auto
  LocLaptop-PC1                  Bluetooth User Support Service_142dcc            BluetoothUserService_142dcc         Running 5732      Manual
  LocLaptop-PC1                  Background Tasks Infrastructure Service          BrokerInfrastructure                Running 1032      Auto
  RemDesktopPC.corp.Roxboard.com Background Tasks Infrastructure Service          BrokerInfrastructure                Running 1096      Auto
  LocLaptop-PC1                  Bluetooth Audio Gateway Service                  BTAGService                         Running 1524      Manual
  LocLaptop-PC1                  AVCTP service                                    BthAvctpSvc                         Running 1532      Manual
  LocLaptop-PC1                  Bluetooth Support Service                        bthserv                             Running 1596      Manual
  RemDesktopPC.corp.Roxboard.com Capability Access Manager Service                camsvc                              Running 13852     Manual
  LocLaptop-PC1                  Capability Access Manager Service                camsvc                              Running 2296      Manual
  RemDesktopPC.corp.Roxboard.com Clipboard User Service_115f923                   cbdhsvc_115f923                     Running 1500      Manual
  LocLaptop-PC1                  Clipboard User Service_142dcc                    cbdhsvc_142dcc                      Running 7880      Manual



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Service" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we selected services that have a State property value of 'Running', then sort primarily by the Name property and secondarily by the ProcessId.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicService
  Author: Travis Logue
  Version History: 1.0 | 2020-12-23 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicService {
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
      $param = "/node:`"$($Computer)`"",'service','get','/format:list'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicServiceListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicServiceListFull.Count; $i++) {
        if ($WmicServiceListFull[$i] -like "AcceptPause=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicServiceListFull[$i + $counter]
            $counter += 1
          } until ($WmicServiceListFull[$i+1 + $counter] -like "AcceptPause=*" -or $WmicServiceListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AcceptPause=' { $AcceptPause_Value = (($e -split "=",2).trim())[1] }
              '^AcceptStop=' { $AcceptStop_Value = (($e -split "=",2).trim())[1] }
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^CheckPoint=' { $CheckPoint_Value = (($e -split "=",2).trim())[1] }
              '^CreationClassName=' { $CreationClassName_Value = (($e -split "=",2).trim())[1] }
              '^DelayedAutoStart=' { $DelayedAutoStart_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DesktopInteract=' { $DesktopInteract_Value = (($e -split "=",2).trim())[1] }
              '^DisplayName=' { $DisplayName_Value = (($e -split "=",2).trim())[1] }
              '^ErrorControl=' { $ErrorControl_Value = (($e -split "=",2).trim())[1] }
              '^ExitCode=' { $ExitCode_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^PathName=' { $PathName_Value = (($e -split "=",2).trim())[1] }
              '^ProcessId=' { $ProcessId_Value = (($e -split "=",2).trim())[1] }
              '^ServiceSpecificExitCode=' { $ServiceSpecificExitCode_Value = (($e -split "=",2).trim())[1] }
              '^ServiceType=' { $ServiceType_Value = (($e -split "=",2).trim())[1] }
              '^Started=' { $Started_Value = (($e -split "=",2).trim())[1] }
              '^StartMode=' { $StartMode_Value = (($e -split "=",2).trim())[1] }
              '^StartName=' { $StartName_Value = (($e -split "=",2).trim())[1] }
              '^State=' { $State_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^SystemCreationClassName=' { $SystemCreationClassName_Value = (($e -split "=",2).trim())[1] }
              '^SystemName=' { $SystemName_Value = (($e -split "=",2).trim())[1] }
              '^TagId=' { $TagId_Value = (($e -split "=",2).trim())[1] }
              '^WaitHint=' { $WaitHint_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AcceptPause = $AcceptPause_Value
            AcceptStop = $AcceptStop_Value
            Caption = $Caption_Value
            CheckPoint = $CheckPoint_Value
            CreationClassName = $CreationClassName_Value
            DelayedAutoStart = $DelayedAutoStart_Value
            Description = $Description_Value
            DesktopInteract = $DesktopInteract_Value
            DisplayName = $DisplayName_Value
            ErrorControl = $ErrorControl_Value
            ExitCode = $ExitCode_Value
            InstallDate = $InstallDate_Value
            Name = $Name_Value
            PathName = $PathName_Value
            ProcessId = $ProcessId_Value
            ServiceSpecificExitCode = $ServiceSpecificExitCode_Value
            ServiceType = $ServiceType_Value
            Started = $Started_Value
            StartMode = $StartMode_Value
            StartName = $StartName_Value
            State = $State_Value
            Status = $Status_Value
            SystemCreationClassName = $SystemCreationClassName_Value
            SystemName = $SystemName_Value
            TagId = $TagId_Value
            WaitHint = $WaitHint_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,DisplayName,Name,State,ProcessId,StartMode,ExitCode,DelayedAutoStart,StartName,ServiceType,PathName,Description,Started,AcceptPause,AcceptStop,DesktopInteract,ErrorControl,Status,CheckPoint,ServiceSpecificExitCode,TagId,CreationClassName,SystemCreationClassName,Caption,SystemName,InstallDate,WaitHint

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}