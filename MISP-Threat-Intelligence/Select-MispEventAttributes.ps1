<#
.SYNOPSIS
  The "Select-MispEventAttributes" takes the output from "Invoke-MispApiEventsView.ps1", converts the Date/Timestamp from a Unix format (Epoch time), and selects specific properties of each IOC that are useful for filtering and analysis.
  
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
  Name:  Select-MispEventAttributes.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-26 | Multiple Object support added
  Dependencies:
  Notes:

  .
#>
function Select-MispEventAttributes {
  [CmdletBinding()]
  [Alias('MispSelectEventAttributes')]
  param (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $Object
  )
  
  begin {

    function ConvertFrom-UnixTime {
      [CmdletBinding()]
      [alias('ConvertFrom-EpochTime', 'Convert-UnixTime2WindowsTime', 'FromEpochTime', 'FromUnixTime')]
      param (
        [Parameter(HelpMessage = 'Reference the Unix timestamp {e.g. "1597384447"} that you want to convert')]
        [string]
        $UnixTime
      )       
    
      $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
      $whatIWant = $origin.AddSeconds($UnixTime)
      Write-Output $whatIWant     
      
    }
    
    function Confirm-PSObjectContainsProperty {
      [CmdletBinding()]
      param (
        [Parameter()]
        [psobject]
        $Object,
        [Parameter()]
        [string]
        $PropertyName,
        [Parameter()]
        [switch]
        $FuzzyMatch
      )         
        
      if ($FuzzyMatch) {
        # If we give a "-PropertyName" of 'host' and the Object has a property with a name of "hostname" then the evaluation, using this syntax,  will be counted as $true
        [bool]($Object.PSobject.Properties.name -match $PropertyName)
      }
      else {
        # Here we are looking for an exact property name match
        $PropertyName -in $Object.PSobject.Properties.name     
      }

    }

  }
  
  process {

    foreach ($obj in $Object) {
      
      if (Confirm-PSObjectContainsProperty -Object $obj -PropertyName Attribute) {
      
        $obj.Attribute | Select-Object event_id, @{n = 'date'; e = { Get-Date (ConvertFrom-UnixTime $_.timestamp) -Format "yyyy-MM-dd" } }, category, type, value, comment
  
      }
      else {
        Write-Host ''
        Write-Host "'Attribute' property was not found:  Confirm that the object is in the correct form from the output of 'Invoke-MispApiEventsView' " -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ''
      }

    }

  }
  
  end {}
}