
<#
.SYNOPSIS
  Creates a new SymLink to either a File or a Folder/Directory.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  - Great info here... if using PowerShell 5.0 or greater, New-Item has this new capability:
    New-Item -ItemType SymbolicLink -Path "C:\temp" -Name "calc.lnk" -Value "c:\windows\system32\calc.exe"
  - This was the helpful forum post that had that information: https://stackoverflow.com/questions/9701840/how-to-create-a-shortcut-using-powershell

  - Here is the official Microsoft example and documentation: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item?view=powershell-7
    *  
    $link = New-Item -ItemType SymbolicLink -Path .\link -Value .\Notice.txt
    $link | Select-Object LinkType, Value

#>

function New-SymLink {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the name you want to give the Symbolic Link')]
    [string]
    $SymLinkName,
    [Parameter(HelpMessage='Reference the target file/folder at which the Symbolic Link will point')]
    [string]
    $TargetPath
  )
  
  begin {}
  
  process {
    New-Object -ItemType SymbolicLink -Path $Path -Value $TargetPath
  }
  
  end {}
}