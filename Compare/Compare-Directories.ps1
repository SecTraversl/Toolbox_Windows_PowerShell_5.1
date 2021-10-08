<#
.SYNOPSIS
  A tool specifically built for comparing Directories.  REQUIREMENT - In order to work properly, this function must be able to call: Get-DirectoryContents.ps1

.EXAMPLE
  PS C:\> Compare-Directories -ReferencePath .\ps1_files\ps1_files\ -DifferencePath .\ps1_files.old\ps1_files\

  InputObject                           Position1              Indicator Position2
  -----------                           ---------              --------- ---------
  Create-PSProfile.ps1                                         =>        .\ps1_files.old\ps1_files\
  Type-Extension\My.Types.ps1xml_OLD                           =>        .\ps1_files.old\ps1_files\
  Profile                               .\ps1_files\ps1_files\ <=
  Backups\Backup-Files.ps1              .\ps1_files\ps1_files\ <=
  Backups\Backup-Ps1Files.ps1           .\ps1_files\ps1_files\ <=
  Profile\Create-PSProfile.ps1          .\ps1_files\ps1_files\ <=
  Type-Extension\My.Types.ps1xml_OLD_v1 .\ps1_files\ps1_files\ <=

  EXAMPLE 1: In this example we give the function a relative path for both the "-ReferencePath" and the "-DifferencePath". This function is similar to the output of Compare-Object, but with the additional context

  
#>

function Compare-Directories {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Specifies an array of objects used as a reference for comparison.')]
    [psobject]
    $ReferencePath,
    [Parameter(HelpMessage = 'Specifies the objects that are compared to the reference objects.')]
    [psobject]
    $DifferencePath
  )
  
  begin {

    $Reference = Get-DirectoryContents -Directory $ReferencePath -Recurse
    $Difference = Get-DirectoryContents -Directory $DifferencePath -Recurse

  }
  
  process {
    $CompareResults = Compare-Object $Reference $Difference
    # It appears that the default behavior of using Compare-Object this way is equivalent to:
    # -   $CompareResults = Compare-Object $Reference.Name $Difference.Name


    $CompareResults | % {

      $Position1 = $null
      $Position2 = $null

      if ($_.SideIndicator -eq '<=') {
        $Position1 = $ReferencePath
      }

      if ($_.SideIndicator -eq '=>') {
        $Position2 = $DifferencePath
      }    

      $prop = [ordered]@{
        InputObject    = $_.InputObject
        ReferencePath  = $Position1
        Indicator      = $_.SideIndicator
        DifferencePath = $Position2
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }    
  }
  
  end {}

}