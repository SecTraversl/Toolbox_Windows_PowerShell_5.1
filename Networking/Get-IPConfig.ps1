<#
.SYNOPSIS
  The "Get-IPConfig" function gathers the majority of network interface information relevant to troubleshooting common connectivity problems on a Windows computer in a single output.  Do you want to know the IPAddress, Subnet Mask (in CIDR and dotted decimal), and the default gateway IP Address?  Do you want the DNS domain for the computer, the DNS Servers, the DNS server search order, and the DNS domain suffix search order?  Do you want to know if the IP Address was manually assigned or if the IP was assigned via DHCP?  Do you want to know if the interface is categorized as "Public", "Private", or "Domain" (DomainAuthenticated) so you can validate which Windows Firewall rules apply to the given interface?  Do you want the MAC address and the Link speed for the network adapter?  Do you want DHCP lease information and the IP Address of the DHCP server?  We've got it.

.DESCRIPTION
.EXAMPLE
  PS C:\> *ipcon <tab>
  PS C:\> Get-IPConfig

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*ipcon" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> ipa

  IPAddress  InterfaceAlias            DefaultIPGateway InterfaceIndex
  ---------  --------------            ---------------- --------------
  10.80.7.56 Ethernet 6                10.80.7.1                    25
  10.30.40.4 Local Area Connection* 13                              10


  PS C:\>
  PS C:\> Get-IPConfig

  IPAddress  InterfaceAlias            DefaultIPGateway InterfaceIndex
  ---------  --------------            ---------------- --------------
  10.80.7.56 Ethernet 6                10.80.7.1                    25
  10.30.40.4 Local Area Connection* 13                              10



  Here we first run the function using the built-in alias of "ipa" and then we run the function using its full name. In return, we get fundamental information about the two active interfaces.  Each object has additional properties besides "IPAddress", "InterfaceAlias", "DefaultIPGateway", and "InterfaceIndex", but, by default, these are the only 4 properties that are displayed.

.EXAMPLE
  PS C:\> Get-IPConfig | select *

  ConnectionProfileName      : HomeFronter
  NetworkCategory            : Public
  InterfaceAlias             : Ethernet 6
  InterfaceIndex             : 25
  NetworkOrigin              : Dhcp
  IPAddress                  : 10.80.7.56
  DefaultIPGateway           : 10.80.7.1
  NetMaskCIDR                : 24
  NetMask                    : 255.255.255.0
  DnsDomain                  : boggle.local
  DnsServersAndSearchOrder   : {10.80.7.1}
  DnsDomainSuffixSearchOrder : {corp.Roxboard.com, Roxboard.com, dorpcal.com, egatscal.com...}
  InterfaceDescription       : ASIX AX88772A USB2.0 to Fast Ethernet Adapter
  MacAddress                 : 75:ED:BA:F3:6C:CB
  LinkSpeed                  : 100 Mbps
  DhcpEnabled                : True
  DhcpServer                 : 10.80.7.1
  DhcpLeaseObtained          : 2/23/2021 6:51:36 AM
  DhcpLeaseExpires           : 3/2/2021 6:51:36 AM

  ConnectionProfileName      : Roxboard.com
  NetworkCategory            : DomainAuthenticated
  InterfaceAlias             : Local Area Connection* 13
  InterfaceIndex             : 10
  NetworkOrigin              : Manual
  IPAddress                  : 10.30.40.4
  DefaultIPGateway           :
  NetMaskCIDR                : 32
  NetMask                    : 255.255.255.255
  DnsDomain                  : corp.Roxboard.com
  DnsServersAndSearchOrder   : {10.9.8.7, 10.30.5.20}
  DnsDomainSuffixSearchOrder : {corp.Roxboard.com, Roxboard.com, dorpcal.com, egatscal.com...}
  InterfaceDescription       : Juniper Networks Virtual Adapter
  MacAddress                 : DD:07:46:7F:EB:80
  LinkSpeed                  : 2 Gbps
  DhcpEnabled                : False
  DhcpServer                 :
  DhcpLeaseObtained          :
  DhcpLeaseExpires           :



  Here we run the function and display all of the returned properties by using "Select-Object *".  This presents the true value of this function in that information about DHCP, DNS, the IP Address, network/subnetmask, default gateway, MAC Address, and interface link speed are all gathered as properties of a single object.

.EXAMPLE
  PS C:\> Get-IPConfig -AllInterfaces

  IPAddress                    InterfaceAlias               DefaultIPGateway InterfaceIndex
  ---------                    --------------               ---------------- --------------
  fe80::8865:b625:99b4:3700%14 Bluetooth Network Connection                              14
  fe80::c57:a7d5:8f45:b520%20  Local Area Connection                                     20
  ::1                          Loopback Pseudo-Interface 1                                1
  10.80.7.56                   Ethernet 6                   10.80.7.1                    25
  10.30.40.4                   Local Area Connection* 13                                 10
  169.254.103.89               Ethernet 4                                                15
  169.254.55.0                 Bluetooth Network Connection                              14
  169.254.181.32               Local Area Connection                                     20
  127.0.0.1                    Loopback Pseudo-Interface 1                                1



  Here we use the switch parameter "-AllInterfaces" in order to display all interfaces that have some type of IP Address associated with them.  

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-IPConfig.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-02-23 | Various improvements for displaying properties
  Dependencies: 
  Notes:
  - This was helpful in describing a good syntax to reference "IPEnabled=TRUE" interfaces:  https://www.itprotoday.com/powershell/working-ipv4-addresses-powershell
  - This was where I originally found the reference for the article above (the "itprotoday.com" article); this along with the article above is a good reference for using the [IPAddress] Type Accelerator, and for using the "Bitwise AND" operator to convert IPv4 strings into 32 bit number IPv4 Objects:  https://stackoverflow.com/questions/51296568/powershell-convert-ip-address-to-subnet
  - The original reference for creating a "$defaultDisplayPropertySet" (Kirk Munro): http://poshoholic.com/2008/07/05/essential-powershell-define-default-properties-for-custom-objects/
  - Another reference for creating a "$defaultDisplayPropertySet" (Boe Prox): https://learn-powershell.net/2013/08/03/quick-hits-set-the-default-property-display-in-powershell-on-custom-objects/

  # ADD -CIMCESSION
  # ADD -ComputerName
  # ADD -PSSession
  .
