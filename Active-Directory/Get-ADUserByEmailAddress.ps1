<#
.SYNOPSIS
  The "Get-ADUserByEmailAddress" function takes a given email address and searches Active Directory for User object(s) for which that email address applies.

.DESCRIPTION
.EXAMPLE

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADUserByEmailAddress.ps1
  Author:  Travis Logue
  Version History:  1.3 | 2021-08-25 | Added support for: Pipeline use and an Array of arguments; and changed Parameter name to "Mail"
  Dependencies:  Active Directory Module
  Notes:


  .  
#>
function Get-ADUserByEmailAddress {
  [CmdletBinding()]
  [Alias('ADUserByEmailAddress')]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $Mail,
    [Parameter()]
    [switch]
    $PartialMatch
  )
  
  begin {}
  
  process {

    foreach ($Email in $Mail) {
      
      if ($PartialMatch) {
        Get-ADUser -Filter "Mail -like '*$Email*'" -Properties Mail
      }
  
      Get-ADUser -Filter { Mail -eq $Email } -Properties Mail

    }

  }
  
  end {}
}