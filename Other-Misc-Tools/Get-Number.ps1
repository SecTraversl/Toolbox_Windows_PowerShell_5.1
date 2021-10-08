

function Get-Number {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Reference the Array of numeric values")]
    [array]
    $Array,
    [Parameter(HelpMessage="Switch Parameter used to display the Highest Number of the Array")]
    [switch]
    $Highest,
    [Parameter(HelpMessage="Switch Parameter used to display the Lowest Number of the Array")]
    [switch]
    $Lowest

  )
  
  begin {
    $ValueOfInterest = $Array[0]
  }
  
  process {
    if ($Highest) {
      foreach ($item in $Array) {
        if ($item -gt $ValueOfInterest) {
          $ValueOfInterest = $item
        }
      }
      Write-Output $ValueOfInterest
    }
    if ($Lowest) {
      foreach ($item in $Array) {
        if ($item -lt $ValueOfInterest) {
          $ValueOfInterest = $item
        }
      }
      Write-Output $ValueOfInterest
    }
  }
  
  end {
    
  }
}