<#
.SYNOPSIS
  The "New-PSCredential" function allows you to create a PSCredential object from a username/password.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> $password = Read-Host -AsSecureString
  ******************************
  PS C:\> 
  PS C:\> $cred = New-PSCredential -Username John.Smith -Password $password


  First, we put the password as a Secure String into the variable $password. Next, we call the "New-PSCredential" function with the username and the $password variable.

.EXAMPLE
  PS C:\> $cred = New-PSCredential -Username John.Smith
  Please enter in the password for the username: ******************************


  If no -Password is provided, the user is prompted to input the password.  The input from the user is received as a Secure String object.

.INPUTS
.OUTPUTS
.NOTES
  Name: New-PSCredential.ps1
  Author: Travis Logue
  Version History: 1.2 | 2020-08-30 | Updated documentation
  Dependencies: 
  Notes:
  - This was helpful in creating the code below: https://adamtheautomator.com/powershell-get-credential/


  .
#>
function New-PSCredential {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = "Reference the 'username' of the credential.")]
    [string]
    $Username,
    [Parameter(HelpMessage = "This parameter expects a SecureString object.  Reference the SecureString object of the password for the corresponding Username.")]
    [securestring]
    $Password,
    [Parameter(HelpMessage = 'Reference the Domain of the User you are testing. DEFAULT = "corp"')]
    [string]
    $Domain,
    [Parameter(HelpMessage = 'If the Username is a Local Account, use this Switch Parameter')]
    [switch]
    $LocalAccount,
    [Parameter(HelpMessage = 'If the Username is a Local Account, use the computer is a remote machine, use this parameter to specify the Computername of that remote machine.')]
    [string]
    $LocalAccountHostname
  )
  
  begin {}
  
  process {
    if (-not ($Username)) {
      $Username = Read-Host "Please enter in the username"
    }
    if ($LocalAccount) {
      if ($LocalAccountHostname) {
        $Username = "$LocalAccountHostname\$Username"
        Write-Host "`nUsing the identity of: " -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "$Username`n"
      }
      else {
        $Username = "$(HOSTNAME.EXE)\$Username"
        Write-Host "`nUsing the identity of: " -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "$Username`n"
      }
    }
    else {
      if ($Domain) {
        $Username = "$Domain\$Username"
        Write-Host "`nUsing the identity of: " -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "$Username`n"
      }
      elseif ($Username -like "*\*") {
        $Username = $Username
        Write-Host "`nUsing the identity of: " -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "$Username`n"
      }
      else {
        $Username = "corp\$Username"
        Write-Host "`nThe '-Username' supplied did not specify the associated Domain, so the default of 'corp' has been specified as the Domain. `nIf you want to specify a Domain, rerun this function with the '-Domain' parameter.`n`nIf the account is a local user account, rerun this function with the '-LocalAccount' parameter (and if the Local Account is on a remote machine, also use '-LocalAccountHostname').`n`nSince some applications will not work properly without specifying the Domain, the -Username value has been updated to:" -ForegroundColor Yellow -BackgroundColor Black -NoNewline
        Write-Host "  $Username`n"
      }
    }

    if (-not ($Password)) {
      $Password = Read-Host "Please enter in the password" -AsSecureString
    }

    $Credential = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    Write-Output $Credential

  }
  
  end {}
}