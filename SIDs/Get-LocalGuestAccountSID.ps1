function Get-LocalGuestAccountSID {
  [CmdletBinding()]
  [Alias('LocalGuestSID')]
  param ()
  
  begin {}
  
  process {
    $LocalPrefix = Get-LocalUser | % { $_.SID -replace "-\d+$" } | Sort-Object -Unique
    $LocalGuestAccountSID = $LocalPrefix + "-501"
    Write-Output $LocalGuestAccountSID     
  }
  
  end {}
}