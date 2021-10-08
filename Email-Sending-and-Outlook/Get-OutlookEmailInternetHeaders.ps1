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
  Name:  Get-OutlookEmailInternetHeaders.ps1
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
function Get-OutlookEmailInternetHeaders {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Mailbox,
    [Parameter()]
    [string]
    $FolderPath
  )
  
  begin {}
  
  process {
    
    $OutlookComObject = New-Object -ComObject outlook.application
    $MapiNameSpace = $OutlookComObject.GetNamespace('MAPI')

    if ($Mailbox) {

      try {        
        $MailboxObject = $MapiNameSpace.Folders($Mailbox)
      }
      catch {
        Write-Host "`nPlease use the '-Mailbox' parameter and reference one of the following:`n" -BackgroundColor Black -ForegroundColor Yellow
        Write-Output ($MapiNameSpace.folders() | % { $_.Name })
        Write-Host ""        
        break
      }

    }
    else {
      Write-Host "`nPlease use the '-Mailbox' parameter and reference one of the following:`n" -BackgroundColor Black -ForegroundColor Yellow
      Write-Output ($MapiNameSpace.folders() | % { $_.Name })
      Write-Host ""
      break
    }
    
    if ($FolderPath) {
      try {

        $SplitPath = $FolderPath -split '\\'
        $FolderPathObject = $MailboxObject      
        foreach ($item in $SplitPath) {
          $FolderPathObject = $FolderPathObject.Folders($item)
        }

      }
      catch {

        Write-Host "`nAn error occurred with the following Error Message:`n$($Error[0].Exception.Message)`n" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "Make sure the folder you referenced exists and that you have the appropriate format for the '-FolderPath' parameter."
        Write-Host "`nReference the path of the folder/subfolder by using the '-FolderPath' parameter.`nFor instance, under your mailbox you have an 'Inbox' folder and if you have a subfolder within Inbox called 'Tools' you would provide the following text:" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "`n  'Inbox\Tools'`n"
        break
      }
    }
    else {
      Write-Host "`nReference the path of the folder/subfolder by using the '-FolderPath' parameter.`nFor instance, under your mailbox you have an 'Inbox' folder and if you have a subfolder within Inbox called 'Tools' you would provide the following text:" -BackgroundColor Black -ForegroundColor Yellow
      Write-Host "`n  'Inbox\Tools'`n"
      break
    }

    Write-Host "`nYou have selected the following Outlook folder: $($FolderPathObject.FolderPath)`n"

    $FirstEmail = $FolderPathObject | Select-Object -First 1

    $InternetHeadersForEmail = $FirstEmail.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E")

    Write-Output $InternetHeadersForEmail

  }
  
  end {}
}