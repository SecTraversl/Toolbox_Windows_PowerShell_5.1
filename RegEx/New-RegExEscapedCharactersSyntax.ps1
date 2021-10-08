<#
.SYNOPSIS
  The "New-RegExEscapedCharactersSyntax" function takes a given string and returns a modified string where RegEx special characters are escaped, thereby allowing you to take the modified string syntax and literally match it with a RegEx pattern match.

.DESCRIPTION
.EXAMPLE
  PS C:\> RegExEscaped '3.\d{2,}'
  3\.\\d\{2,}

  PS C:\> RegExEscaped  '192.168.22.54'
  192\.168\.22\.54

  PS C:\> RegExEscaped 'PS C:\> <example usage>'
  PS C:\>\ <example\ usage>



  Here we run the function using its built-in alias of "RegExEscaped".  We take various strings and the function returns the proper format to have a literal match for that string.

.INPUTS
.OUTPUTS
.NOTES
  Name: New-RegExEscapedCharactersSyntax.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-03 | Initial Version
  Dependencies:
  Notes:
  - This told me that the code below was possible - Search for "[regex]::escape": https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.1

  .
#>
function New-RegExEscapedCharactersSyntax {
  [CmdletBinding()]
  [Alias('RegExEscaped')]
  param (
    # Parameter help description
    [Parameter()]
    [string[]]
    $String
  )
  
  begin {}
  
  process {
    [regex]::Escape("$String")
  }
  
  end {}
}