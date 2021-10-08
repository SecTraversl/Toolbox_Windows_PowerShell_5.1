<#
.SYNOPSIS
  Short description

  *REQUIRES*: New-PSCredential function
  
.DESCRIPTION
.EXAMPLE
  PS C:\> New-RemoteSession
  DNS name of remote host: RemoteDesktop
  Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
  -- ----            ------------    ------------    -----         -----------------     ------------
   1 WinRM1          RemoteDesktop   RemoteMachine   Opened        Microsoft.PowerShell     Available
  
  
  Calling "New-RemoteSession" without any parameters will cause a prompt for the name of the destination computer and will use the current identity/credentials with which the PowerShell terminal was launched.

.EXAMPLE
  PS C:\> New-RemoteSession -ComputerName RemoteDesktop
  Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
  -- ----            ------------    ------------    -----         -----------------     ------------
   2 WinRM2          RemoteDesktop   RemoteMachine   Opened        Microsoft.PowerShell     Available



  Referencing the -ComputerName of the destination host is the minimum requirement for the function.  Here we are again using the credentials of the identity used to start the PowerShell terminal.

.EXAMPLE
  PS C:\> New-RemoteSession -ComputerName RemoteDesktop -Username a-john.smith

  The '-Username' supplied did not specify the associated Domain, so the default of 'corp' has been specified as the Domain.
  If you want to specify a Domain, rerun this function with the '-Domain' parameter.

  If the account is a local user account, rerun this function with the '-LocalAccount' parameter (and if the Local Account is on a remote machine, also use '-LocalAccountHostname').

  Since some applications will not work properly without specifying the Domain, the -Username value has been updated to:  corp\a-john.smith

  Please enter in the password: ******************************

   Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
   -- ----            ------------    ------------    -----         -----------------     ------------
    3 WinRM3          RemoteDesktop   RemoteMachine   Opened        Microsoft.PowerShell     Available
  

  PS C:\> Invoke-Command -Session (Get-PSSession) -ScriptBlock {whoami;hostname}
  corp\a-john.smith
  RemoteDesktop



  Here we are specifiying the destination computer and a specific identity.  The code will automatically add a domain prefix to the identity if it was not specified.  If a specific domain is desired to be prefixed, then use the "-Domain" parameter to specify it and that will be used instead of the default of "corp\". We then use Invoke-Command to run a set of commands identifying the name of the remote machine and the identity we are using on that remote machine.

.EXAMPLE
  PS C:\> $cred = New-PSCredential -Username a-john.smith

  The '-Username' supplied did not specify the associated Domain, so the default of 'corp' has been specified as the Domain.
  If you want to specify a Domain, rerun this function with the '-Domain' parameter.

  If the account is a local user account, rerun this function with the '-LocalAccount' parameter (and if the Local Account is on a remote machine, also use '-LocalAccountHostname').

  Since some applications will not work properly without specifying the Domain, the -Username value has been updated to:  corp\a-john.smith

  Please enter in the password: ******************************
  PS C:\>
  PS C:\>
  PS C:\> New-RemoteSession -Credential $cred -ComputerName RemoteDesktop

   Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
   -- ----            ------------    ------------    -----         -----------------     ------------
    4 WinRM4          RemoteDesktop   RemoteMachine   Opened        Microsoft.PowerShell     Available

  PS C:\> Invoke-Command -Session (Get-PSSession) -ScriptBlock {whoami;hostname}
  corp\a-john.smith
  RemoteDesktop



  Here we created a PSCredential and passed it to the "New-RemoteSession" function.  Again, we ran an Invoke-Command on the remote machine to show our identity on the remote machine as well as its hostname.

