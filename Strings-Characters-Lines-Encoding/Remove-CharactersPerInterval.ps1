

function Remove-CharactersPerInterval {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the string you want to remove characters from. The first Character is always kept.')]
    [string]
    $String,
    [Parameter(HelpMessage='Enter the interval to skip. The default value is "2".')]
    [int]
    $Interval = 2
  )
  
  begin {
    
  }
  
  process {
    $i = 0
    $FinalWord = ''  
    while ($i -le $String.Length) {
      $FinalWord += $String[$i]
      $i += $Interval
    }
    Write-Output $FinalWord
  }
  
  end {
    
  }
}