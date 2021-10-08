<#
.SYNOPSIS
  The "Get-WmicComputerSystem" function is a WMIC command wrapper for getting a list of attributes from one or many computers.  Processor information, total memory, domain information, time zone information (expressed in minutes of deviation from UTC), and system bit architecture are some key aspects of the output. Also, the "UserName" property indicates who is currently logged in at the console of the machine.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Computer = Get-WmicComputerSystem
  PS C:\> $Computer


  ComputerName                : LocLaptop-PC1
  Manufacturer                : Microsoft Corporation
  SystemFamily                : Surface
  Model                       : Surface Book
  SystemType                  : x64-based PC
  PrimaryOwnerName            : admin
  UserName                    : CORP\mark.johnson
  PartOfDomain                : TRUE
  DNSHostName                 : LocLaptop-PC1
  Domain                      : corp.Roxboard.com
  SystemSKUNumber             : Surface_Book
  HypervisorPresent           : TRUE
  NumberOfProcessors          : 1
  NumberOfLogicalProcessors   : 4
  TotalPhysicalMemoryGB       : 7.93
  CurrentTimeZone             : -480
  DaylightInEffect            : FALSE
  EnableDaylightSavingsTime   : TRUE
  KeyboardPasswordStatus      : 2
  WakeUpType                  : 2
  BootROMSupported            : TRUE
  BootupState                 : Normal boot
  ChassisBootupState          : 2
  PowerOnPasswordStatus       : 2
  PowerState                  : 0
  PowerSupplyState            : 2
  DomainRole                  : 1
  Roles                       : {"LM_Workstation","LM_Server","NT"}
  Description                 : AT/AT COMPATIBLE
  FrontPanelResetStatus       : 2
  NetworkServerModeEnabled    : TRUE
  InfraredSupported           : FALSE



  Here we run the function without additional parameters which, by default, queries the local machine.  We see that the "BootupState" is a normal boot, that the computer is joined to a domain, has a hypervisor, and is a 64-bit machine.  We also know that the CurrentTimeZone according to the machine is -8 UTC / PST (-480 minutes / 60 minutes) and that Daylight Savings Time (DaylightInEffect) is currently not affecting the time (if this was in play, it would effectively make it -7 UTC or PDT).  Also, the "UserName" property indicates that domain user account "Mark.Johnson" is currently logged on via the console to this machine.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Computer = Get-WmicComputerSystem -ComputerName $list
  PS C:\> $Computer | select ComputerName,Manufacturer,Model,SystemType,UserName,Domain,DNSHostName,HypervisorPresent,
  NumberOfProcessors,NumberOfLogicalProcessors,TotalPhysicalMemoryGB


  ComputerName              : LocLaptop-PC1
  Manufacturer              : Microsoft Corporation
  Model                     : Surface Book
  SystemType                : x64-based PC
  UserName                  : CORP\mark.johnson
  Domain                    : corp.Roxboard.com
  DNSHostName               : LocLaptop-PC1
  HypervisorPresent         : TRUE
  NumberOfProcessors        : 1
  NumberOfLogicalProcessors : 4
  TotalPhysicalMemoryGB     : 7.93

  ComputerName              : RemDesktopPC.corp.Roxboard.com
  Manufacturer              : LENOVO
  Model                     : 4157D51
  SystemType                : x64-based PC
  UserName                  :
  Domain                    : corp.Roxboard.com
  DNSHostName               : RemDesktopPC
  HypervisorPresent         : TRUE
  NumberOfProcessors        : 1
  NumberOfLogicalProcessors : 8
  TotalPhysicalMemoryGB     : 24.00



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Computer" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we selected specific attributes for each computer to dispaly.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicComputerSystem
  Author: Travis Logue
  Version History: 1.0 | 2020-12-22 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicComputerSystem {
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
      $param = "/node:`"$($Computer)`"",'computersystem','get','/format:list'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicComputerSystemListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicComputerSystemListFull.Count; $i++) {
        if ($WmicComputerSystemListFull[$i] -like "AdminPasswordStatus=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicComputerSystemListFull[$i + $counter]
            $counter += 1
          } until ($WmicComputerSystemListFull[$i+1 + $counter] -like "AdminPasswordStatus=*" -or $WmicComputerSystemListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AdminPasswordStatus=' { $AdminPasswordStatus_Value = (($e -split "=",2).trim())[1] }
              '^AutomaticManagedPagefile=' { $AutomaticManagedPagefile_Value = (($e -split "=",2).trim())[1] }
              '^AutomaticResetBootOption=' { $AutomaticResetBootOption_Value = (($e -split "=",2).trim())[1] }
              '^AutomaticResetCapability=' { $AutomaticResetCapability_Value = (($e -split "=",2).trim())[1] }
              '^BootOptionOnLimit=' { $BootOptionOnLimit_Value = (($e -split "=",2).trim())[1] }
              '^BootOptionOnWatchDog=' { $BootOptionOnWatchDog_Value = (($e -split "=",2).trim())[1] }
              '^BootROMSupported=' { $BootROMSupported_Value = (($e -split "=",2).trim())[1] }
              '^BootStatus=' { $BootStatus_Value = (($e -split "=",2).trim())[1] }
              '^BootupState=' { $BootupState_Value = (($e -split "=",2).trim())[1] }
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^ChassisBootupState=' { $ChassisBootupState_Value = (($e -split "=",2).trim())[1] }
              '^ChassisSKUNumber=' { $ChassisSKUNumber_Value = (($e -split "=",2).trim())[1] }
              '^CreationClassName=' { $CreationClassName_Value = (($e -split "=",2).trim())[1] }
              '^CurrentTimeZone=' { $CurrentTimeZone_Value = (($e -split "=",2).trim())[1] }
              '^DaylightInEffect=' { $DaylightInEffect_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DNSHostName=' { $DNSHostName_Value = (($e -split "=",2).trim())[1] }
              '^Domain=' { $Domain_Value = (($e -split "=",2).trim())[1] }
              '^DomainRole=' { $DomainRole_Value = (($e -split "=",2).trim())[1] }
              '^EnableDaylightSavingsTime=' { $EnableDaylightSavingsTime_Value = (($e -split "=",2).trim())[1] }
              '^FrontPanelResetStatus=' { $FrontPanelResetStatus_Value = (($e -split "=",2).trim())[1] }
              '^HypervisorPresent=' { $HypervisorPresent_Value = (($e -split "=",2).trim())[1] }
              '^InfraredSupported=' { $InfraredSupported_Value = (($e -split "=",2).trim())[1] }
              '^InitialLoadInfo=' { $InitialLoadInfo_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^KeyboardPasswordStatus=' { $KeyboardPasswordStatus_Value = (($e -split "=",2).trim())[1] }
              '^LastLoadInfo=' { $LastLoadInfo_Value = (($e -split "=",2).trim())[1] }
              '^Manufacturer=' { $Manufacturer_Value = (($e -split "=",2).trim())[1] }
              '^Model=' { $Model_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^NameFormat=' { $NameFormat_Value = (($e -split "=",2).trim())[1] }
              '^NetworkServerModeEnabled=' { $NetworkServerModeEnabled_Value = (($e -split "=",2).trim())[1] }
              '^NumberOfLogicalProcessors=' { $NumberOfLogicalProcessors_Value = (($e -split "=",2).trim())[1] }
              '^NumberOfProcessors=' { $NumberOfProcessors_Value = (($e -split "=",2).trim())[1] }
              '^OEMLogoBitmap=' { $OEMLogoBitmap_Value = (($e -split "=",2).trim())[1] }
              '^OEMStringArray=' { $OEMStringArray_Value = (($e -split "=",2).trim())[1] }
              '^PartOfDomain=' { $PartOfDomain_Value = (($e -split "=",2).trim())[1] }
              '^PauseAfterReset=' { $PauseAfterReset_Value = (($e -split "=",2).trim())[1] }
              '^PCSystemType=' { $PCSystemType_Value = (($e -split "=",2).trim())[1] }
              '^PCSystemTypeEx=' { $PCSystemTypeEx_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementCapabilities=' { $PowerManagementCapabilities_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementSupported=' { $PowerManagementSupported_Value = (($e -split "=",2).trim())[1] }
              '^PowerOnPasswordStatus=' { $PowerOnPasswordStatus_Value = (($e -split "=",2).trim())[1] }
              '^PowerState=' { $PowerState_Value = (($e -split "=",2).trim())[1] }
              '^PowerSupplyState=' { $PowerSupplyState_Value = (($e -split "=",2).trim())[1] }
              '^PrimaryOwnerContact=' { $PrimaryOwnerContact_Value = (($e -split "=",2).trim())[1] }
              '^PrimaryOwnerName=' { $PrimaryOwnerName_Value = (($e -split "=",2).trim())[1] }
              '^ResetCapability=' { $ResetCapability_Value = (($e -split "=",2).trim())[1] }
              '^ResetCount=' { $ResetCount_Value = (($e -split "=",2).trim())[1] }
              '^ResetLimit=' { $ResetLimit_Value = (($e -split "=",2).trim())[1] }
              '^Roles=' { $Roles_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^SupportContactDescription=' { $SupportContactDescription_Value = (($e -split "=",2).trim())[1] }
              '^SystemFamily=' { $SystemFamily_Value = (($e -split "=",2).trim())[1] }
              '^SystemSKUNumber=' { $SystemSKUNumber_Value = (($e -split "=",2).trim())[1] }
              '^SystemStartupDelay=' { $SystemStartupDelay_Value = (($e -split "=",2).trim())[1] }
              '^SystemStartupOptions=' { $SystemStartupOptions_Value = (($e -split "=",2).trim())[1] }
              '^SystemStartupSetting=' { $SystemStartupSetting_Value = (($e -split "=",2).trim())[1] }
              '^SystemType=' { $SystemType_Value = (($e -split "=",2).trim())[1] }
              '^ThermalState=' { $ThermalState_Value = (($e -split "=",2).trim())[1] }
              '^TotalPhysicalMemory=' { $TotalPhysicalMemory_Value = (($e -split "=",2).trim())[1] }
              '^UserName=' { $UserName_Value = (($e -split "=",2).trim())[1] }
              '^WakeUpType=' { $WakeUpType_Value = (($e -split "=",2).trim())[1] }
              '^Workgroup=' { $Workgroup_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AdminPasswordStatus = $AdminPasswordStatus_Value
            AutomaticManagedPagefile = $AutomaticManagedPagefile_Value
            AutomaticResetBootOption = $AutomaticResetBootOption_Value
            AutomaticResetCapability = $AutomaticResetCapability_Value
            BootOptionOnLimit = $BootOptionOnLimit_Value
            BootOptionOnWatchDog = $BootOptionOnWatchDog_Value
            BootROMSupported = $BootROMSupported_Value
            BootStatus = $BootStatus_Value
            BootupState = $BootupState_Value
            Caption = $Caption_Value
            ChassisBootupState = $ChassisBootupState_Value
            ChassisSKUNumber = $ChassisSKUNumber_Value
            CreationClassName = $CreationClassName_Value
            CurrentTimeZone = $CurrentTimeZone_Value
            DaylightInEffect = $DaylightInEffect_Value
            Description = $Description_Value
            DNSHostName = $DNSHostName_Value
            Domain = $Domain_Value
            DomainRole = $DomainRole_Value
            EnableDaylightSavingsTime = $EnableDaylightSavingsTime_Value
            FrontPanelResetStatus = $FrontPanelResetStatus_Value
            HypervisorPresent = $HypervisorPresent_Value
            InfraredSupported = $InfraredSupported_Value
            InitialLoadInfo = $InitialLoadInfo_Value
            InstallDate = $InstallDate_Value
            KeyboardPasswordStatus = $KeyboardPasswordStatus_Value
            LastLoadInfo = $LastLoadInfo_Value
            Manufacturer = $Manufacturer_Value
            Model = $Model_Value
            Name = $Name_Value
            NameFormat = $NameFormat_Value
            NetworkServerModeEnabled = $NetworkServerModeEnabled_Value
            NumberOfLogicalProcessors = $NumberOfLogicalProcessors_Value
            NumberOfProcessors = $NumberOfProcessors_Value
            OEMLogoBitmap = $OEMLogoBitmap_Value
            OEMStringArray = $OEMStringArray_Value
            PartOfDomain = $PartOfDomain_Value
            PauseAfterReset = $PauseAfterReset_Value
            PCSystemType = $PCSystemType_Value
            PCSystemTypeEx = $PCSystemTypeEx_Value
            PowerManagementCapabilities = $PowerManagementCapabilities_Value
            PowerManagementSupported = $PowerManagementSupported_Value
            PowerOnPasswordStatus = $PowerOnPasswordStatus_Value
            PowerState = $PowerState_Value
            PowerSupplyState = $PowerSupplyState_Value
            PrimaryOwnerContact = $PrimaryOwnerContact_Value
            PrimaryOwnerName = $PrimaryOwnerName_Value
            ResetCapability = $ResetCapability_Value
            ResetCount = $ResetCount_Value
            ResetLimit = $ResetLimit_Value
            Roles = $Roles_Value
            Status = $Status_Value
            SupportContactDescription = $SupportContactDescription_Value
            SystemFamily = $SystemFamily_Value
            SystemSKUNumber = $SystemSKUNumber_Value
            SystemStartupDelay = $SystemStartupDelay_Value
            SystemStartupOptions = $SystemStartupOptions_Value
            SystemStartupSetting = $SystemStartupSetting_Value
            SystemType = $SystemType_Value
            ThermalState = $ThermalState_Value
            TotalPhysicalMemoryGB = "{0:f2}" -f ([Math]::Round([Math]::Ceiling(($TotalPhysicalMemory_Value/1GB) * 100) / 100, 2))
            UserName = $UserName_Value
            WakeUpType = $WakeUpType_Value
            Workgroup = $Workgroup_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Manufacturer,SystemFamily,Model,SystemType,PrimaryOwnerName,UserName,PartOfDomain,DNSHostName,Domain,SystemSKUNumber,HypervisorPresent,NumberOfProcessors,NumberOfLogicalProcessors,TotalPhysicalMemoryGB,CurrentTimeZone,DaylightInEffect,EnableDaylightSavingsTime,KeyboardPasswordStatus,WakeUpType,BootROMSupported,BootupState,ChassisBootupState,PowerOnPasswordStatus,PowerState,PowerSupplyState,DomainRole,Roles,Description,FrontPanelResetStatus,NetworkServerModeEnabled,InfraredSupported,PauseAfterReset,PCSystemType,PCSystemTypeEx,ThermalState,AdminPasswordStatus,AutomaticManagedPagefile,AutomaticResetBootOption,AutomaticResetCapability,Name,Caption,CreationClassName,ResetCapability,ResetCount,ResetLimit,Status,BootOptionOnLimit,BootOptionOnWatchDog,BootStatus,ChassisSKUNumber,InitialLoadInfo,InstallDate,LastLoadInfo,NameFormat,OEMLogoBitmap,OEMStringArray,PowerManagementCapabilities,PowerManagementSupported,PrimaryOwnerContact,SupportContactDescription,SystemStartupDelay,SystemStartupOptions,SystemStartupSetting,Workgroup

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}