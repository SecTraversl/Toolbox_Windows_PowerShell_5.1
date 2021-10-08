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
  Name:  Get-EmailInvestigationInternetHeaders.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-15 | Initial Version
  Dependencies:  Outlook.exe | Run PowerShell not as Administrator
  Notes:
  - This was the best syntax I found that allowed me to come to a good way to retrieve the Internet Headers for a ComObject Email ( That being -- $Email.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E") -- ) :  https://docs.microsoft.com/en-us/office/vba/api/Outlook.PropertyAccessor.GetProperty

  - This was the initial reference I was considering when trying to figure out how to get the Internet Headers in Outlook:  https://www.slipstick.com/developer/code-samples/outlooks-internet-headers/
  
  - This also looked to have good info regarding Internet Header data:  https://answers.microsoft.com/en-us/msoffice/forum/all/what-time-zone-are-you-in-can-you-view-an-email/607f33b8-d58e-4328-9b84-508d99a77af6

  - When I first was trying to use PowerShell + ComObjects with Outlook, I needed to run PowerShell in a non-administrative mode (which is how Outlook was running when I called this function) -- I found out about this because I received the same error mentioned in this post (which also mentions the solution):  https://stackoverflow.com/questions/29772500/powershell-cannot-create-outlook-com-object-from-command-prompt
    - This was the Error:  New-Object : Retrieving the COM class factory for component with CLSID {0006F03A-0000-0000-C000-000000000046} failed due to the following error: 80080005 Server execution failed (Exception from HRESULT: 0x80080005 (CO_E_SERVER_EXEC_FAILURE)).


  . 
#>
function Get-EmailInvestigationInternetHeaders {
  [CmdletBinding()]
  [Alias('EmailInvestigationInternetHeaders')]
  param (
    [Parameter(Mandatory)]
    [string]
    $SenderName
  )
  
  begin {}
  
  process {
    
    $OutlookComObject = New-Object -ComObject outlook.application
    $MapiNameSpace = $OutlookComObject.GetNamespace('MAPI')
    $EmailInvestigationsFolder = $MapiNameSpace.Folders('Jannus.Fugal@MyDomain.com').Folders('Email Investigations')

    $Email = $EmailInvestigationsFolder.Items | ? SenderName -like "*$SenderName*"

    $ObjectCount = ($Email | Measure-Object).Count 
    if ($ObjectCount -gt 1) {
      Write-Host "`nThere is more than one email matching that criterion...`nHere are the results:" -BackgroundColor Black -ForegroundColor Yellow
      $Email | Select-Object SenderName, ReceivedTime, Subject

      break
    }

    $InternetHeaders = $Email.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E")
    $InternetHeaders = $InternetHeaders -split "`r?`n"
    Write-Output $InternetHeaders

  }
  
  end {}
}