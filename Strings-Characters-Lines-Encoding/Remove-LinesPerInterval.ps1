

function Remove-LinesPerInterval {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Object you want to remove Lines from. The first Line is always kept.')]
    [psobject]
    $Array,
    [Parameter(HelpMessage='Enter the interval to skip. The default value is "2".')]
    [int]
    $Interval = 2
  )
  
  begin {}
  
  process {
    $i = 0
    $FinalArray = @()
    while ($i -le $Array.Count) {
      $FinalArray += $Array[$i]
      $i += $Interval
    }
    Write-Output $FinalArray
  }
  
  end {}
}