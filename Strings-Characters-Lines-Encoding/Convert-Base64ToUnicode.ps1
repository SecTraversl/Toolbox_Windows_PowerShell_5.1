<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-Base64ToUnicode.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-09-08 | Updated aesthetics
  Dependencies:
  Notes:
  - This post contained the code that I essentially went with below:
    https://stackoverflow.com/questions/18726418/decoding-base64-with-powershell?rq=1

  - Good discussion on conversions of UTF-8, ASCII, Base64, and UTF-16/Unicode:
    https://stackoverflow.com/questions/15414678/how-to-decode-a-base64-string

  - A different forum used the example here. However, the Unicode didn't add spaces for my solution, so instead I used Unicode.GetString in the function
    Example:
      [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($data))
    
      
  .
#>
function Convert-Base64ToUnicode {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $String
  )
  
  begin {}
  
  process {
    [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($String))
  }
  
  end {}
}