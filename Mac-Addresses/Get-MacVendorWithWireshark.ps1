

function Get-MacVendorWithWireshark {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the MAC address(es) that you want to look up.')]
    [string[]]
    $MacAddresses,
    [Parameter(HelpMessage = 'Reference the MAC Address .CSV derived from "https://gitlab.com/wireshark/wireshark/-/raw/master/manuf"')]
    [string]
    $WiresharkMacLookupCsv
  )
  
  begin {
    #$WiresharkMacTable = ipcsv $WiresharkMacLookupCsv
    $Hashtable = @{}
    Import-Csv .\WiresharkMacLookup.csv | % { $Hashtable[$_.OUI] = $_.Description }
  }
  
  process {
    $OUIs = $MacAddresses | % { $_ -replace ":\w\w:\w\w:\w\w$" } | Sort-Object -Unique

    foreach ($OUI in $OUIs) {
      $prop = [ordered]@{
        OUI    = $OUI
        Vendor = $Hashtable[$OUI]
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }

  }
  
  end {}
}
