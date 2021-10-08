<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  General notes
#>
function Invoke-BraveBrowser {
  [CmdletBinding()]
  [Alias('BraveBrowser')]
  param (
    [Parameter()]
    [switch]
    $NoExperiments,
    [Parameter()]
    [switch]
    $DisableExtensions
  )
  
  begin {}
  
  process {
    $Exe = 'C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe'
    $param = @('--incognito')

    if ($NoExperiments) {
      $param += @('--no-experiments')
    }
    
    if ($DisableExtensions) {
      $param += @('--disable-extensions')
    }

    & $Exe $param
  }
  
  end {}
}