<#
.SYNOPSIS
  The "Invoke-MispApiEventsView" takes the output from Invoke-MispApiSearch.ps1 and retrieves further details about the respective threat feed "IDs", including the IOCs pertaining to the "ID" entries.

.DESCRIPTION
.EXAMPLE
  PS C:\> $apikey = Read-HostPlus
  Input the text you want obfuscated
  : *****************************************
  
  PS C:\> $1 = MispApiSearch -ApiKey $ApiKey -SearchTerm kaseya
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100 10936  100 10936    0     0   2187      0  0:00:05  0:00:05 --:--:--  2582
  
  PS C:\> $2 = $1 | MispApiEventsView -ApiKey $ApiKey
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100  194k  100  194k    0     0   194k      0  0:00:01 --:--:--  0:00:01  318k
  
  PS C:\> $3 = $2 | % { MispSelectEventAttributes $_ }
  
  PS C:\> $3 | measure
  Count    : 47

  PS C:\> $3 | select -f 5 | ft

  event_id date       category          type   value                                                        comment
  -------- ----       --------          ----   -----                                                        -------
  1218     2021-07-05 External analysis link   https://twitter.com/r3c0nst/status/1411922502553673728
  1218     2021-07-05 External analysis link   https://github.com/cado-security/DFIR_Resources_REvil_Kaseya
  1218     2021-07-05 Network activity  domain ncuccr.org
  1218     2021-07-05 Network activity  domain 1team.es
  1218     2021-07-05 Network activity  domain 4net.guru


  
  Here we demonstrate all 3 tools being used together.  First, we store our API Key in a variable for use in the functions.  Next, we use the "Invoke-MispApiSearch" function by calling its alias 'MispApiSearch'.  Next, we take the objects that were returned and pipe those into the "Invoke-MispApiEventsView" function by calling its alias 'MispApiEventsView'.  Finally, we use the "Select-MispEventAttributes" function by calling its alias 'MispSelectEventAttributes' in order retrieve the IOCs along with specifically chosen properties that are useful for analysis and filtering.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Invoke-MispApiEventsView.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-08-24 | Initial Version
  Dependencies:
  Notes:

  .
#>
function Invoke-MispApiEventsView {
  [CmdletBinding()]
  [Alias('MispApiEventsView')]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $ApiKey,
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [int]
    $ID,
    [Parameter()]
    [string]
    $MispServer # = 'mispserver.MyDomain.com' # Input a default value
  )
  
  begin {}
  
  process {
    
    $curl_request = curl.exe `
      -k `
      -H "Authorization: $apikey" `
      -H "Accept: application/json" `
      -H "Content-type: application/json" `
      "https://$MispServer/events/view/$ID"
    
    $obj = $curl_request | ConvertFrom-Json

    Write-Output $obj.Event

  }
  
  end {}
}