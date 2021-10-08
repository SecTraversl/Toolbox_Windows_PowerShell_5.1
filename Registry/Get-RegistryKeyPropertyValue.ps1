<#
.SYNOPSIS
  The "Get-RegistryKeyPropertyValue" function takes a given Registry Path and a Property name, and returns the value of the Property.  If the Property does not exist, an error is returned stating so.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> RegKeyPropValue -FullPath HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ -Property NoLmHash
  1

  PS C:\> RegKeyPropValue -FullPath HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ -Property LocalAccountTokenFilterPolicy
  Property LocalAccountTokenFilterPolicy does not exist at path HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\.


  Here we run the function twice with two different tests.  In both examples, we invoke the "Get-RegistryKeyPropertyValue" using its built-in alias of 'RegKeyPropValue' In the first example, we se that not only does the Path and Property exist, but that this particular Registry Key Property is "on" because it has a value of "1".  In the second example, we see that the Property name given does not exist, and that we will need to create that Property if we want to set a value to it.

.INPUTS
.OUTPUTS
.NOTES
  General notes
#>
function Get-RegistryKeyPropertyValue {
  [CmdletBinding()]
  [Alias('RegKeyPropValue')]
  param (
    [Parameter()]
    [string]
    $FullPath,
    [Parameter()]
    [string]
    $Property
  )
  
  begin {}
  
  process {
    
    try {
      Get-ItemPropertyValue -Path $FullPath -Name $Property
      Write-Host ''
    }
    catch [System.Management.Automation.PSArgumentException] {
      $Error[0].Exception
      Write-Host ''
    }

  }
  
  end {}
}