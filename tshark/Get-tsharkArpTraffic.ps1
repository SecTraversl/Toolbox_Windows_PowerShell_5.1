<#
.SYNOPSIS
  The "Get-tsharkArpTraffic" function takes a packet capture and outputs metadata of the packets retrieved by the "arp" Display Filter in tshark/Wireshark.

.DESCRIPTION
.EXAMPLE
  PS C:\> *ArpTra <tab>
  PS C:\> Get-tsharkArpTraffic

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "*ArpTra" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Arp = Get-tsharkArpTraffic -Pcap .\myTest.pcap
  PS C:\> $arp | select IPSrc,MacSrc,MacSrcResolved,IPDst,MacDst,MacDstResolved,Info | ft

  IPSrc        MacSrc            MacSrcResolved                                   IPDst           MacDst            MacDstResolved
  -----        ------            --------------                                   -----           ------            --------------
  10.44.29.3   00:1c:7f:3c:42:92 Check Point Software Technologies                10.44.29.235    00:00:00:00:00:00 Universal Global Scientific In...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 10.44.29.3      00:1c:7f:3c:42:92 Check Point Software Technologies
  10.44.29.1   00:1c:7f:00:00:14 Check Point Software Technologies                10.44.29.1      00:00:00:00:00:00
  10.44.29.3   00:1c:7f:3c:42:92 Check Point Software Technologies                10.44.29.235    00:00:00:00:00:00 Universal Global Scientific In...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 10.44.29.3      00:1c:7f:3c:42:92 Check Point Software Technologies
  10.44.29.3   00:1c:7f:3c:42:92 Check Point Software Technologies                10.44.29.235    00:00:00:00:00:00 Universal Global Scientific In...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 10.44.29.3      00:1c:7f:3c:42:92 Check Point Software Technologies
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00
  10.44.29.1   00:1c:7f:00:00:14 Check Point Software Technologies                10.44.29.1      00:00:00:00:00:00
  10.44.29.3   00:1c:7f:3c:42:92 Check Point Software Technologies                10.44.29.235    00:00:00:00:00:00 Universal Global Scientific In...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 10.44.29.3      00:1c:7f:3c:42:92 Check Point Software Technologies



  Here we run the function by simply referencing the .pcap we want to examine.  We then select various properties that we want displayed.  This syntax allows us to see properties such as the source/destination IP Address, the source/destination MAC addresses, the resolved MAC Vendor based on the OUI, and the Info column (not displayed because of truncation).

.EXAMPLE
  PS C:\> Get-tsharkArpTraffic -Pcap .\myTest.pcap -DontShowTimestamp -NoMacResolution  | ft *

  IPSrc        MacSrc            IPDst           MacDst            Info                                       ArpProtoType ProtoSize HwSize HwType ArpOpcode
  -----        ------            -----           ------            ----                                       ------------ --------- ------ ------ ---------
  10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3      0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82       0x00000800   4         6      1      2
  10.44.29.1   00:1c:7f:00:00:14 10.44.29.1      00:00:00:00:00:00 ARP Announcement for 10.44.29.1            0x00000800   4         6      1      1
  10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3      0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82       0x00000800   4         6      1      2
  10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3      0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82       0x00000800   4         6      1      2
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235 0x00000800   4         6      1      1
  10.44.29.1   00:1c:7f:00:00:14 10.44.29.1      00:00:00:00:00:00 ARP Announcement for 10.44.29.1            0x00000800   4         6      1      1
  10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3      0x00000800   4         6      1      1
  10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82       0x00000800   4         6      1      2



  Here we run the function by referencing the switch parameter "-DontShowTimestamp" to remove the Date/Time field from the results and "-NoMacResolution" in order to omit the Source and Destination MAC Address OUI Resolution properties.  The output contains information retrieved using the "arp" Display Filter in tshark/Wireshark.  Key aspects of the output include the Info, IPSrc, MacSrc, IPDst, and MacDst properties. 

