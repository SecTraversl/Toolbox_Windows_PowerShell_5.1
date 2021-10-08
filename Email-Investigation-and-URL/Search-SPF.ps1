

function Search-SPF {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Domain name of the source email.')]
    [string]
    $Domain
  )
  
  begin {}
  
  process {
    $TXT_Results = Resolve-DnsName $Domain -Type TXT

    $SPF_Strings = $TXT_Results | ? { $_.Strings -like "v=spf*" }

    if ($null -like $SPF_Strings) {
      Write-Host "`nNo SPF entries found in the TXT records for: $Domain`n" -BackgroundColor Black -ForegroundColor Magenta
      break
    }

    

  }
  
  end {}
}