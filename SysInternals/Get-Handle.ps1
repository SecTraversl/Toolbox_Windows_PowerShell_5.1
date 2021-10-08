

<#
.SYNOPSIS
  *REQUIRES*: "Add-Handle2PathScript.ps1" to be loaded in memory and callable.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Another way "to find which File is in use by another program" is well articulated here: https://www.youtube.com/watch?v=bTGrE2OjRJQ
  - Code Doge uses Resource Monitor > CPU tab > Associated Handles section > type the "partial path" into the search bar in this section
  - A really excellent way to 1. See the process/application that is using a file  2. See the PID for that application  3. Associate that application with the file that is "locked" or "in use"  4. and to right-click and kill the application
#>

function Get-Handle {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference a partial path "handled" object.  This is useful when a file is "being used by another process" and you want to enter in a full or partial path of the locked file in order to see what Application / Process is "using" that file.')]
    [ParameterType]
    $PartialPathMatch
  )
  
  begin {
    Add-Handle2PathScript -RunScript
  }
  
  process {
    handle64.exe $PartialPathMatch
  }
  
  end {}
}