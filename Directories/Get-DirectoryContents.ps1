
<#
.SYNOPSIS
  List out the contents of the directory - Output is a simple text list.

.NOTES
  This was valuable in that we are able to reference the contents of a $Variable to replace when using "replace()""; whereas we were not able to with "-replace".  Helpful link:  https://ss64.com/ps/replace.html
#>

function Get-DirectoryContents {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Directory within which you want to see the relative Fullname of the files and folders.')]
    [psobject]
    $Directory,
    [Parameter(HelpMessage='Switch Parameter to list contents recursively.')]
    [switch]
    $Recurse
  )
  
  begin {
    $AnchorDirName = (Get-Item $Directory).FullName
  }
  
  process {
    if ($Recurse) {
      $Results = (Get-ChildItem $Directory -Recurse).FullName
      $Results.Replace($AnchorDirName,'').TrimStart('\')
    }
    else {
      $Results = (Get-ChildItem $Directory).FullName
      $Results.Replace($AnchorDirName,'').TrimStart('\')
    }
  }
  
  end {}
}

