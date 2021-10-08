

function Get-DirSize {
  [CmdletBinding()]
  param (
      [Parameter(HelpMessage="Directory to start from; '-Recurse' is the default behavior")][string]$Directory=".",
      [Parameter(HelpMessage="Use this Switch Parameter to remove the '-Recurse' option")][switch]$NoRecurse,
      [Parameter(HelpMessage="Display KB, MB, and GB in output")][switch]$AllUnitsOfMeasure,
      [Parameter(HelpMessage="Display the 10 Largest files found in the recursive search")][switch]$TenLargest      
  )
  
  begin {
      $Tally = 0 
  }
  
  process {
      if ($NoRecurse) {
        $Files = Get-ChildItem -Force -Path $Directory -File

        foreach ($f in $Files) {
          $Tally += $f.Length
        }
      }
      elseif ($TenLargest) {        
        $Files = Get-ChildItem -Force -Recurse -Path $Directory -File

        $Results = foreach ($f in $Files) {
          $prop = [ordered]@{
              FullName = $f.FullName
              Length = $f.Length  
          }
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj  
        }
      }
      else {
        $Files = Get-ChildItem -Force -Recurse -Path $Directory -File

        foreach ($f in $Files) {
          $Tally += $f.Length
        }
      }  
  }
  
  end {
      if ($AllUnitsOfMeasure) {
        $props = [ordered]@{
          KB = "{0:f2}" -f  ([Math]::Round([Math]::Ceiling(($tally/1KB) * 100) / 100, 2))
          MB = "{0:f2}" -f  ([Math]::Round([Math]::Ceiling(($tally/1MB) * 100) / 100, 2))
          GB = "{0:f2}" -f  ([Math]::Round([Math]::Ceiling(($tally/1GB) * 100) / 100, 2))
        }
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
      }
      elseif ($TenLargest) {      

        $Sorted = $Results | Sort Length
        $sum = ($Sorted | measure -Property length -sum).sum
        $FormattedSum = "{0:f2}" -f ([Math]::Round([Math]::Ceiling(($sum / 1MB) * 100) / 100, 2))

        $Sorted[-1..-10] | 
        Select @{n='MB'; e={"{0:f2}" -f ([Math]::Round([Math]::Ceiling(($_.length / 1MB) * 100) / 100, 2))}},
        FullName
        
        Write-Output "`nSUM OF ALL FILES BENEATH THIS DIR = $FormattedSum GB"
      }
      else {
        
        $GB = "{0:f2}" -f  ([Math]::Round([Math]::Ceiling(($Tally/1GB) * 100) / 100, 2))

        $props = [ordered]@{
          GB = $GB
        }
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
      }
  }
}