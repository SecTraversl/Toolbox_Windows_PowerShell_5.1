

function Get-MacAddressesWithTshark {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the path of the Tshark executable')]
    [string]
    $tshark,
    [Parameter(HelpMessage = 'Reference the path to the packet capture')]
    [string]
    $pcap
  )
  
  begin {}
  
  process {
    (& "$tshark" -r $pcap -T fields -e eth.addr) -split ',' | Sort-Object -Unique
  }
  
  end {}
}