.EXAMPLE
  PS C:\> New-RemoteSession -Credential $cred -ComputerName RemoteDesktop -EnterSession
  [RemoteDesktop]: PS C:\Users\a-john.smith\Documents>
  [RemoteDesktop]: PS C:\Users\a-john.smith\Documents> whoami
  corp\a-john.smith
  [RemoteDesktop]: PS C:\Users\a-john.smith\Documents> HOSTNAME.EXE
  RemoteDesktop
  [RemoteDesktop]: PS C:\Users\a-john.smith\Documents>   



  Here we use the -EnterSession parameter in order to immediately enter the created PSSession.

.INPUTS
.OUTPUTS
.NOTES
  *REQUIRES*: New-PSCredential function

  - These were helpful in creating some decent Error handling and Try Catch block usage:
      https://4sysops.com/archives/stop-or-exit-a-powershell-script-when-it-errors/
      https://devblogs.microsoft.com/scripting/understanding-non-terminating-errors-in-powershell/
      https://leanpub.com/thebigbookofpowershellerrorhandling/read

  - Examples of trying out the Error handling:
        <#
        ≈ Temp> New-RemoteSession
        DNS name of remote host: RemoteJumpBox01
        Specify credentials? (y/n): n

        An error occurred while trying to establish a session with 'RemoteJumpBox01'

        Message:        Access is denied.

        § Temp> 
        ¿ Temp> 
        ♥ Temp> 
        Ω Temp> New-RemoteSession
        DNS name of remote host: RemoteJumpBox01
        Specify credentials? (y/n): y
        cmdlet Get-Credential at command pipeline position 1
        Supply values for the following parameters:
        User: j
        Password for user j: *******

        An error occurred while trying to establish a session with 'RemoteJumpBox01'

        Message:        The user name or password is incorrect.



        ƒ Temp> New-RemoteSession
        DNS name of remote host: RemoteJumpBox01
        Specify credentials? (y/n): y
        cmdlet Get-Credential at command pipeline position 1
        Supply values for the following parameters:
        User: a-special.user
        Password for user a-special.user: ********************************

        Id Name            ComputerName    ComputerType    State         ConfigurationName
        -- ----            ------------    ------------    -----         -----------------
        18 WinRM18         RemoteJumpBox01    RemoteMachine   Opened        Microsoft.PowerS...
        Enter the session? (y/n): y


        [RemoteJumpBox01]: PS C:\Users\a-special.user\Documents> 

        #>
#>
function New-RemoteSession {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the ComputerName with which to attempt a new PSSession.')]
    [string]
    $ComputerName,
    [Parameter(HelpMessage='If you want to use a specific PSCredential, reference it with this parameter.')]
    [pscredential]
    $Credential,
    [Parameter(HelpMessage='If you want to use an Identity other than the current one, reference the Username with which you want to start the session.')]
    [string]
    $Username,
    [Parameter()]
    [string]
    $Domain,
    [Parameter(HelpMessage='Use this Switch Parameter if you immediately want to enter the PSSession after it has been created.')]
    [switch]
    $EnterSession
  )
  
  begin {}

  process {





    if ($Credential) {
      $cred = $Credential
    }
    elseif ($Username) {
      if ($LocalAccount) {
        $cred = New-PSCredential -Username $Username -Password $Password -LocalAccount 
      }
      else {
        $cred = New-PSCredential -Username $Username -Password $Password
      }
    }

    if ( -not ($ComputerName)) {
      $ComputerName = Read-Host "DNS name of remote host"
    }     

    try {
      if ($LocalAccount) {
        
      }      
      if ($cred){
        $session = New-PSSession -ComputerName $ComputerName -Credential $cred -ErrorAction Stop -ErrorVariable err
      }
      else {
        $session = New-PSSession -ComputerName $ComputerName -ErrorAction Stop -ErrorVariable err
      }
    }  
    catch {        
        "`nAn error occurred while trying to establish a session with '$ComputerName'`n"
        "Message:`t$($Error[0].Exception.TransportMessage)`n"
    }       
    
    
    if ( -not ($err)){
      if ($EnterSession) {
        Enter-PSSession -Session $session
      }

    }   

    
  }



  end {}


}