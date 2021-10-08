<#
.SYNOPSIS
  This is a PowerShell wrapper for "findstr.exe".
.DESCRIPTION
.EXAMPLE
  PS C:\ps1_files>  Invoke-FindStrRecursiveSearch -String nslookup-plus
  DNS\NsLookup-Plus.ps1:  - For, While, If - NsLookup-Plus string matching logic and notes.ps1
  DNS\NsLookup-Plus.ps1:function NsLookup-Plus {
  DNS\NsLookup-Plus_OLD_v1.txt:  - For, While, If - NsLookup-Plus string matching logic and notes.ps1
  DNS\NsLookup-Plus_OLD_v1.txt:function NsLookup-Plus {
  Notes - For, While, If - NsLookup-Plus string matching logic and notes.txt:function NsLookup-Plus {
  Notes - For, While, If - NsLookup-Plus string matching logic and notes.txt:function NsLookup-Plus2 {

  Here we are in the "ps1_files" directory recursively looking for the string "nslookup-plus" within any of the files

.INPUTS
.OUTPUTS
.NOTES
  Name:  Invoke-FindStrRecursiveSearch.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-09 | Updated information and notes
  Dependencies: 
  Notes:
  - This was helpful in determining the correct syntax for searching for a phrase in multiple documents, recursively: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr#examples

  - This was helpful in understanding some nuances of using "findstr" under CMD.exe versus PowerShell.exe -- by default if using findstr.exe with default $OutputEncoding of PowerShell, you won't find Unicode text - look under the header of "Finding Unicode Text under PowerShell" for info and how to make a change to find Unicode text when using 'findstr.exe' under PowerShell:  https://ss64.com/nt/findstr.html

  - I ended up finding a tool in order to "Get-FileEncoding" in order to do proper comparisons of what I could / could not search for strings in a given file (I could not find strings that were there in the file when I was using Findstr.exe in PowerShell when that file had Unicode encoded content)


  . 
#>
function Invoke-FindStrRecursiveSearch {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $String
  )
  
  begin {}
  
  process {
    findstr /s /i "$String" *.*
  }
  
  end {}
}