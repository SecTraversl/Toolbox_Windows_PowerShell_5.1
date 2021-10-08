<#
.SYNOPSIS
  The "New-PSCredentialToXmlFile" function takes an encrypted PSCredential object and saves that encrypted PSCredential to an .xml file, so it can be referenced by a script.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: New-PSCredentialToXmlFile.ps1
  Author: Travis Logue
  Version History: 1.0 | 2020-01-12 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in understanding this strategy: https://adamtheautomator.com/powershell-export-xml/


  .
#>
function New-PSCredentialToXmlFile {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the PSCredential to save to an .xml file.')]
    [pscredential]
    $PSCredential,
    [Parameter(HelpMessage='Reference ')]
    [string]
    $Path = ".\Credential.xml"
  )
  
  begin {}
  
  process {
    $PSCredential | Export-Clixml -Path $Path
  }
  
  end {}
}