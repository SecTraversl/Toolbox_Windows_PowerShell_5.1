
<#
.SYNOPSIS
  Set the list of Trusted Hosts (IP addresses, Computer Names, or FQDN) found in the WSMan:\ PSDrive.  Trusted Hosts values are needed if you plan on using a Local User account for PSRemoting to th local computer.
.DESCRIPTION
.EXAMPLE
  PS C:\> Set-PSRemotingTrustedHosts -ComputerName 'zogtheexpert.corp.coinstar.com','CSHQTLOGUE1-S.corp.coinstar.com'

  WinRM Security Configuration.
  This command modifies the TrustedHosts list for the WinRM client. The computers in the TrustedHosts list might not be authenticated. The
  client might send credential information to these computers. Are you sure that you want to modify this list?
  [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"):

  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  - *IMPORTANT*: The commend from this forum post is pivotal:
      When you're reading this, keep in mind that the use of the term "trusted host(s)" may be a little different than what you are used to.  If you come from *NIX land, you will assume a trusted host is a computer that I allow to "connect to me".  But in the PS paradigm it means the computer(s) I trust enough to "connect to". 
    * from: https://community.idera.com/database-tools/powershell/ask_the_experts/f/learn_powershell-12/18576/ps-remoting-to-a-non-domain-server

In your particular case the domain computer must be setup to trust the non-domain computer that it wants to connect to, either explicitly by name, IP address, or wildcard.  If they were both in the same domain all this would be taken care of under the covers by Kerberos.
  - I used the "docs.microsoft.com" link (shown next) and its examples to create the "append" code in this function...
  - Good info here: " The TrustedHosts item can contain a comma-separated list of computer names, IP addresses, and fully-qualified domain names. Wildcards are permitted. " ; Found: http://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_remote_troubleshooting?view=powershell-7
  - General info for enabling PSRemoting:  https://4sysops.com/wiki/enable-powershell-remoting/
  - Using PSRemoting / Invoke-Command with a Local Admin account:  https://community.spiceworks.com/topic/2027703-how-to-use-invoke-command-with-remote-local-administrator-account


#>


function Set-PSRemotingTrustedHosts {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the scalar or array of Computer Names or IPs to add to the Trusted Hosts value in WSMan')]
    [psobject[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $curValue = (get-item WSMan:\localhost\Client\TrustedHosts).value

    $newString = [string]

    if ($ComputerName -eq '*') {
      Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'
    }

    else {      
      if ($null -notlike $curValue) {
        $newString += $curValue
        foreach ($item in $ComputerName) {
          $newString += ", $item"
        }
      }
      elseif ($Computername.Length -eq 1) {
        $newString = $ComputerName
      }
      else {
        $newString = $ComputerName -join ', '
      }  
  
      Set-Item WSMan:\localhost\Client\TrustedHosts -Value $newString
    }    

  }
  
  end {}
}