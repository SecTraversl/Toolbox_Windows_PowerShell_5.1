

function Get-ClearText {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the SecureString you want to convert to Clear Text')]
    [securestring]
    $SecureString
  )
  
  begin {}
  
  process {

    Write-Host "`nThis is here for backwards compatibility.  It is recommended to use 'Convert-SecureString2Plaintext.ps1' instead (primarily because it is easier to understand what the function does from its title)`n" -BackgroundColor Black -ForegroundColor Yellow
    ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)))
  }
  
  end {}
}