<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>
function Get-GPOInfo {
  [CmdletBinding()]
  [Alias('GPOInfo')]
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Name
  )
  
  begin {}
  
  process {
    foreach ($GPOName in $Name) {
      Get-GPO -Name $GPOName
    }
  }
  
  end {}
}