#>
function Get-IPConfig {
  [CmdletBinding()]
  [Alias('ipa')]
  param (
    [Parameter(HelpMessage='This Switch Parameter is used to display all network adapters. If this Switch Parameter is not used, the default configuration for the function will be in effect, and only interfaces where "IPEnabled=TRUE" will be returned.')]
    [switch]
    $AllInterfaces
  )
  
  begin {}
  
  process {

    if ($AllInterfaces) {
      $LoopThroughTheseIPAddresses = Get-NetIPAddress
    }
    else {
      $TheseIndicesOnly = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE").InterfaceIndex
      $LoopThroughTheseIPAddresses = Get-NetIPAddress | ? InterfaceIndex -in $TheseIndicesOnly
    }

    foreach ($Address in $LoopThroughTheseIPAddresses) {
      
      $CimNetAdapterConfig = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "InterfaceIndex=$($Address.InterfaceIndex)"
      $NetConnectionProfile = Get-NetConnectionProfile | ? InterfaceIndex -eq $Address.InterfaceIndex  #| Select-Object Name,NetworkCategory  # THESE WERE THE PROPERTIES OF INTEREST #
      #$DnsClientServerAddress = Get-DnsClientServerAddress | ? InterfaceIndex -eq $Address.InterfaceIndex  #| Select-Object ServerAddresses  <# WE USED THE "DnsServerSearchOrder" PROPERTY INSTEAD, SO WE NO LONGER NEEDED THIS COMMAND#>
      $NetAdapter = Get-NetAdapter | ? InterfaceIndex -eq $Address.InterfaceIndex #| Select-Object InterfaceDescription, LinkSpeed  # THESE WERE THE PROPERTIES OF INTEREST #
      #$DnsClient = Get-DnsClient | ? InterfaceIndex -eq $Address.InterfaceIndex  #| Select-Object ConnectionSpecificSuffix  <# WE USED THE "DNSDomain" PROPERTY INSTEAD, SO WE NO LONGER NEEDED THIS COMMAND#>

      $prop = [ordered]@{
    
        ConnectionProfileName = $NetConnectionProfile.Name
        NetworkCategory = $NetConnectionProfile.NetworkCategory

        InterfaceAlias = $Address.InterfaceAlias
        InterfaceIndex = $Address.InterfaceIndex
        NetworkOrigin = $Address.PrefixOrigin

        IPAddress = $Address.IPAddress
        DefaultIPGateway = try { $CimNetAdapterConfig.DefaultIPGateway } catch {};
        NetMaskCIDR = $Address.PrefixLength
        NetMask = try { $CimNetAdapterConfig.IPSubnet[0] } catch {};  # The [0] removes the brackets "{ }" around the output.  I did this because there should be only one value per IP Address, so having the output in a collection is not necessary.
        
        DnsDomain = try { $CimNetAdapterConfig.DNSDomain } catch {};
        DnsServersAndSearchOrder = try { $CimNetAdapterConfig.DnsServerSearchOrder } catch {}; 
        DnsDomainSuffixSearchOrder = try { $CimNetAdapterConfig.DNSDomainSuffixSearchOrder } catch {};         
        
        InterfaceDescription = try { $CimNetAdapterConfig.Description } catch {};
        MacAddress = try { $CimNetAdapterConfig.MACAddress } catch {};
        LinkSpeed = $NetAdapter.LinkSpeed

        DhcpEnabled = try { $CimNetAdapterConfig.DHCPEnabled } catch {};
        DhcpServer = try { $CimNetAdapterConfig.DHCPServer } catch {};
        DhcpLeaseObtained = try { $CimNetAdapterConfig.DHCPLeaseObtained } catch {};
        DhcpLeaseExpires = try { $CimNetAdapterConfig.DHCPLeaseExpires } catch {};
      
      } 
  
      $obj = New-Object -TypeName psobject -Property $prop

      # This code allows us to select which properties to display by default.  I only chose 4 properties, in order keep the output format in a "Table View".  If there are 5 or more properties the default is a "List View".
      $defaultProperties = @( 'IPAddress','InterfaceAlias','DefaultIPGateway','InterfaceIndex' )
      $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet',[string[]]$defaultProperties)
      $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
      $obj | Add-Member MemberSet PSStandardMembers $PSStandardMembers
  
      Write-Output $obj
    }
  
  }
  
  end {}
}