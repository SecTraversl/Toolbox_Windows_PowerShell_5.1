<#
.SYNOPSIS
  Wrapper for nslookup.exe. Parses the output and returns objects.
.DESCRIPTION
.EXAMPLE
  PS C:\> NsLookupPlus -DomainNames verificationlabs.com,youtube.com
  Non-authoritative answer:
  Non-authoritative answer:

  Name                 Addresses                                               Aliases
  ----                 ---------                                               -------
  verificationlabs.com {2001:4801:7817:72:a833:d03a:ff10:2bcf, 198.61.176.181} {}
  youtube.com          {2607:f8b0:4000:80f::200e, 216.58.193.142}              {}


  Here we are looking up two domains to determine their respective IP Addresses.

.INPUTS
.OUTPUTS
.NOTES
  - This was helpful in determining syntax for embedding an Alias directly into a function: https://stackoverflow.com/questions/24683539/how-to-alias-a-powershell-function
  - 2020-05-19  For the background on the trial and error and research that went into this, see:
    * For, While, If - NsLookup-Plus string matching logic and notes.ps1
#>
function Invoke-NsLookupPlus {
  [CmdletBinding()]
  [Alias("NsLookupPlus")]
  param (
    [Parameter(HelpMessage="Reference the Name(s) to resolve...")]
    [string[]]
    $DomainNames,
    [Parameter(HelpMessage="Reference the IP(s) to resolve...")]
    [string[]]
    $IPAddresses
  )
  
  begin {

    if ($IPAddresses) {
      $Resolved = foreach ($e in $IPAddresses) {
        nslookup.exe $e
      }
  
      $Resolved = $Resolved | Where-Object {$_}
    }

    elseif ($DomainNames) {
      $NamesResolved = foreach ($n in $DomainNames) {
        nslookup.exe $n
      }        
    }

  }
  
  process {
    if ($Resolved) {
      $CustomObject = for ($i = 0; $i -lt $Resolved.Count; $i+=2) {

        if ($Resolved[$i] -match "^Name*") {
          $prop = [ordered]@{
            Name = $Resolved[$i] -replace ".*\s",""
            Addresses = $Resolved[$i+1] -replace ".*\s",""
          }
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }    
            
      } 
    }

    elseif ($NamesResolved) {
      $y = $NamesResolved

      $CustomObject_ResolvedNames = for ($i = 0; $i -lt $y.Count; $i++) {
        if ($y[$i] -match "^Name*") { 
          
          $NameLine = $y[$i]

          $counter = 0
          $Addresses = @()
          $Aliases = @()     
      
          while ($null -notlike ($y[$i + 1 + $counter]) ) {
            $CurrentLine =  $y[$i + 1 + $counter]
      
            if ($CurrentLine -match "^Address*") {
              $counter_two = 0
              while (($null -notlike ($y[$i + 1 + $counter + $counter_two])) -and ($y[$i + 1 + $counter + $counter_two] -notlike "Alias*") ) {
                $Address_Line = $y[$i + 1 + $counter + $counter_two]
                $Addresses += $Address_Line -replace ".*\s",""
                $counter_two += 1
              }   
            }
            
            if ($CurrentLine -match "^Alias*") {
              $counter_two = 0
              while ($null -notlike ($y[$i + 1 + $counter + $counter_two]) ) {
                $Alias_Line = $y[$i + 1 + $counter + $counter_two]
                $Aliases += $Alias_Line -replace ".*\s",""
                $counter_two += 1
              }        
            }
                  
            $counter += 1
          }
          
          $prop = [ordered]@{
            Name = $NameLine -replace ".*\s",""
            Addresses = $Addresses
            Aliases = $Aliases
          }
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
          
        }  
      }
    }
    
  }
  
  end {

    if ($CustomObject) {
      Write-Output $CustomObject | Select-Object * -Unique    
    }
        
    elseif ($CustomObject_ResolvedNames) {
      Write-Output $CustomObject_ResolvedNames
    }

  }


}
