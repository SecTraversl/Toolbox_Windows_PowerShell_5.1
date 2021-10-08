<#
.SYNOPSIS
  The "Get-WmicNicConfig" function is a WMIC command wrapper for getting a list of Network Adapter (NIC) related information on one or many computers.  The MAC Address, IP Address, Default Gateway, DHCP Server, and DNS information are some key aspects of the output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $NicConfig = Get-WmicNicConfig
  PS C:\> $NicConfig | sort IPAddress -Descending | select -f 1

  ComputerName                 : LocLaptop-PC1
  Description                  : ASIX AX88772A USB2.0 to Fast Ethernet Adapter
  ServiceName                  : AX88772
  Index                        : 22
  MACAddress                   : 64:5A:ED:F3:6C:CB
  IPAddress                    : {"10.80.7.56"}
  IPSubnet                     : {"255.255.255.0"}
  DefaultIPGateway             : {"10.80.7.1"}
  DHCPServer                   : 10.80.7.1
  DNSDomain                    : boggle.local
  DNSServerSearchOrder         : {"10.80.7.1"}
  DNSDomainSuffixSearchOrder   : {"corp.Roxboard.com","Roxboard.com","dorpcal.com","egatscal.com","Roxboardpas.local"}
  DHCPLeaseObtained            : 20201214061437.000000-480
  DHCPLeaseExpires             : 20201221061437.000000-480
  DHCPEnabled                  : TRUE
  IPEnabled                    : TRUE
  SettingID                    : {FF50083E-AD9F-4597-805E-ADF5DFA26C95}
  FullDNSRegistrationEnabled   : TRUE
  IPConnectionMetric           : 35
  TcpipNetbiosOptions          : 0
  GatewayCostMetric            : {0}
  DomainDNSRegistrationEnabled : FALSE
  DNSEnabledForWINSResolution  : FALSE
  WINSEnableLMHostsLookup      : TRUE
  IPFilterSecurityEnabled      : FALSE
  IPSecPermitIPProtocols       : {}
  IPSecPermitTCPPorts          : {}
  IPSecPermitUDPPorts          : {}



  Here we run the function without additional parameters which, by default, queries the local machine.  The output includes Network Adapter Description, Service, Interface Index and Mac Address; as well as the IP Address, Subnet mask, Default Gateway, DHCP Server and more.  

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $NicConfig = Get-WmicNicConfig -ComputerName $list
  PS C:\> $NicConfig | sort IPAddress -Descending | ft

  ComputerName                   Description                                    ServiceName     Index MACAddress        IPAddress                                       IPSubnet                 DefaultIPGateway
  ------------                   -----------                                    -----------     ----- ----------        ---------                                       --------                 ----------------
  RemDesktopPC.corp.Roxboard.com Hyper-V Virtual Ethernet Adapter #3            VMSNPXYMP       8     00:15:5D:51:83:A2 {"192.168.146.129","fe80::606b:3243:2dfc:d3ee"} {"255.255.255.240","64"}
  RemDesktopPC.corp.Roxboard.com Hyper-V Virtual Ethernet Adapter #2            VMSNPXYMP       7     00:15:5D:DA:9E:05 {"169.254.163.132"}                             {"255.255.0.0"}
  RemDesktopPC.corp.Roxboard.com ASIX AX88772A USB2.0 to Fast Ethernet Adapter  AX88772         22    64:5A:ED:F3:6C:CB {"10.80.7.56"}                                  {"255.255.255.0"}        {"10.80.7.1"}
  LocLaptop-PC1                  ASIX AX88772A USB2.0 to Fast Ethernet Adapter  AX88772         22    64:5A:ED:F3:6C:CB {"10.80.7.56"}                                  {"255.255.255.0"}        {"10.80.7.1"}
  RemDesktopPC.corp.Roxboard.com Hyper-V Virtual Ethernet Adapter               VMSNPXYMP       6     CC:52:AF:3E:4E:82 {"10.44.29.235"}                                {"255.255.255.0"}        {"10.44.29.1"}
  LocLaptop-PC1                  Juniper Networks Virtual Adapter               jnprva          20    02:05:85:7F:EB:80 {"10.30.40.2"}                                  {"255.255.255.255"}
  RemDesktopPC.corp.Roxboard.com Juniper Networks Virtual Adapter               jnprva          20    02:05:85:7F:EB:80 {"10.30.40.2"}                                  {"255.255.255.255"}
  RemDesktopPC.corp.Roxboard.com Juniper Networks Virtual Adapter Manager                       1
  RemDesktopPC.corp.Roxboard.com WAN Miniport (Network Monitor)                 NdisWan         13    EE:2B:20:52:41:53
  RemDesktopPC.corp.Roxboard.com WAN Miniport (IP)                              NdisWan         11    DC:00:20:52:41:53
  RemDesktopPC.corp.Roxboard.com WAN Miniport (IPv6)                            NdisWan         12    E6:5C:20:52:41:53
  RemDesktopPC.corp.Roxboard.com Surface Ethernet Adapter                       msux64w10       16
  RemDesktopPC.corp.Roxboard.com TAP-Windows Adapter V9 for OpenVPN Connect     tap_ovpnconnect 23    00:FF:BF:E3:F0:C0
  RemDesktopPC.corp.Roxboard.com Juniper Networks Virtual Adapter Manager                       19
  RemDesktopPC.corp.Roxboard.com RAS Async Adapter                              AsyncMac        18
  RemDesktopPC.corp.Roxboard.com Microsoft Kernel Debug Network Adapter         kdnic           0
  


  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer computers in the variable "$NicConfig", sort the output based on the "IPAddress" property, and use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicNicConfig
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicNicConfig {
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
      $param = "/node:`"$($Computer)`"",'nicconfig','list','full'     
      $Results = & $wmic $param #| Where-Object {$_}
      $WmicNicConfigListFull += $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicNicConfigListFull.Count; $i++) {
        if ($WmicNicConfigListFull[$i] -like "ArpAlwaysSourceRoute=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicNicConfigListFull[$i + $counter]
            $counter += 1
          } until ($WmicNicConfigListFull[$i+1 + $counter] -like "ArpAlwaysSourceRoute=*" -or $WmicNicConfigListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^ArpAlwaysSourceRoute=' { $ArpAlwaysSourceRoute_Value = (($e -split "=",2).trim())[1] }
              '^ArpUseEtherSNAP=' { $ArpUseEtherSNAP_Value = (($e -split "=",2).trim())[1] }
              '^DeadGWDetectEnabled=' { $DeadGWDetectEnabled_Value = (($e -split "=",2).trim())[1] }
              '^DefaultIPGateway=' { $DefaultIPGateway_Value = (($e -split "=",2).trim())[1] }
              '^DefaultTOS=' { $DefaultTOS_Value = (($e -split "=",2).trim())[1] }
              '^DefaultTTL=' { $DefaultTTL_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DHCPEnabled=' { $DHCPEnabled_Value = (($e -split "=",2).trim())[1] }
              '^DHCPLeaseExpires=' { $DHCPLeaseExpires_Value = (($e -split "=",2).trim())[1] }
              '^DHCPLeaseObtained=' { $DHCPLeaseObtained_Value = (($e -split "=",2).trim())[1] }
              '^DHCPServer=' { $DHCPServer_Value = (($e -split "=",2).trim())[1] }
              '^DNSDomain=' { $DNSDomain_Value = (($e -split "=",2).trim())[1] }
              '^DNSDomainSuffixSearchOrder=' { $DNSDomainSuffixSearchOrder_Value = (($e -split "=",2).trim())[1] }
              '^DNSEnabledForWINSResolution=' { $DNSEnabledForWINSResolution_Value = (($e -split "=",2).trim())[1] }
              '^DNSHostName=' { $DNSHostName_Value = (($e -split "=",2).trim())[1] }
              '^DNSServerSearchOrder=' { $DNSServerSearchOrder_Value = (($e -split "=",2).trim())[1] }
              '^DomainDNSRegistrationEnabled=' { $DomainDNSRegistrationEnabled_Value = (($e -split "=",2).trim())[1] }
              '^ForwardBufferMemory=' { $ForwardBufferMemory_Value = (($e -split "=",2).trim())[1] }
              '^FullDNSRegistrationEnabled=' { $FullDNSRegistrationEnabled_Value = (($e -split "=",2).trim())[1] }
              '^GatewayCostMetric=' { $GatewayCostMetric_Value = (($e -split "=",2).trim())[1] }
              '^IGMPLevel=' { $IGMPLevel_Value = (($e -split "=",2).trim())[1] }
              '^Index=' { $Index_Value = (($e -split "=",2).trim())[1] }
              '^IPAddress=' { $IPAddress_Value = (($e -split "=",2).trim())[1] }
              '^IPConnectionMetric=' { $IPConnectionMetric_Value = (($e -split "=",2).trim())[1] }
              '^IPEnabled=' { $IPEnabled_Value = (($e -split "=",2).trim())[1] }
              '^IPFilterSecurityEnabled=' { $IPFilterSecurityEnabled_Value = (($e -split "=",2).trim())[1] }
              '^IPPortSecurityEnabled=' { $IPPortSecurityEnabled_Value = (($e -split "=",2).trim())[1] }
              '^IPSecPermitIPProtocols=' { $IPSecPermitIPProtocols_Value = (($e -split "=",2).trim())[1] }
              '^IPSecPermitTCPPorts=' { $IPSecPermitTCPPorts_Value = (($e -split "=",2).trim())[1] }
              '^IPSecPermitUDPPorts=' { $IPSecPermitUDPPorts_Value = (($e -split "=",2).trim())[1] }
              '^IPSubnet=' { $IPSubnet_Value = (($e -split "=",2).trim())[1] }
              '^IPUseZeroBroadcast=' { $IPUseZeroBroadcast_Value = (($e -split "=",2).trim())[1] }
              '^IPXAddress=' { $IPXAddress_Value = (($e -split "=",2).trim())[1] }
              '^IPXEnabled=' { $IPXEnabled_Value = (($e -split "=",2).trim())[1] }
              '^IPXFrameType=' { $IPXFrameType_Value = (($e -split "=",2).trim())[1] }
              '^IPXMediaType=' { $IPXMediaType_Value = (($e -split "=",2).trim())[1] }
              '^IPXNetworkNumber=' { $IPXNetworkNumber_Value = (($e -split "=",2).trim())[1] }
              '^IPXVirtualNetNumber=' { $IPXVirtualNetNumber_Value = (($e -split "=",2).trim())[1] }
              '^KeepAliveInterval=' { $KeepAliveInterval_Value = (($e -split "=",2).trim())[1] }
              '^KeepAliveTime=' { $KeepAliveTime_Value = (($e -split "=",2).trim())[1] }
              '^MACAddress=' { $MACAddress_Value = (($e -split "=",2).trim())[1] }
              '^MTU=' { $MTU_Value = (($e -split "=",2).trim())[1] }
              '^NumForwardPackets=' { $NumForwardPackets_Value = (($e -split "=",2).trim())[1] }
              '^PMTUBHDetectEnabled=' { $PMTUBHDetectEnabled_Value = (($e -split "=",2).trim())[1] }
              '^PMTUDiscoveryEnabled=' { $PMTUDiscoveryEnabled_Value = (($e -split "=",2).trim())[1] }
              '^ServiceName=' { $ServiceName_Value = (($e -split "=",2).trim())[1] }
              '^SettingID=' { $SettingID_Value = (($e -split "=",2).trim())[1] }
              '^TcpipNetbiosOptions=' { $TcpipNetbiosOptions_Value = (($e -split "=",2).trim())[1] }
              '^TcpMaxConnectRetransmissions=' { $TcpMaxConnectRetransmissions_Value = (($e -split "=",2).trim())[1] }
              '^TcpMaxDataRetransmissions=' { $TcpMaxDataRetransmissions_Value = (($e -split "=",2).trim())[1] }
              '^TcpNumConnections=' { $TcpNumConnections_Value = (($e -split "=",2).trim())[1] }
              '^TcpUseRFC1122UrgentPointer=' { $TcpUseRFC1122UrgentPointer_Value = (($e -split "=",2).trim())[1] }
              '^TcpWindowSize=' { $TcpWindowSize_Value = (($e -split "=",2).trim())[1] }
              '^WINSEnableLMHostsLookup=' { $WINSEnableLMHostsLookup_Value = (($e -split "=",2).trim())[1] }
              '^WINSHostLookupFile=' { $WINSHostLookupFile_Value = (($e -split "=",2).trim())[1] }
              '^WINSPrimaryServer=' { $WINSPrimaryServer_Value = (($e -split "=",2).trim())[1] }
              '^WINSScopeID=' { $WINSScopeID_Value = (($e -split "=",2).trim())[1] }
              '^WINSSecondaryServer=' { $WINSSecondaryServer_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            ArpAlwaysSourceRoute = $ArpAlwaysSourceRoute_Value
            ArpUseEtherSNAP = $ArpUseEtherSNAP_Value
            DeadGWDetectEnabled = $DeadGWDetectEnabled_Value
            DefaultIPGateway = $DefaultIPGateway_Value
            DefaultTOS = $DefaultTOS_Value
            DefaultTTL = $DefaultTTL_Value
            Description = $Description_Value
            DHCPEnabled = $DHCPEnabled_Value
            DHCPLeaseExpires = $DHCPLeaseExpires_Value
            DHCPLeaseObtained = $DHCPLeaseObtained_Value
            DHCPServer = $DHCPServer_Value
            DNSDomain = $DNSDomain_Value
            DNSDomainSuffixSearchOrder = $DNSDomainSuffixSearchOrder_Value
            DNSEnabledForWINSResolution = $DNSEnabledForWINSResolution_Value
            DNSHostName = $DNSHostName_Value
            DNSServerSearchOrder = $DNSServerSearchOrder_Value
            DomainDNSRegistrationEnabled = $DomainDNSRegistrationEnabled_Value
            ForwardBufferMemory = $ForwardBufferMemory_Value
            FullDNSRegistrationEnabled = $FullDNSRegistrationEnabled_Value
            GatewayCostMetric = $GatewayCostMetric_Value
            IGMPLevel = $IGMPLevel_Value
            Index = $Index_Value
            IPAddress = $IPAddress_Value
            IPConnectionMetric = $IPConnectionMetric_Value
            IPEnabled = $IPEnabled_Value
            IPFilterSecurityEnabled = $IPFilterSecurityEnabled_Value
            IPPortSecurityEnabled = $IPPortSecurityEnabled_Value
            IPSecPermitIPProtocols = $IPSecPermitIPProtocols_Value
            IPSecPermitTCPPorts = $IPSecPermitTCPPorts_Value
            IPSecPermitUDPPorts = $IPSecPermitUDPPorts_Value
            IPSubnet = $IPSubnet_Value
            IPUseZeroBroadcast = $IPUseZeroBroadcast_Value
            IPXAddress = $IPXAddress_Value
            IPXEnabled = $IPXEnabled_Value
            IPXFrameType = $IPXFrameType_Value
            IPXMediaType = $IPXMediaType_Value
            IPXNetworkNumber = $IPXNetworkNumber_Value
            IPXVirtualNetNumber = $IPXVirtualNetNumber_Value
            KeepAliveInterval = $KeepAliveInterval_Value
            KeepAliveTime = $KeepAliveTime_Value
            MACAddress = $MACAddress_Value
            MTU = $MTU_Value
            NumForwardPackets = $NumForwardPackets_Value
            PMTUBHDetectEnabled = $PMTUBHDetectEnabled_Value
            PMTUDiscoveryEnabled = $PMTUDiscoveryEnabled_Value
            ServiceName = $ServiceName_Value
            SettingID = $SettingID_Value
            TcpipNetbiosOptions = $TcpipNetbiosOptions_Value
            TcpMaxConnectRetransmissions = $TcpMaxConnectRetransmissions_Value
            TcpMaxDataRetransmissions = $TcpMaxDataRetransmissions_Value
            TcpNumConnections = $TcpNumConnections_Value
            TcpUseRFC1122UrgentPointer = $TcpUseRFC1122UrgentPointer_Value
            TcpWindowSize = $TcpWindowSize_Value
            WINSEnableLMHostsLookup = $WINSEnableLMHostsLookup_Value
            WINSHostLookupFile = $WINSHostLookupFile_Value
            WINSPrimaryServer = $WINSPrimaryServer_Value
            WINSScopeID = $WINSScopeID_Value
            WINSSecondaryServer = $WINSSecondaryServer_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,ServiceName,Index,MACAddress,IPAddress,IPSubnet,DefaultIPGateway,DHCPServer,DNSDomain,DNSServerSearchOrder,DNSDomainSuffixSearchOrder,DHCPLeaseObtained,DHCPLeaseExpires,DHCPEnabled,IPEnabled,SettingID,FullDNSRegistrationEnabled,IPConnectionMetric,TcpipNetbiosOptions,GatewayCostMetric,DomainDNSRegistrationEnabled,DNSEnabledForWINSResolution,WINSEnableLMHostsLookup,IPFilterSecurityEnabled,IPSecPermitIPProtocols,IPSecPermitTCPPorts,IPSecPermitUDPPorts,ArpAlwaysSourceRoute,ArpUseEtherSNAP,DeadGWDetectEnabled,DefaultTOS,DefaultTTL,DNSHostName,ForwardBufferMemory,IGMPLevel,IPPortSecurityEnabled,IPUseZeroBroadcast,IPXAddress,IPXEnabled,IPXFrameType,IPXMediaType,IPXNetworkNumber,IPXVirtualNetNumber,KeepAliveInterval,KeepAliveTime,MTU,NumForwardPackets,PMTUBHDetectEnabled,PMTUDiscoveryEnabled,TcpMaxConnectRetransmissions,TcpMaxDataRetransmissions,TcpNumConnections,TcpUseRFC1122UrgentPointer,TcpWindowSize,WINSHostLookupFile,WINSPrimaryServer,WINSScopeID,WINSSecondaryServer

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}