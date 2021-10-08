
# Should take 20 seconds or less

function Get-MacVendorHashtableWithWiresharkMacLookupTable {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    $Hashtable = @{}
    $path = ".\WiresharkMacLookup.csv"

    Import-Csv -Path $path | % { $Hashtable[$_.OUI] = $_.Description }

    Write-Output $Hashtable
  }
  
  end {}
}