<#
.SYNOPSIS
  The "Find-Route" function finds the route / egress interface that the local computer will use in order to communicate with a given destination IP Address.

.DESCRIPTION
.EXAMPLE
  PS C:\> nslookup.exe RemDesktopPC
  Server:  anycast.Roxboard.com
  Address:  10.9.8.7

  Name:    RemDesktopPC.corp.Roxboard.com
  Address:  10.44.29.235


  PS C:\> Find-Route 10.44.29.235

  DestinationIP              : 10.44.29.235
  DestinationNetwork         : 10.44.0.0/16
  NextHop                    : 0.0.0.0
  EgressInterfaceIndex       : 10
  EgressInterfaceAlias       : Local Area Connection* 13
  EgressInterfaceDescription : Juniper Networks Virtual Adapter
  EgressInterfaceIPAddress   : 10.30.40.4
  EgressInterfaceNetMask     : 32
  EgressInterfaceDnsSuffix   : corp.Roxboard.com
  EgressNetworkOrigin        : Manual


  PS C:\> Find-Route 8.8.8.8

  DestinationIP              : 8.8.8.8
  DestinationNetwork         : 0.0.0.0/0
  NextHop                    : 10.80.7.1
  EgressInterfaceIndex       : 25
  EgressInterfaceAlias       : Ethernet 6
  EgressInterfaceDescription : ASIX AX88772A USB2.0 to Fast Ethernet Adapter
  EgressInterfaceIPAddress   : 10.80.7.56
  EgressInterfaceNetMask     : 24
  EgressInterfaceDnsSuffix   : boggle.local
  EgressNetworkOrigin        : Dhcp



  Here, in the first example, we demonstrate finding the route and egress interface for a given corporate IP Address (over a VPN connection).  Next, we show the route and the egress interface that is taken when communicating to Google's DNS server (via a split-tunnel VPN configuration), egressing directly to the Internet.

.INPUTS
.OUTPUTS
.NOTES
  Name: Find-Route.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-02-22 | Updated properties
  Dependencies: 
  Notes:


  .
#>
function Find-Route {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $IPAddress
  )
  
  begin {}
  
  process {
    
    $MSFT_NetIPAddress,$MSFT_NetRoute = Find-NetRoute -RemoteIPAddress $IPAddress

    $NetworkAdapter = $MSFT_NetIPAddress | Get-Netadapter
    $ConnectionSpecificSuffix =($MSFT_NetIPAddress | Get-DnsClient).Suffix

    $prop = [ordered]@{
    
      DestinationIP = $IPAddress
      DestinationNetwork = $MSFT_NetRoute.DestinationPrefix
      NextHop = $MSFT_NetRoute.NextHop
      EgressInterfaceIndex = $MSFT_NetIPAddress.InterfaceIndex
      EgressInterfaceAlias = $MSFT_NetRoute.InterfaceAlias
      EgressInterfaceDescription = $NetworkAdapter.InterfaceDescription
      EgressInterfaceIPAddress = $MSFT_NetIPAddress.IPAddress
      EgressInterfaceNetMask = $MSFT_NetIPAddress.PrefixLength
      EgressInterfaceDnsSuffix = $ConnectionSpecificSuffix
      EgressNetworkOrigin = $MSFT_NetIPAddress.PrefixOrigin
    
    } 

    $obj = New-Object -TypeName psobject -Property $prop
    Write-Output $obj
  } 
  
  end {}
}