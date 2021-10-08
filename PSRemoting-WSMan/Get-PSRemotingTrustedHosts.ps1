
<#
.SYNOPSIS
  Retrieve the list of Trusted Hosts (IP addresses, Computer Names, or FQDN) found in the WSMan:\ PSDrive.  Trusted Hosts values are needed if you plan on using a Local User account for PSRemoting to th local computer.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  - Good info here: " The TrustedHosts item can contain a comma-separated list of computer names, IP addresses, and fully-qualified domain names. Wildcards are permitted. " ; Found: http://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_remote_troubleshooting?view=powershell-7
  - General info for enabling PSRemoting:  https://4sysops.com/wiki/enable-powershell-remoting/
  - Using PSRemoting / Invoke-Command with a Local Admin account:  https://community.spiceworks.com/topic/2027703-how-to-use-invoke-command-with-remote-local-administrator-account
#>


function Get-PSRemotingTrustedHosts {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {

    Get-Item WSMan:\localhost\Client\TrustedHosts

  }
  
  end {}
}