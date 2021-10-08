

# Requires
# - PECmd from Eric Zimmerman

function Analyze-PrefetchPECmdCsv {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the path of the "PECmd_Output.csv"', Mandatory=$true)]
    [string]
    $PECmd_Output_CSV
  )
  
  begin {
    $ImportedCSV = Import-Csv -Path $PECmd_Output_CSV
  }
  
  process {
    foreach ($item in $ImportedCSV) {

      # NOTES ON THESE NEXT LINES OF CODE
      #	0. We had to separate the "FilesLoaded" property into individual objects; we did so by adding a "`n" to the beginning and then splitting the 1 long string into separate String Objects with ' -split "`n" '
      # 1. I broke these portions up into multiple variables because I was getting an error
	    # 2. By working through some examples we came up with this final solution that rendered no Errors
	    # 3. There was some extra White Space at the end that we removed with the method .Trim() {by default this removes beginning and ending White Space
      # 4 We also removed the trailing "," with .TrimEnd(',')
      
      $ExecutableName = $item.ExecutableName
      $ModifiedExecutableName = $ModifiedExecutableName = $ExecutableName + ', '
      $FilesLoaded = (($item).filesloaded -replace "\\VOLUME","`n\VOLUME").Substring(1) -split "`n"
      $FilePath = ($FilesLoaded | ? {$_ -like "*$ModifiedExecutableName"})
      
      $FinalFilePath = if ($null -notlike $FilePath) {
        $FilePath.Trim().TrimEnd(',')
      } else {
        $null
      }
      

      $prop = [ordered]@{
        ExecutableName = $item.ExecutableName
        Hash = $item.Hash
        Size = $item.Size
        FirstRun = $item.SourceCreated
        RunCount = $item.RunCount
        LastRun = $item.LastRun
        PreviousRun0 = $item.PreviousRun0
        PreviousRun1 = $item.PreviousRun1
        PreviousRun2 = $item.PreviousRun2
        PreviousRun3 = $item.PreviousRun3
        PreviousRun4 = $item.PreviousRun4
        PreviousRun5 = $item.PreviousRun5
        PreviousRun6 = $item.PreviousRun6
        FilePath = $FinalFilePath
        Version = $item.Version     
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
    Write-Host "`n`nDON'T FORGET that with Prefetch, subtract about -10 seconds from the property entitled 'FirstRun' to derive the very first true Execution time. `nThis is a 'derived time' based off of the source creation of the .pf file itself. `nThe other times listed (LastRun and PreviousRun#) are embedded within the file and are already accurate. `n`n" -ForegroundColor Green -BackgroundColor Black
  }
  
  end {
    
  }
}