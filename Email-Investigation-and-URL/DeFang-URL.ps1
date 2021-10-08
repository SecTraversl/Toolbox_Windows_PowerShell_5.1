

function DeFang-URL {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Paste in the URL string here...")]
    [String]
    $String
  )
  
  begin {
    
  }
  
  process {
    $Result = $String -replace "http","hxxp"
  }
  
  end {
    Write-Output $Result
  }
}