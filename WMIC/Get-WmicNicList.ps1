<#
.SYNOPSIS
  The "Get-WmicNicList" function is a WMIC command wrapper for getting a list of Network Interface Cards (NICs) and related information on one or many computers.  The Interface Index, Mac Address, Service name, Speed of the interface, and Plug and Play Device ID are some key aspects of the output.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-WmicNicList | more  

  ComputerName                : LocLaptop-PC1
  AdapterType                 : Ethernet 802.3
  Index                       : 1
  MACAddress                  : B4:AE:2B:C8:17:29
  NetConnectionID             : Wi-Fi
  ProductName                 : Marvell AVASTAR Wireless-AC Network Controller
  ServiceName                 : mrvlpcie8897
  Manufacturer                : Marvell Semiconductors, Inc.
  Speed                       : 9223372036854775807
  TimeOfLastReset             : 20201205160057.501533-480
  PNPDeviceID                 : PCI\VEN_11AB&amp;DEV_2B38&amp;SUBSYS_045E0004&amp;REV_00\4&amp;1A5036A5&amp;0&amp;00EB
  AutoSense                   :  



  Here we run the function without additional parameters which, by default, queries the local machine.  The results of the function include Interface Index, MACAddress, ProductName, Manufacturer, Plug and Play Device ID, and more.  Of particular note is the "TimeOfLastReset" which seems to indicate the last time a restart of the computer occurred.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $nics = Get-WmicNicList -ComputerName $list
  PS C:\> $nics | ft

  ComputerName                   AdapterType    Index MACAddress        NetConnectionID              ProductName                                    ServiceName     Manufact
                                                                                                                                                                    urer
  ------------                   -----------    ----- ----------        ---------------              -----------                                    -----------     --------
  LocLaptop-PC1                                 0                                                    Microsoft Kernel Debug Network Adapter         kdnic           Micro...
  LocLaptop-PC1                  Ethernet 802.3 1     B4:AE:2B:C8:17:29 Wi-Fi                        Marvell AVASTAR Wireless-AC Network Controller mrvlpcie8897    Marve...
  LocLaptop-PC1                  Ethernet 802.3 2     B6:AE:2B:C8:16:28                              Microsoft Wi-Fi Direct Virtual Adapter         vwifimp         Micro...
  LocLaptop-PC1                  Ethernet 802.3 3     B4:AE:2B:C8:17:2A Bluetooth Network Connection Bluetooth Device (Personal Area Network)       BthPan          Micro...
  LocLaptop-PC1                                 4                                                    Juniper Networks Virtual Adapter
  LocLaptop-PC1                  Ethernet 802.3 5     B6:AE:2B:C8:13:28                              Microsoft Wi-Fi Direct Virtual Adapter         vwifimp         Micro...
  LocLaptop-PC1                                 6                                                    WAN Miniport (SSTP)                            RasSstp         Micro...
  LocLaptop-PC1                                 7                                                    WAN Miniport (IKEv2)                           RasAgileVpn     Micro...
  LocLaptop-PC1                                 8                                                    WAN Miniport (L2TP)                            Rasl2tp         Micro...
  LocLaptop-PC1                                 9                                                    WAN Miniport (PPTP)                            PptpMiniport    Micro...
  LocLaptop-PC1                                 10                                                   WAN Miniport (PPPOE)                           RasPppoe        Micro...
  LocLaptop-PC1                  Ethernet 802.3 11    DC:00:20:52:41:53                              WAN Miniport (IP)                              NdisWan         Micro...
  LocLaptop-PC1                  Ethernet 802.3 12    E6:5C:20:52:41:53                              WAN Miniport (IPv6)                            NdisWan         Micro...
  LocLaptop-PC1                  Ethernet 802.3 13    EE:2B:20:52:41:53                              WAN Miniport (Network Monitor)                 NdisWan         Micro...
  LocLaptop-PC1                  Ethernet 802.3 16    C4:9D:ED:EA:05:B4 Ethernet 4                   Surface Ethernet Adapter                       msux64w10       Micro...
  LocLaptop-PC1                                 18                                                   RAS Async Adapter
  LocLaptop-PC1                                 19                                                   Juniper Networks Virtual Adapter Manager       JnprVaMgr       Junip...
  LocLaptop-PC1                  Ethernet 802.3 20    02:05:85:7F:EB:80 Local Area Connection* 13    Juniper Networks Virtual Adapter               jnprva          Junip...
  LocLaptop-PC1                  Ethernet 802.3 22    64:5A:ED:F3:6C:CB Ethernet 6                   ASIX AX88772A USB2.0 to Fast Ethernet Adapter  AX88772         ASIX
  LocLaptop-PC1                  Ethernet 802.3 23    00:FF:BF:E3:F0:C0 Local Area Connection        TAP-Windows Adapter V9 for OpenVPN Connect     tap_ovpnconnect TAP-W...
  RemDesktopPC.corp.Roxboard.com                0                                                    Microsoft Kernel Debug Network Adapter         kdnic           Micro...
  RemDesktopPC.corp.Roxboard.com Ethernet 802.3 1     B4:AE:2B:C8:17:29 Wi-Fi                        Marvell AVASTAR Wireless-AC Network Controller mrvlpcie8897    Marve...
  RemDesktopPC.corp.Roxboard.com Ethernet 802.3 2     B6:AE:2B:C8:16:28                              Microsoft Wi-Fi Direct Virtual Adapter         vwifimp         Micro...
  RemDesktopPC.corp.Roxboard.com Ethernet 802.3 3     B4:AE:2B:C8:17:2A Bluetooth Network Connection Bluetooth Device (Personal Area Network)       BthPan          Micro...
  RemDesktopPC.corp.Roxboard.com                4                                                    Juniper Networks Virtual Adapter
  RemDesktopPC.corp.Roxboard.com Ethernet 802.3 5     B6:AE:2B:C8:13:28                              Microsoft Wi-Fi Direct Virtual Adapter         vwifimp         Micro...


  
  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer computers in the variable "$nic" and then use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicNicList
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicNicList {
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
      $param = "/node:`"$($Computer)`"",'nic','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicNicListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicNicListFull.Count; $i++) {
        if ($WmicNicListFull[$i] -like "AdapterType=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicNicListFull[$i + $counter]
            $counter += 1
          } until ($WmicNicListFull[$i+1 + $counter] -like "AdapterType=*" -or $WmicNicListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AdapterType=' { $AdapterType_Value = (($e -split "=",2).trim())[1] }
              '^AutoSense=' { $AutoSense_Value = (($e -split "=",2).trim())[1] }
              '^Availability=' { $Availability_Value = (($e -split "=",2).trim())[1] }
              '^ConfigManagerErrorCode=' { $ConfigManagerErrorCode_Value = (($e -split "=",2).trim())[1] }
              '^ConfigManagerUserConfig=' { $ConfigManagerUserConfig_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DeviceID=' { $DeviceID_Value = (($e -split "=",2).trim())[1] }
              '^ErrorCleared=' { $ErrorCleared_Value = (($e -split "=",2).trim())[1] }
              '^ErrorDescription=' { $ErrorDescription_Value = (($e -split "=",2).trim())[1] }
              '^Index=' { $Index_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^Installed=' { $Installed_Value = (($e -split "=",2).trim())[1] }
              '^LastErrorCode=' { $LastErrorCode_Value = (($e -split "=",2).trim())[1] }
              '^MACAddress=' { $MACAddress_Value = (($e -split "=",2).trim())[1] }
              '^Manufacturer=' { $Manufacturer_Value = (($e -split "=",2).trim())[1] }
              '^MaxNumberControlled=' { $MaxNumberControlled_Value = (($e -split "=",2).trim())[1] }
              '^MaxSpeed=' { $MaxSpeed_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^NetConnectionID=' { $NetConnectionID_Value = (($e -split "=",2).trim())[1] }
              '^NetConnectionStatus=' { $NetConnectionStatus_Value = (($e -split "=",2).trim())[1] }
              '^NetworkAddresses=' { $NetworkAddresses_Value = (($e -split "=",2).trim())[1] }
              '^PermanentAddress=' { $PermanentAddress_Value = (($e -split "=",2).trim())[1] }
              '^PNPDeviceID=' { $PNPDeviceID_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementCapabilities=' { $PowerManagementCapabilities_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementSupported=' { $PowerManagementSupported_Value = (($e -split "=",2).trim())[1] }
              '^ProductName=' { $ProductName_Value = (($e -split "=",2).trim())[1] }
              '^ServiceName=' { $ServiceName_Value = (($e -split "=",2).trim())[1] }
              '^Speed=' { $Speed_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^StatusInfo=' { $StatusInfo_Value = (($e -split "=",2).trim())[1] }
              '^TimeOfLastReset=' { $TimeOfLastReset_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AdapterType = $AdapterType_Value
            AutoSense = $AutoSense_Value
            Availability = $Availability_Value
            ConfigManagerErrorCode = $ConfigManagerErrorCode_Value
            ConfigManagerUserConfig = $ConfigManagerUserConfig_Value
            Description = $Description_Value
            DeviceID = $DeviceID_Value
            ErrorCleared = $ErrorCleared_Value
            ErrorDescription = $ErrorDescription_Value
            Index = $Index_Value
            InstallDate = $InstallDate_Value
            Installed = $Installed_Value
            LastErrorCode = $LastErrorCode_Value
            MACAddress = $MACAddress_Value
            Manufacturer = $Manufacturer_Value
            MaxNumberControlled = $MaxNumberControlled_Value
            MaxSpeed = $MaxSpeed_Value
            Name = $Name_Value
            NetConnectionID = $NetConnectionID_Value
            NetConnectionStatus = $NetConnectionStatus_Value
            NetworkAddresses = $NetworkAddresses_Value
            PermanentAddress = $PermanentAddress_Value
            PNPDeviceID = $PNPDeviceID_Value
            PowerManagementCapabilities = $PowerManagementCapabilities_Value
            PowerManagementSupported = $PowerManagementSupported_Value
            ProductName = $ProductName_Value
            ServiceName = $ServiceName_Value
            Speed = $Speed_Value
            Status = $Status_Value
            StatusInfo = $StatusInfo_Value
            TimeOfLastReset = $TimeOfLastReset_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    # Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,AdapterType,Index,MACAddress,NetConnectionID,ProductName,ServiceName,Manufacturer,Speed,TimeOfLastReset,PNPDeviceID,AutoSense,Availability,ConfigManagerErrorCode,ConfigManagerUserConfig,Description,ErrorCleared,ErrorDescription,InstallDate,Installed,LastErrorCode,MaxNumberControlled,MaxSpeed,DeviceID,NetConnectionStatus,NetworkAddresses,PermanentAddress,PowerManagementCapabilities,PowerManagementSupported,Name,Status,StatusInfo

    Write-Output $SpecificSelectionOrder

  }
  
  end {}
}