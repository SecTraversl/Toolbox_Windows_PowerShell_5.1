

<#
.SYNOPSIS
  This function de-obfuscates a given Secure String to plain text
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  - Google search to find helpful articles: "powershell how to create a securestring without it being logged"
  - This was helpful in creating the code below: https://docs.microsoft.com/en-us/archive/blogs/timid/powershell-one-liner-decrypt-securestring
#>

function Convert-SecureString2Plaintext {
  [CmdletBinding()]
  [Alias('ConvertSecureString')]
  param (
    [Parameter(HelpMessage = 'Reference the Secure String that you want to convert to normal text')]
    [securestring]
    $SecureString
  )
  
  begin {}
  
  process {
    $ConvertedString = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)))

    Write-Output $ConvertedString
  }
  
  end {}
}