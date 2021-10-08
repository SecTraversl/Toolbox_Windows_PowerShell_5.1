<#
.SYNOPSIS
  The "Save-OutlookAttachmentsForFolder" function allows us to use PowerShell to download all of the attachments to emails in a given Outlook folder.  *IMPORTANT*: Run PowerShell in a non-Administrator shell - PowerShell needs to be running in the same security context as Outlook, which is probably not running as administrator.

.DESCRIPTION
.EXAMPLE
  PS C:\> Save-OutlookAttachmentsForFolder
  Please use the '-Mailbox' parameter and reference one of the following:

  Jannus.Fugal@MyDomain.com
  UserTwo
  
  PS C:\>
  PS C:\> Save-OutlookAttachmentsForFolder -Mailbox Jannus.Fugal@MyDomain.com

  Reference the path of the folder/subfolder by using the '-FolderPath' parameter.
  For instance, under your mailbox you have an 'Inbox' folder and if you have a subfolder within Inbox called 'Tools' you would provide
  the following text:

    'Inbox\Tools'

  PS C:\>
  PS C:\> Save-OutlookAttachmentsForFolder -Mailbox Jannus.Fugal@MyDomain.com  -FolderPath 'Test Folder' -Destination '.\Downloaded Attachments\'

  You have selected the following Outlook folder: \\Jannus.Fugal@MyDomain.com\Test Folder

  PS C:\> ls '.\Downloaded Attachments\'


      Directory: C:\Downloaded Attachments


  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a----          9/1/2021   7:49 PM          60782 2021-09-15_0947.11.8130__MyDomain Accounting Reports__Atch-1__statement.txt
  -a----          9/1/2021   7:49 PM         595605 2021-09-15_0947.11.8130__MyDomain Accounting Reports__Atch-2__voucher.txt
  -a----          9/1/2021   7:49 PM          10999 2021-09-15_0947.15.6420__MyDomain Accounting Reports__Atch-1__statement.txt
  -a----          9/1/2021   7:49 PM          92010 2021-09-15_0947.15.6420__MyDomain Accounting Reports__Atch-2__voucher.txt
  -a----          9/1/2021   7:49 PM           1642 2021-09-15_0947.16.5910__MyDomain Accounting Reports__Atch-1__summary.txt
  -a----          9/1/2021   7:49 PM           1427 2021-09-15_0947.16.5910__MyDomain Accounting Reports__Atch-2__outstanding_bal.txt
  -a----          9/1/2021   7:49 PM           5416 2021-09-15_0947.16.5910__MyDomain Accounting Reports__Atch-3__voucher.txt
  -a----          9/1/2021   7:49 PM          21064 2021-09-15_0947.17.5640__MyDomain Accounting Reports__Atch-1__summary.txt
  -a----          9/1/2021   7:49 PM           6014 2021-09-15_0947.17.5640__MyDomain Accounting Reports__Atch-2__pickup.txt
  -a----          9/1/2021   7:49 PM          15495 2021-09-15_0947.17.5640__MyDomain Accounting Reports__Atch-3__voucher_summary.txt
  -a----          9/1/2021   7:49 PM          17673 2021-09-15_0947.17.5640__MyDomain Accounting Reports__Atch-4__outstanding_bal.txt
  -a----          9/1/2021   7:49 PM         132175 2021-09-15_0947.17.5640__MyDomain Accounting Reports__Atch-5__voucher.txt



  Here we demonstrate some default usage of the function.  First, we run the tool without any parameters or arguments, and we receive feedback about what Mailboxes are currently attached to our Outlook program.  We choose one of the mailboxes and supply that as the argument for the "-Mailbox" parameter. Again, we receive feedback that we must specify a certain Outlook folder.  We then choose a certain folder in the particular Outlook mailbox for which we want to download all of the attachments for the emails contained therein.  We specify the Outlook folder called "Test Folder" and we also specify a "-Destination" location on our computer where we want the attachments to be saved.  Finally, we view the downloaded attachments.  The default behavior of the function is to save each attachment by prepending to the original attachment name the following:  First, the Received Date / Timestamp of the email (yyyy-MM-dd_HHmm.ss.ffff - this allows us a way to differentiate one unique email from another), then the "Subject" of the email from where the attachment came, and then the attachment number (relating to the first, second, third, etc. attachment in that particular email).  In our example above, we are looking at the attachments of 4 different emails (which we can see because the timestamps for different emails are unique), all of which have the same "Subject" title, and some of which have attachments with the same name as previous emails.

.EXAMPLE
  PS C:\> rm '.\Downloaded Attachments\*'
  PS C:\>
  PS C:\> Save-OutlookAttachmentsForFolder -Mailbox Jannus.Fugal@MyDomain.com  -FolderPath 'Test Folder' -Destination '.\Downloaded Attachments\' -SimpleCounterWithAttachmentName

  You have selected the following Outlook folder: \\Jannus.Fugal@MyDomain.com\Test Folder

  PS C:\> ls '.\Downloaded Attachments\'


      Directory: C:\Downloaded Attachments


  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a----          9/1/2021   7:49 PM          15495 Atch-10__voucher_summary.txt
  -a----          9/1/2021   7:49 PM          17673 Atch-11__outstanding_bal.txt
  -a----          9/1/2021   7:49 PM         132175 Atch-12__voucher.txt
  -a----          9/1/2021   7:49 PM          60782 Atch-1__statement.txt
  -a----          9/1/2021   7:49 PM         595605 Atch-2__voucher.txt
  -a----          9/1/2021   7:49 PM          10999 Atch-3__statement.txt
  -a----          9/1/2021   7:49 PM          92010 Atch-4__voucher.txt
  -a----          9/1/2021   7:49 PM           1642 Atch-5__summary.txt
  -a----          9/1/2021   7:49 PM           1427 Atch-6__outstanding_bal.txt
  -a----          9/1/2021   7:49 PM           5416 Atch-7__voucher.txt
  -a----          9/1/2021   7:49 PM          21064 Atch-8__summary.txt
  -a----          9/1/2021   7:49 PM           6014 Atch-9__pickup.txt



  Here we first remove the files we downloaded in Example 1.  Next, we run the function again, as we did in Example 1, but with the additional switch parameter of "-SimpleCounterWithAttachmentName".  We then inspect the results of the downloaded attachments, and see that by adding this particular switch parameter we changed the output naming convention with which the attachments were saved.

