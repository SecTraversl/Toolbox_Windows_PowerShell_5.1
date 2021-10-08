<#
.SYNOPSIS
  The "Update-HostsFileContent" function takes a file containing IP Addresses and Host names and appends that file content to the current "Hosts" file found at: "$env:SystemRoot\System32\drivers\etc\hosts".
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-HostsFileContent | ? {$_ -notlike "#*"}

  104.108.143.17  some-place.MyDomain.com
  104.108.143.17  someplaceMyDomain.com


  PS C:\> Get-Content .\BlackHole_HostsFile_For-MyDomain.com-Lookalike-Domains.txt | measure
  Count    : 3179


  PS C:\> Get-Content .\BlackHole_HostsFile_For-MyDomain.com-Lookalike-Domains.txt | Select-Object -f 5
  127.0.0.1       MyDomaina.com
  127.0.0.1       MyDomainb.com
  127.0.0.1       MyDomainc.com
  127.0.0.1       MyDomaind.com
  127.0.0.1       MyDomaine.com


  PS C:\> Update-HostsFileContent -HostsFileUpdateFile .\BlackHole_HostsFile_For-MyDomain.com-Lookalike-Domains.txt
  PS C:\>


  PS C:\> Get-HostsFileContent | Select-Object -First 20
  # Copyright (c) 1993-2009 Microsoft
  #
  # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
  #
  # For example:
  #
  #      102.54.94.97     rhino.acme.com          # source server
  #       38.25.63.10     x.acme.com              # x client host

  # localhost name resolution is handled within DNS itself.
  #       127.0.0.1       localhost
  #       ::1             localhost

  104.108.143.17  some-place.MyDomain.com
  104.108.143.17  someplaceMyDomain.com
  127.0.0.1       MyDomaina.com
  127.0.0.1       MyDomainb.com
  127.0.0.1       MyDomainc.com
  127.0.0.1       MyDomaind.com
  127.0.0.1       MyDomaine.com
  127.0.0.1       MyDomainf.com



  Here we first take a look a look at the current "hosts" file by using the "Get-HostsFileContent" function (or, you could simply do the following to accomplish the same thing: Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts").  We see that there are only two entries in the current "hosts" file, one for "some-place.MyDomain.com" and another for "someplace.MyDomain.com".  We then take a look at our 'update' file, which contains 3000+ "lookalike" domains that we want to blackhole by hardcoding their resolution to 127.0.0.1.  We then run the "Update-HostsFileContent" function using the "-HostsFileUpdateFile" parameter and referencing the file.  The result is that the contents of the file we referenced are appended to the 'hosts' file, which we see when we run "Get-HostsFileContent | Select-Object -First 20".

.INPUTS
.OUTPUTS
.NOTES
  Name: Update-HostsFileContent.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-03-12 | Initial Version
  Dependencies: 
  Notes:

  
  .
#>
function Update-HostsFileContent {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $HostsFileUpdateFile,
    [Parameter()]
    [switch]
    $Overwrite
  )
  
  begin {}
  
  process {

    if ($Overwrite) {

      $HostsFile = Get-Item -Path "$env:SystemRoot\System32\drivers\etc\hosts"
      $NewHostsFileContent = Get-Content -Path $HostsFileUpdateFile
      $NewHostsFileContent | Out-File -FilePath $HostsFile -Encoding ascii

    }
    else {

      $HostsFile = Get-Item -Path "$env:SystemRoot\System32\drivers\etc\hosts"
      $NewHostsFileContent = Get-Content -Path $HostsFileUpdateFile
      $NewHostsFileContent | Out-File -FilePath $HostsFile -Append -Encoding ascii

    }

  }
  
  end {}
}