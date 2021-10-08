<#
.SYNOPSIS
  The "Get-HostsFileContent" function displays the content of the computer's "hosts" file found at: "$env:SystemRoot\System32\drivers\etc\hosts".
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-HostsFileContent
  # Copyright (c) 1993-2009 Microsoft Corp.
  #
  # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
  #
  # This file contains the mappings of IP addresses to host names. Each
  # entry should be kept on an individual line. The IP address should
  # be placed in the first column followed by the corresponding host name.
  # The IP address and the host name should be separated by at least one
  # space.
  #
  # Additionally, comments (such as these) may be inserted on individual
  # lines or following the machine name denoted by a '#' symbol.
  #
  # For example:
  #
  #      102.54.94.97     rhino.acme.com          # source server
  #       38.25.63.10     x.acme.com              # x client host

  # localhost name resolution is handled within DNS itself.
  #       127.0.0.1       localhost
  #       ::1             localhost

  104.108.143.17  some-place.MyDomain.com
  104.108.143.17  someplace.MyDomain.com



  Here we run the function and in return receive the contents of the file "$env:SystemRoot\System32\drivers\etc\hosts" displayed in the terminal.

.EXAMPLE
  PS C:\> HostsFile -Verbose
  VERBOSE: Now running...:   Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"
  # Copyright (c) 1993-2009 Microsoft subd.
  #
  # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
  #
  # This file contains the mappings of IP addresses to host names. Each
  # entry should be kept on an individual line. The IP address should
  # be placed in the first column followed by the corresponding host name.
  # The IP address and the host name should be separated by at least one
  # space.
  #
  # Additionally, comments (such as these) may be inserted on individual
  # lines or following the machine name denoted by a '#' symbol.
  #
  # For example:
  #
  #      102.54.94.97     rhino.acme.com          # source server
  #       38.25.63.10     x.acme.com              # x client host

  # localhost name resolution is handled within DNS itself.
  #       127.0.0.1       localhost
  #       ::1             localhost

  104.108.143.17  some-place.MyDomain.com
  104.108.143.17  someplace.MyDomain.com



  Here we run the function using its built-in alias "HostFile" and specifying the Common Parameter "-Verbose" in order to see specific messaging about what the function is doing.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-HostsFileContent.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-03-12 | Initial Version
  Dependencies: 
  Notes:

  
  .
#>
function Get-HostsFileContent {
  [CmdletBinding()]
  [Alias('HostsFile')]
  param ()
  
  begin {}
  
  process {
    Write-Verbose "Now running...:   Get-Content -Path `"$env:SystemRoot\System32\drivers\etc\hosts`""
    Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts"
  }
  
  end {}
}