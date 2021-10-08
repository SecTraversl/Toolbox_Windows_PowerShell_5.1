

function Get-GPOPlus {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Domain
  )
  
  begin {}
  
  process {
    if ($Domain) {
      # Optionally, we can specify the Domain, though this is not necessary if we want the default Domain the computer is in
      Get-GPO -All -Domain $Domain
    }
    else {
      # It appears this gets all GPOs for the Domain of which the computer belongs
      Get-GPO -All
    }
  }
  
  end {}
}