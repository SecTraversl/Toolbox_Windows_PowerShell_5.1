


# This is only the "Recyle Bin" proper... there are other files underneath the other SIDs in the $Recycle.Bin directory
# - $RecBin5726 = ls -Force 'C:\$Recycle.Bin\S-1-5-21-102932503-109117628-3773961456-57276\' 

<#
# Requires:
  - Remove-CharactersPerInterval.ps1

#>



function Analyze-RecycleBin {
  [CmdletBinding()]
  param (
    
  )
  
  begin {

    # Get all $I Files under the "C:\$Recycle.Bin\Recylce Bin" Directory 
    $RecBin5726 = Get-ChildItem -Force 'C:\$Recycle.Bin\S-1-5-21-102932503-109117628-3773961456-57276\'      
    $RecBin_I_Only = $RecBin5726 | Where-Object name -Like '$I*'   

  }
  
  process {

    $RecBinResults = foreach ($I_File in $RecBin_I_Only) {
      $joiner = $RecBin5726 | Where-Object {$_ -like  ('$R' + $($I_File.name.Substring(2) ) ) }
      $DeletedFileName = (Remove-CharactersPerInterval (Get-Content $I_File.FullName)).substring(14)
      $prop = [ordered]@{
        I_File = $I_File.Name
        R_File = $joiner.Name
        FileDeletionTime = $I_File.CreationTime
        FileCreationTime = $joiner.CreationTime
        FileLastWriteTime = $joiner.LastWriteTime
        FileLength = $joiner.Length        
        DeletedFileName = $DeletedFileName

      }
      New-Object -TypeName psobject -Property $prop      
    }
    
  }
  
  end {
    Write-Output $RecBinResults
  }
}