.EXAMPLE
  PS C:\> Get-tsharkArpTraffic -Pcap .\myTest.pcap -NoMacResolution -TimeDisplay UTC  | ft *

  DateTime                   IPSrc        MacSrc            IPDst           MacDst            Info
  --------                   -----        ------            -----           ------            ----
  2020-12-30 02:09:30.401799 10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3
  2020-12-30 02:09:30.401818 10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82
  2020-12-30 02:09:37.140675 10.44.29.1   00:1c:7f:00:00:14 10.44.29.1      00:00:00:00:00:00 ARP Announcement for 10.44.29.1
  2020-12-30 02:09:58.793936 10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3
  2020-12-30 02:09:58.793959 10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82
  2020-12-30 02:10:27.174937 10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3
  2020-12-30 02:10:27.174955 10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82
  2020-12-30 02:10:28.171285 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:29.066755 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:30.066742 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:31.172019 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:32.066778 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:33.066756 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10.44.184863 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:35.066683 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:36.066653 10.44.29.235 cc:52:af:3e:4e:82 169.254.255.255 00:00:00:00:00:00 Who has 169.254.255.255? Tell 10.44.29.235
  2020-12-30 02:10:37.132004 10.44.29.1   00:1c:7f:00:00:14 10.44.29.1      00:00:00:00:00:00 ARP Announcement for 10.44.29.1
  2020-12-30 02:10:55.566022 10.44.29.3   00:1c:7f:3c:42:92 10.44.29.235    00:00:00:00:00:00 Who has 10.44.29.235? Tell 10.44.29.3
  2020-12-30 02:10:55.566032 10.44.29.235 cc:52:af:3e:4e:82 10.44.29.3      00:1c:7f:3c:42:92 10.44.29.235 is at cc:52:af:3e:4e:82



  Here we run the function by specifying the "-TimeDisplay" format to be in 'UTC' (if "-TimeDisplay" is not specified, the default is to use "LocalTime") and "-NoMacResolution" in order to omit the Source and Destination MAC Address OUI Resolution properties.

.EXAMPLE
  PS C:\> Get-tsharkArpTraffic -Pcap .\myTest.pcap -ArpTableView | ft *

  IPSrc        MacSrc            MacSrcResolved                                   IPDst           MacDst            MacDstResolved                                   Info
  -----        ------            --------------                                   -----           ------            --------------                                   ----
  10.44.29.1   00:1c:7f:00:00:14 Check Point Software Technologies                10.44.29.1      00:00:00:00:00:00                                                  ARP...
  10.44.29.3   00:1c:7f:3c:42:92 Check Point Software Technologies                10.44.29.235    00:00:00:00:00:00 Universal Global Scientific Industrial Co., Ltd. Who...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 169.254.255.255 00:00:00:00:00:00                                                  Who...
  10.44.29.235 cc:52:af:3e:4e:82 Universal Global Scientific Industrial Co., Ltd. 10.44.29.3      00:1c:7f:3c:42:92 Check Point Software Technologies                10....



  Here we specify the switch paramater of "-ArpTableView" which returns the unique Source and Destination MAC address pairs found in the packet capture, along with their corresponding IP addresses and the resolved MAC Address OUI.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkArpTraffic
  Author: Travis Logue
  Version History: 1.0 | 2020-01-05 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in determining how to get the 'DateTime' field to the desired format: https://ask.wireshark.org/question/16830/tshark-frametime-format/
  - This was helpful in determining how to get the 'Info' column field : https://osqa-ask.wireshark.org/questions/35609/how-to-print-information-field


  .
