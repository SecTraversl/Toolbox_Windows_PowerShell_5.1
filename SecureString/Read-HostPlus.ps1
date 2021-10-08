<#
.SYNOPSIS
  The "Read-HostPlus" function allows the storage of a plain text string to variable in the terminal while obfuscating the characters.

.DESCRIPTION
.EXAMPLE
  PS C:\> $test = Read-HostPlus
  Input the text you want obfuscated
  : *********************************************************
  PS C:\> $test
  This text I didn't want to be logged at the command line



  Here we run the function and type in the text that we didn't want displayed in the terminal.  We save it to a variable, and then can use that variable just as we would a normal string.

.INPUTS
.OUTPUTS
.NOTES
  Name: Read-HostPlus.ps1
  Author: Travis Logue
  Version History: 1.1 | 2021-05-27 | Initial Version
  Dependencies:
  Notes:
    - Google search to find helpful articles: "powershell how to create a securestring without it being logged"
    - This was helpful in creating the code below: https://docs.microsoft.com/en-us/archive/blogs/timid/powershell-one-liner-decrypt-securestring

  .
#>

function Read-HostPlus {
  [CmdletBinding()]
  [Alias('ConvertSecureString')]
  param ()
  
  begin {}
  
  process {
    $SecureString = Read-Host -AsSecureString -Prompt "Input the text you want obfuscated`n"

    $ConvertedString = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)))

    Write-Output $ConvertedString
  }
  
  end {}
}