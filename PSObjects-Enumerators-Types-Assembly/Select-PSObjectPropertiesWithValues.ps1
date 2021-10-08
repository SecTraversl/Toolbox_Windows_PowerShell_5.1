<#
.SYNOPSIS
  The "Select-PSObjectPropertiesWithValues" function takes a given object and returns only the Properties that do not contain a "$null" value.

.DESCRIPTION
.EXAMPLE
  PS C:\> $boingtapBaseline

  fuzzer          : bitsquatting
  domain-name     : boingtap.com
  dns-a           : 208.54.117.197
  dns-aaaa        :
  dns-mx          :
  dns-ns          : dns101.registrar-servers.com
  geoip-country   :
  whois-registrar :
  whois-created   :
  ssdeep-score    :


  PS C:\> $boingtapBaseline | PropsWithValues

  fuzzer       domain-name  dns-a          dns-ns
  ------       -----------  -----          ------
  bitsquatting boingtap.com 208.54.117.197 dns101.registrar-servers.com



  Here we first display the output of an the object captured in the "$boingtapBaseline" variable.  We then pipe that variable to the "Select-PSObjectPropertiesWithValues" function using its built-in alias of 'PropsWithValues' and in return only the properties containing values are displayed.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Select-PSObjectPropertiesWithValues.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-26 | Initial Version
  Dependencies: 
  Notes:
  - This was a helpful reference while building the code below: https://stackoverflow.com/questions/44368990/how-do-i-get-properties-that-only-have-populated-values


  .
#>
function Select-PSObjectPropertiesWithValues {
  [CmdletBinding()]
  [Alias('PropsWithValues')]
  param (
    [Parameter(ValueFromPipeline=$true)]
    [psobject]
    $PSObject
  )
  
  begin {}
  
  process {

    $PropertiesWithValues = ($PSObject.PSObject.Properties | ? {$_.Value -notlike $null}).name
    $PSObject | Select-Object -Property $PropertiesWithValues

  }

  end {}
}