#>
function Get-tsharkArpTraffic {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the .pcap file to analyze.')]
    [Alias("r")]
    [string]
    $Pcap,
    [Parameter(HelpMessage='This Switch Parameter is used to remove the "MacResolved" fields from the output')]
    [Alias("n")]
    [switch]
    $NoMacResolution,
    [Parameter(HelpMessage='This Switch Parameter is used to remove the "Date/Timestamp" Field from the output.')]
    [switch]
    $DontShowTimestamp,
    [Parameter(HelpMessage='This paramater contains a Validate Set Attribute. The following options are available: "LocalTime","UTC". The default selection is "LocalTime". You may use the <tab> key to toggle through the available option or to auto-complete.')]
    [ValidateSet("LocalTime","UTC")]
    [Alias("t")]
    [string]
    $TimeDisplay = "LocalTime",
    [Parameter(HelpMessage='This Switch Parameter is used in order to get a sorted output of unique source and destination MAC Addresses along with their matching IP Addresses and the resolved OUI indicating the NIC manufacturer / MAC Vendor.')]
    [switch]
    $ArpTableView
  )
  
  begin {}
  
  process {

    if ($ArpTableView) {

      $ArpConvos = tshark.exe -r $Pcap -Y arp -T fields -e arp.src.proto_ipv4 -e arp.src.hw_mac -e eth.src.oui_resolved -e arp.dst.proto_ipv4 -e arp.dst.hw_mac -e eth.dst.oui_resolved -e _ws.col.Info 
  
      $ObjectForm = $ArpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'IPSrc','MacSrc','MacSrcResolved','IPDst','MacDst','MacDstResolved','Info'

      $ObjectForm = $ObjectForm | Sort-Object MacSrc,MacDst -Unique
      
    }
    else {
      
      switch ($TimeDisplay) {
        "LocalTime" { $TimeFormat = "ad" }
        "UTC" { $TimeFormat = "ud" }
      }
  
      if ($NoMacResolution -and $DontShowTimestamp) {
        $ArpConvos = tshark.exe -r $Pcap -Y arp -T fields -e arp.src.proto_ipv4 -e arp.src.hw_mac -e arp.dst.proto_ipv4 -e arp.dst.hw_mac -e _ws.col.Info -e arp.proto.type -e arp.proto.size -e arp.hw.size -e arp.hw.type -e arp.opcode 
  
        $ObjectForm = $ArpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'IPSrc','MacSrc','IPDst','MacDst','Info','ArpProtoType','ProtoSize','HwSize','HwType','ArpOpcode'
      }
      elseif ($NoMacResolution) {
        $ArpConvos = tshark.exe -r $Pcap -Y arp -T fields -t $TimeFormat -e _ws.col.Time -e arp.src.proto_ipv4 -e arp.src.hw_mac -e arp.dst.proto_ipv4 -e arp.dst.hw_mac -e _ws.col.Info -e arp.proto.type -e arp.proto.size -e arp.hw.size -e arp.hw.type -e arp.opcode 
  
        $ObjectForm = $ArpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'DateTime','IPSrc','MacSrc','IPDst','MacDst','Info','ArpProtoType','ProtoSize','HwSize','HwType','ArpOpcode'
      }
      elseif ($DontShowTimestamp) {
        $ArpConvos = tshark.exe -r $Pcap -Y arp -T fields -e arp.src.proto_ipv4 -e arp.src.hw_mac -e eth.src.oui_resolved -e arp.dst.proto_ipv4 -e arp.dst.hw_mac -e eth.dst.oui_resolved -e _ws.col.Info -e arp.proto.type -e arp.proto.size -e arp.hw.size -e arp.hw.type -e arp.opcode 
  
        $ObjectForm = $ArpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'IPSrc','MacSrc','MacSrcResolved','IPDst','MacDst','MacDstResolved','Info','ArpProtoType','ProtoSize','HwSize','HwType','ArpOpcode'
      }
      else {
        $ArpConvos = tshark.exe -r $Pcap -Y arp -T fields  -t $TimeFormat -e _ws.col.Time -e arp.src.proto_ipv4 -e arp.src.hw_mac -e eth.src.oui_resolved -e arp.dst.proto_ipv4 -e arp.dst.hw_mac -e eth.dst.oui_resolved -e _ws.col.Info -e arp.proto.type -e arp.proto.size -e arp.hw.size -e arp.hw.type -e arp.opcode 
  
        $ObjectForm = $ArpConvos | ConvertFrom-Csv -Delimiter "`t" -Header 'DateTime','IPSrc','MacSrc','MacSrcResolved','IPDst','MacDst','MacDstResolved','Info','ArpProtoType','ProtoSize','HwSize','HwType','ArpOpcode'
      }

    }

    Write-Output $ObjectForm

  }
  
  end {}
}