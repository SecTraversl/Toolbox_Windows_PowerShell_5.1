
<#
.SYNOPSIS
  The "Invoke-FindStrSearch" function is a wrapper for 'findstr.exe' allowing for simple string searches to be conducted for specific files, the current directory, or recursively.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Invoke-FindStrSearch.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-08 | Initial Version
  Dependencies: findstr.exe
  Notes:
  - This was helpful in determining the correct syntax for searching for a phrase in multiple documents, recursively: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr#examples

  - This was helpful in understanding some nuances of using "findstr" under CMD.exe versus PowerShell.exe -- by default if using findstr.exe with default $OutputEncoding of PowerShell, you won't find Unicode text - look under the header of "Finding Unicode Text under PowerShell" for info and how to make a change to find Unicode text when using 'findstr.exe' under PowerShell:  https://ss64.com/nt/findstr.html

  - I ended up finding a tool in order to "Get-FileEncoding" in order to do proper comparisons of what I could / could not search for strings in a given file (I could not find strings that were there in the file when I was using Findstr.exe in PowerShell when that file had Unicode encoded content)

  . 
#>
function Invoke-FindStrSearch {
  [CmdletBinding()]
  [Alias('FindStrSearch')]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $String,
    [Parameter()]
    [string]
    $Filter = '*.*',
    [Parameter()]
    [switch]
    $Recurse,
    [Parameter()]
    [switch]
    $CaseSensitive
  )
  
  begin {}
  
  process {

    # This will allow you to capture Unicode text
    # $OutputEncoding = UnicodeEncoding

    # Anothe way to catpure Unicode text - this will match the console's encoding:
    $OutputEncoding = [Console]::OutputEncoding

    $params = @()

    # Here is what we are basically modeling:
    #   findstr /s /i "$String" *.*

    $cmd = 'findstr.exe'

    if ($Recurse) {
      $params += '/s'
    }

    if ($CaseSensitive) {
      $null
    }
    else {
      $params += '/i'
    }

    $params += "`"$String`""
    $params += $Filter
    & $cmd $params
  }
  
  end {}
}