.EXAMPLE
  PS C:\> rm '.\Downloaded Attachments\*'
  PS C:\>
  PS C:\> Save-OutlookAttachmentsForFolder -Mailbox Jannus.Fugal@MyDomain.com  -FolderPath 'Test Folder' -Destination '.\Downloaded Attachments\' -KeepOriginalAttachmentName

  You have selected the following Outlook folder: \\Jannus.Fugal@MyDomain.com\Test Folder

  PS C:\> ls '.\Downloaded Attachments\'


      Directory: C:\Downloaded Attachments


  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a----          9/1/2021   7:49 PM          17673 outstanding_bal.txt
  -a----          9/1/2021   7:49 PM           6014 pickup.txt
  -a----          9/1/2021   7:49 PM          10999 statement.txt
  -a----          9/1/2021   7:49 PM          21064 summary.txt
  -a----          9/1/2021   7:49 PM         132175 voucher.txt
  -a----          9/1/2021   7:49 PM          15495 voucher_summary.txt



  Here we first remove the files we downloaded in the previous example.  Next, we run the function again, as we did in Example 2, but this time using the switch parameter of "-KeepOriginalAttachmentName".  We then inspect the results of the downloaded attachments, and see that by adding this particular switch parameter we changed the output naming convention with which the attachments were saved.  *IMPORTANT* - This switch parameter allows for the potential overwriting of some of the previous Attachments.  This is because, two files of the same name cannot exist in the same directory on a Windows system, and the last file of that name will be kept, overwriting the previous one(s). 

.INPUTS
.OUTPUTS
.NOTES
  Name:  Save-OutlookAttachmentsForFolder.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-17 | Started using "ReceivedTime" instead of email "CreationTime"
  Dependencies:  Outlook.exe | Run PowerShell not as Administrator
  Notes:
  - When I first was trying to use PowerShell + ComObjects with Outlook, I needed to run PowerShell in a non-administrative mode (which is how Outlook was running when I called this function) -- I found out about this because I received the same error mentioned in this post (which also mentions the solution):  https://stackoverflow.com/questions/29772500/powershell-cannot-create-outlook-com-object-from-command-prompt
    - This was the Error:  New-Object : Retrieving the COM class factory for component with CLSID {0006F03A-0000-0000-C000-000000000046} failed due to the following error: 80080005 Server execution failed (Exception from HRESULT: 0x80080005 (CO_E_SERVER_EXEC_FAILURE)).
  
  . 
#>

function Save-OutlookAttachmentsForFolder {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Mailbox,
    [Parameter()]
    [string]
    $FolderPath,
    [Parameter()]
    [string]
    $Destination = ".",
    [Parameter(HelpMessage = 'Each attachment saved will have a simple counter number prepended to the name of the saved attachment.  This counter will be incremented for every attachment, and is not email specific.')]
    [switch]
    $SimpleCounterWithAttachmentName,
    [Parameter(HelpMessage = 'WARNING... This will save the attachments with the original name of the file as seen in the email.  If there are attachments with the same name all but one will be overwritten by using this switch parameter.')]
    [switch]
    $KeepOriginalAttachmentName
  )
  
  begin {}
  
  process {
    
    $OutlookComObject = New-Object -ComObject outlook.application
    $MapiNameSpace = $OutlookComObject.GetNamespace('MAPI')

    $DestinationPath = (Get-Item $Destination).FullName

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

    if ($SimpleCounterWithAttachmentName) {

      $Counter = 1

      foreach ($item in $FolderPathObject.Items) {
        $Subject = $item.subject
        $ReceivedTime = $item.ReceivedTime.ToString('yyyy-MM-dd_HHmm.ss.ffff')
      
        $Attachments = $item.Attachments        
      
        foreach ($Attach in $Attachments) {
          $NewAttachmentName = "$('Atch-' + [string]$Counter)__$($Attach.FileName)"
          $Attach.SaveAsFile("$DestinationPath\$NewAttachmentName")
          $Counter += 1
          $NewAttachmentName = $null
        }

      }

    }
    else {

      foreach ($item in $FolderPathObject.Items) {
        $Subject = $item.subject
        $ReceivedTime = $item.ReceivedTime.ToString('yyyy-MM-dd_HHmm.ss.ffff')
    
        $Attachments = $item.Attachments
        $Counter = 1
    
        if ($KeepOriginalAttachmentName) {

          foreach ($Attach in $Attachments) {
            $NewAttachmentName = "$($Attach.FileName)"
            $Attach.SaveAsFile("$DestinationPath\$NewAttachmentName")
            $NewAttachmentName = $null
          }
        
        }
        else {

          foreach ($Attach in $Attachments) {
            $NewAttachmentName = "$($ReceivedTime)__$($Subject)__$('Atch-' + [string]$Counter)__$($Attach.FileName)"
            $Attach.SaveAsFile("$DestinationPath\$NewAttachmentName")
            $Counter += 1
            $NewAttachmentName = $null
          }
        
        }

      }
    
    }
    

  }
  
  end {}
}

