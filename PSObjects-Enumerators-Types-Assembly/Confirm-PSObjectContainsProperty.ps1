<#
.SYNOPSIS
  The "Confirm-PSObjectContainsProperty" function is used to confirm that a given object has a given property.

.DESCRIPTION
.EXAMPLE
  PS C:\> $TestObject

  ip       : 52.36.251.118
  hostname : ec2-52-36-251-118.us-west-2.compute.amazonaws.com
  city     : Portland
  region   : Oregon
  country  : US
  loc      : 45.5234,-122.6762
  org      : AS16509 Amazon.com, Inc.
  postal   : 97207
  timezone : America/Los_Angeles
  readme   : https://ipinfo.io/missingauth


  PS C:\> $AnotherTestObject

  ip       : 172.58.59.182
  city     : Germantown
  region   : Wisconsin
  country  : US
  loc      : 43.2286,-88.1104
  org      : AS21928 T-Mobile USA, Inc.
  postal   : 53022
  timezone : America/Chicago
  readme   : https://ipinfo.io/missingauth


  PS C:\> Confirm-PSObjectContainsProperty -Object $TestObject -PropertyName 'hostname'
  True
  PS C:\> Confirm-PSObjectContainsProperty -Object $TestObject -PropertyName 'host'
  False
  PS C:\> Confirm-PSObjectContainsProperty -Object $TestObject -PropertyName 'host' -FuzzyMatch
  True
  PS C:\>
  PS C:\> Confirm-PSObjectContainsProperty $AnotherTestObject 'hostname'
  False
  PS C:\> $AnotherTestObject | Add-Member -MemberType NoteProperty -Name 'hostname' -Value $null
  PS C:\> Confirm-PSObjectContainsProperty $AnotherTestObject 'hostname'
  True
  PS C:\> Confirm-PSObjectContainsProperty $AnotherTestObject 'host'
  False
  PS C:\> Confirm-PSObjectContainsProperty $AnotherTestObject 'host' -FuzzyMatch
  True



  Here we display two different Objects ("$TestObject" and "$AnotherTestObject") and their Properties.  We then use the "Confirm-PSObjectContainsProperty" function to validate if the objects contain a property named "hostname". We also demonstrate the use of the "-FuzzyMatch" switch parameter, and we see that since the word 'host' is in the property name of 'hostname' that we get a Boolean "$true" back when we do that query.  Finally, we use the "Add-Member" cmdlet to add the 'hostname' property to the $AnotherTestObject object, and then validate it worked by using the "Confirm-PSObjectContainsProperty" function again.

.INPUTS
.OUTPUTS
.NOTES
  Name: Confirm-PSObjectContainsProperty.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-09 | Initial Version
  Dependencies:
  Notes:
  - This was a helpful forum post in creating this function: https://stackoverflow.com/questions/26997511/how-can-you-test-if-an-object-has-a-specific-property

  
  .
#>
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
  
  begin {}
  
  process {
    
    if ($FuzzyMatch) {
      # If we give a "-PropertyName" of 'host' and the Object has a property with a name of "hostname" then the evaluation, using this syntax,  will be counted as $true
      [bool]($Object.PSobject.Properties.name -match $PropertyName)
    }
    else {
      # Here we are looking for an exact property name match
      $PropertyName -in $Object.PSobject.Properties.name     
    }

  }
  
  end {}
}