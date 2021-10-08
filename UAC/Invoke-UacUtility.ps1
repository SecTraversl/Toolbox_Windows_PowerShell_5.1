<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Invoke-UacUtility.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-02-16 | Initial Version
  Dependencies: 
  Notes:
  - This was helpful for determining if UAC is enabled: https://stackoverflow.com/questions/3405122/get-uac-settings-using-powershell
  - This was helpful for guidance on "ConsentPromptBevhaviorAdmin" and " " : https://stackoverflow.com/questions/44409006/disabling-uac-with-powershell


  .
#>
function Invoke-UacUtility {
  [CmdletBinding()]
  param (
    [Parameter()]
    [switch]
    $UacStatus,
    [Parameter()]
    [switch]
    $DisableUacConsentPromptBehaviorAdmin,
    [Parameter()]
    [switch]
    $DisableUac
  )
  
  begin {}
  
  process {

    if (condition) {
      
    }
    $UacStatus = [bool](Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA

    $prop = @{
      UacEnabled = $UacStatus
    }

    elseif ($DisableUacConsentPromptBehaviorAdmin) {
      
      Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

    }

    elseif ($) {
      
      Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0
      Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

    }
     
  }
  
  end {}
}
