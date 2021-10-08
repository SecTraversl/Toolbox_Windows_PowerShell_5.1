<#
.SYNOPSIS
  The "Get-PSObjectPropertyNames" function returns the property names pertaining to a given object.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> $WhoIs

  IPAddress           : 8.8.8.8
  registrationDate    : 2014-03-14T16:52:05-04:00
  customerRef_handle  :
  customerRef_name    :
  name                : LVLT-GOGL-8-8-8
  startAddress        : 8.8.8.0
  endAddress          : 8.8.8.255
  cidrLength          : 24
  orgRef_handle       : GOGL
  orgRef_name         : Google LLC
  parentNetRef_handle : NET-8-0-0-0-1
  parentNetRef_name   : LVLT-ORG-8-8
  updateDate          : 2014-03-14T16:52:05-04:00
  originAS            :


  PS C:\> PropNames $WhoIs
  cidrLength
  customerRef_handle
  customerRef_name
  endAddress
  IPAddress
  name
  orgRef_handle
  orgRef_name
  originAS
  parentNetRef_handle
  parentNetRef_name
  registrationDate
  startAddress



  Here we have an existing object in a variable called "$WhoIs".  We run the "Get-PSObjectPropertyNames" function using its built-in alias of 'PropNames' and reference the $WhoIs variable.  In return we receive a list of the Property names pertaining to the object.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-PSObjectPropertyNames.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-26 | Initial Version
  Dependencies:
  Notes:
    - I referenced the code in "Get-GeoIP.ps1" to come up with the strategy below

  .
#>
function Get-PSObjectPropertyNames {
  [CmdletBinding()]
  [Alias('PropNames')]
  param (
    [Parameter()]
    [psobject]
    $PSObject
  )
  
  begin {}
  
  process {
    ($PSObject | Get-Member -MemberType *Property*).Name
  }
  
  end {}
}