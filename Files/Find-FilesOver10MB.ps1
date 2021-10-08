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
  Name: Find-FilesOver10MB.ps1
  Author: Travis Logue
  Version History: 4.0 | 2021-02-14 | Casted the "FileSizeMB" as a Double; Added "Extension" property; Added param "GetStatsByFileExtension"
  Dependencies: 
  Notes:


  .
#>
function Find-FilesOver10MB {
  [CmdletBinding()]
  param (
    [Parameter()]
    [psobject]
    $GetStatsByFileExtension
  )
  
  begin {}
  
  process {

    if ($GetStatsByFileExtension) {
      
      $ExtensionList = $GetStatsByFileExtension | Select-Object Extension -Unique

      $StatsByExtension = foreach ($Extension in $ExtensionList) {
        $joiner = $FilesOver10MB | ? Extension -eq $Extension
        $joiner | ? {$_} -PipelineVariable orig | Measure-Object -Property FileSizeMB -Sum | % {
          $prop = [ordered]@{
            Count = $_.Count
            Sum = $_.Sum
            Property = $_.Property
            Extension = $orig.Extension
          }

          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }

      $StatsByExtension | Sort-Object Sum -Descending


    }
    else {

      Write-Host "`nThis could take between 10 (128 GB harddrive) to 40 minutes (512 GB harddrive) and often returns 1300 to 1600 files.`n" -BackgroundColor Black -ForegroundColor Yellow

      $FilesOver10MB = "FOR /R c:\ %i in (*) do @if %~zi gtr 10000000 echo %i %~zi" | cmd.exe
      $TrimTop = $FilesOver10MB | Select-Object -Skip 4
      $TrimBottom = $TrimTop | Select-Object -SkipLast 2
  
  
      $CreatedObjects = foreach ($item in $TrimBottom) {
  
        $IsolatedFileSizeInBytes = (($item -split " ")[-1])
        $SizeInMBAndHaving2DecimalPlaces = "{0:f2}" -f ([Math]::Round([Math]::Ceiling(($IsolatedFileSizeInBytes/1MB) * 100) / 100, 2))
        $FullPath = $item -replace " \d{6,}$"
        $Extension = ($FullPath | Split-Path -Leaf) -replace ".*\.","."
  
  
        $prop = [ordered]@{
          FileSizeMB = [double]$SizeInMBAndHaving2DecimalPlaces
          FullPath = $FullPath
          Extension = $Extension
        }
  
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
  
      $CreatedObjects | Sort-Object FileSizeMB -Descending
      
    }



  }
  
  end {}
}