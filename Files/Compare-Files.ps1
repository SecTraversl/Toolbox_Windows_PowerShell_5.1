

# See "Compare-PsProfileScript.ps1" for a good working model of this...

function Compare-Files {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Specifies the file to be used as a reference for comparison.')]
    [psobject]
    $ReferencePath,
    [Parameter(HelpMessage = 'Specifies the file to be compared to the reference file.')]
    [psobject]
    $DifferencePath,
    [Parameter(HelpMessage='Reference the PSSession to run the command on.')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {

    if ($Session) {
      $RemoteFile = Invoke-Command -Session $Session -ScriptBlock {
        Get-Content $DifferencePath
      }
      Compare-Object (Get-Content $ReferencePath) $RemoteFile
    }
    else {
      Compare-Object (Get-Content $ReferencePath) (Get-Content $DifferencePath)
    }   

  }
  
  end {}
}