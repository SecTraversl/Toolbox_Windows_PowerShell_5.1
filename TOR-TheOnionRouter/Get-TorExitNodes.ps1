<#
.SYNOPSIS
  The "Get-TorExitNodes" function retrieves the Tor Project's 'torbulkexitlist' and returns a sorted array of the 1500+ IP Addresses for the Tor Exit Nodes.

.DESCRIPTION
.EXAMPLE
  PS C:\> $UsingTheAliasName = TorExitNodes
  PS C:\> $UsingTheAliasName | Where-Object { $_ -like '184.191.13.47' -or $_ -like '96.35.32.58' -or $_ -like '157.42.224.185' }
  PS C:\>
  

  Here we are demonstrating a fast way to invoke this function.  The "Get-TorExitNodes" function has a built-in alias of 'TorExitNodes' that we use above to invoke the function.  We then search the results for 3 specific IP addresses to see if they are in the list. 

.EXAMPLE
  PS C:\> $TorExitNodes = Get-TorExitNodes
  PS C:\>
  PS C:\> $TorExitNodes | measure
  Count    : 1513

  PS C:\> $TorExitNodes | select -First 10;  $TorExitNodes | select -Last 10
  5.2.67.21
  5.2.69.4
  5.2.69.5
  5.2.69.6
  5.2.69.7
  5.2.69.13
  5.2.69.14
  5.2.69.15
  5.2.69.21
  5.2.69.22
  217.79.178.53
  217.170.204.126
  217.170.205.14
  217.170.206.138
  217.170.206.146
  217.182.168.115
  217.182.171.46
  217.182.171.206
  217.182.192.217
  219.91.110.131



  Here we run the function and store the results in the variable "$TorExitNodes".  We then show how the IP Addresses are in sorted order by displaying the first 10 and last 10 results in the array.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-TorExitNodes.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-27 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-TorExitNodes {
  [CmdletBinding()]
  [Alias('TorExitNodes')]
  param ()
  
  begin {}
  
  process {
    $URI = 'https://check.torproject.org/torbulkexitlist'
    $TorWebRequest = Invoke-WebRequest -Uri $URI
    $SplitLines = ($TorWebRequest.RawContent -split "`r?`n") 
    [array]$ArrayOfIPAddresses = $SplitLines | Where-Object { $_ -notlike "HTTP*" -and $_ -notlike "*:*"} | Where-Object { $_ }
    $ExitNodeIPAddresses = $ArrayOfIPAddresses | Sort-Object {[version]$_}
    Write-Output $ExitNodeIPAddresses
  }
  
  end {}
}