<#
.SYNOPSIS
  The "Invoke-WindowsFWConnLoggingUtility" function allows for interaction with the Windows Firewall 'Filtering Platform Connection' settings.  
.DESCRIPTION
.EXAMPLE
  PS C:\> Invoke-WindowsFWConnLoggingUtility -IsConnectionAuditingEnabled

  Now running...:  'auditpol.exe /get /category:* | Select-String "Filter"'


    Filtering Platform Packet Drop          No Auditing
    Filtering Platform Connection           No Auditing
    Filtering Platform Policy Change        No Auditing

  Here we run the function with the "-IsConnectionAuditingEnabled" switch parameter.  The resulting output show that 'No Auditing' is configured at this time.

.INPUTS
.OUTPUTS
.NOTES
  Name: Invoke-WindowsFWConnLoggingUtility.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-02-06 | Made semantic wording and code improvements
  Dependencies: Administrative shell
  Notes:


  .
  #>
function Invoke-WindowsFWConnLoggingUtility {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Checks the current Auditing status of the "Filtering Platform Connection" settings')]
    [switch]
    $IsConnectionAuditingEnabled,
    [Parameter(HelpMessage='Turns off auditing / logging to the Security Log')]
    [switch]
    $StopAuditing,
    [Parameter(HelpMessage='Choose what you want to start auditing / logging to Security Log {Event ID 5156 for Allowed Connections; Event ID 5157 for Blocked Connections}. Default Value is "SuccessAndFailure"')]
    [ValidateSet('Success','Failure','SuccessAndFailure')]
    [string]
    $StartAuditing = 'SuccessAndFailure'
  )
  
  begin {}
  
  process {
    if ($IsConnectionAuditingEnabled) {
      Write-Host "`nNow running...:  'auditpol.exe /get /category:* | Select-String `"Filter`"'`n" -BackgroundColor Black -ForegroundColor Yellow
      auditpol.exe /get /category:* | Select-String "Filter"
    }
    elseif ($StopAuditing) {
      Write-Host "`nNow running...:  'auditpol.exe /get /category:* | Select-String `"Filter`"'`n" -BackgroundColor Black -ForegroundColor Yellow
      auditpol.exe /set /subcategory:"Filtering Platform Connection" /success:disable /failure:disable
    }
    elseif ($StartAuditing) {
      switch ($StartAuditing) {
        'Success' { auditpol.exe /set /subcategory:"Filtering Platform Connection" /success:enable }
        'Failure' { auditpol.exe /set /subcategory:"Filtering Platform Connection" /failure:enable }
        'SuccessAndFailure' { auditpol.exe /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable}
      }
    }
  }
  
  end {}
}