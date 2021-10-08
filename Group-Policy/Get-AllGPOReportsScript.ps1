

function Get-AllGPOReportsScript {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'This is a script. If you want to run the script, use this $RunScript switch parameter')]
    [switch]
    $RunScript
  )
  
  begin {}
  
  process {
    if ($RunScript) {
      Get-GPOReport -All -Domain 'corp.coinstar.com' -ReportType Html -Path "$pwd\GPOReportsAll.html"
    }
  }
  
  end {}
}