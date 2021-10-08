



function Get-MacVendor {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the MAC address(es) that you want to look up.')]
    [string[]]
    $MacAddresses
  )
  
  begin {}
  
  process {
    $OUIs = $MacAddresses | % { $_ -replace ":\w\w:\w\w:\w\w$" } | Sort-Object -Unique

    foreach ($OUI in $OUIs) {
      Start-Sleep -Seconds 1 #Required by API docs from MacVendors.com/api
      $base_url = 'https://api.macvendors.com'
      $url_endpoint = '/' + $OUI
      $url = $base_url + $url_endpoint

      try {
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -Headers $header -ErrorVariable $err
      }
      catch [System.Net.WebException] {
        $response = $null
      }

      $prop = [ordered]@{
        OUI    = $OUI
        Vendor = $response
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }

  }
  
  end {}
}