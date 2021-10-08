



function Resolve-IPAddress {
  [CmdletBinding()]
  param (
    [string[]]$IP
  )  
  
  begin {
    # Deemed unnecessary
    <#
    if ( $IP -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" ) {
      ...
    }
    else {
      Write-Output "Not an IP address"
    }
    #>    
  }

  process {

    foreach ($i in $IP) {
      $Results = cmd /c " nslookup $i "#  $Server "

      $PTR_Record = $Results | select -Skip 2 | ? { $_ }

      $Name = ($PTR_Record | sls name ) -replace "Name:\s+", ""
      [string]$IP = ($PTR_Record | sls address) -replace "Address:\s+", ""
    
      $prop = [ordered]@{
        "DnsName" = $Name
        "IP"      = $IP
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }   
    
  }  

  end {
  }
  
}