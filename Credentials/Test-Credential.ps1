
<#
.SYNOPSIS
  This tool allows for the testing of either a PSCredential or a Username/Password combination.
  *REQUIRES*: New-PSCredential function

.DESCRIPTION
.EXAMPLE
  PS C:\> Test-Credential -Credential $creds

  
  Tests the given PSCredential by using Start-Process to invoke a PowerShell terminal.

.EXAMPLE
  PS C:\> $password = read-host -AsSecureString
  ********************************
  PS C:\>
  PS C:\> Test-Credential -Username host_only_user -Password $password -LocalAccount


  Tests the given Local Account by endeavoring to Start-Process a PowerShell prompt with the given credentials.

.EXAMPLE
  PS C:\> Test-Credential
  Please enter in the username: john.smith

  The '-Username' supplied did not have the associated Domain.
  If the account is a local user account, rerun this function with the '-LocalAccount' parameter.

  Since some applications will not work properly, the -Username value has been updated to:  corp\john.smith

  Please enter in the password: ******************************

  
  This function will automatically prompt for certain necessary values. Since the function can be used interactively, the only thing that needs to be done is to invoke it.

.INPUTS
.OUTPUTS
.NOTES
  *REQUIRES*: New-PSCredential function

  - This discussion on "Start-Process" saved my sanity: https://stackoverflow.com/questions/7319658/start-process-raises-an-error-when-providing-credentials-possible-bug
    * The error I was receiving was this: "Start-Process : This command cannot be run due to the error: The directory name is invalid."
    * The first fix to simply get rid of that error was actually found in a comment of:  "I've found that if you specify something like -WorkingDirectory C:\ , it fixes the problem. "
    * The second fix was to actually get a functioning PowerShell prompt... that was achieved by considering this code, and then modifying it to my purposes (which is what is used in the function below):   Start-Process $PSHOME\powershell.exe -ArgumentList "-NoExit","-Command `"&{`$outvar1 = 4+4; `"write-output `"Hello:`"`$outvar1`"}`"" -Wait  
#>
function Test-Credential {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference a PSCredential object that you want to test.')]
    [pscredential]
    $Credential,
    [Parameter(HelpMessage='Reference the Username to test.')]
    [string]
    $Username,
    [Parameter(HelpMessage="This parameter expects a SecureString object.  Reference the SecureString object of the password for the corresponding Username.")]
    [securestring]
    $Password,
    [Parameter(HelpMessage='Reference the Domain of the User you are testing. DEFAULT = "corp"')]
    [string]
    $Domain,
    [Parameter(HelpMessage='If the Username is a Local Account, use this Switch Parameter')]
    [switch]
    $LocalAccount,
    [Parameter(HelpMessage='If the Username is a Local Account, use the computer is a remote machine, use this parameter to specify the Computername of that remote machine.')]
    [string]
    $LocalAccountHostname
  )
  
  begin {}
  
  process {
    if ($Credential) {
      Start-Process -FilePath powershell.exe -Credential $Credential -WorkingDirectory c:\  -Wait -ArgumentList '-noexit', "-Command `"&{`$outvar1 = `'These creds work...`'; `"write-output `"Hello: `"`$outvar1`"}`""
    }
    else {

      if (-not ($Username)) {
        $Username = Read-Host "Enter in the Username of the account" 
      }

      if ($LocalAccount) {        
        if ($LocalAccountHostname) {
          $cred = New-PSCredential -Username $Username -Password $Password -LocalAccount -LocalAccountHostname $LocalAccountHostname 
        }
        else {
          $cred = New-PSCredential -Username $Username -Password $Password -LocalAccount 
        }

        Start-Process -FilePath powershell.exe -Credential $cred -WorkingDirectory c:\  -Wait -ArgumentList '-noexit', "-Command `"&{`$outvar1 = `'These creds work...`'; `"write-output `"Hello: `"`$outvar1`"}`""

        <#
        $DomainName = HOSTNAME.EXE
        runas.exe /user:$DomainName\$Username "powershell.exe -noexit -command {The credentials work...}"
        #>
  
      }
      else {
        if (-not ($Password)) {
          $Password = Read-Host "Enter in the Password for '$Username'" -AsSecureString
        }
        if ($Domain) {
          $cred = New-PSCredential -Username $Username -Password $Password -Domain $Domain
        }
        else {
          $cred = New-PSCredential -Username $Username -Password $Password
        }

        Start-Process -FilePath powershell.exe -Credential $cred -WorkingDirectory c:\  -Wait -ArgumentList '-noexit', "-Command `"&{`$outvar1 = `'These creds work...`'; `"write-output `"Hello: `"`$outvar1`"}`""
          
      } 
      
    }
    

  }
  
  end {}
}

