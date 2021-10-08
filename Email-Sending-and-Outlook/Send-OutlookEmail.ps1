<#
.SYNOPSIS
  The "Send-OutlookEmail" function allows us to use PowerShell to send emails through Outlook ( run PowerShell in a non-Administrator shell - PowerShell needs to be running in the same security context as Outlook, which is probably not running as administrator ).

.DESCRIPTION
.EXAMPLE
  PS C:\> Send-OutlookEmail `
  >> -To 'Jannus.Fugal@MyDomain.com', 'GroupOne@MyDomain.com' `
  >> -Subject 'My Outlook + PowerShell Test' `
  >> -Body 'This is the body of the email' `
  >> -Attachment '.\simple.html', 'systems4.txt'



  Here we run the function by referencing two email recipients, the subject, the body of the email, and two attachments.  The attachments are in the same directory that the "Send-OutlookEmail" function is being run, so a full path is not needed.

.EXAMPLE
  PS C:\> Send-OutlookEmail `
  >> -Cc 'Jannus.Fugal@MyDomain.com' `
  >> -Bcc 'SecretGroup@MyDomain.com' `
  >> -Subject 'My Outlook + PowerShell Test - CC and BCC test' `
  >> -Body 'This is the body of the email for the CC and BCC test'



  Here we run the function and test out the CC and BCC functionality.  As expected, the CC recipient received the email but was not aware that the BCC recipient also received the same email.

.EXAMPLE
  PS C:\> $RecipientName = 'John'
  PS C:\>
  PS C:\> $Body = @"
  >> <!DOCTYPE html>
  >> <html>
  >> <head>
  >>  <meta charset='utf-8'>
  >>  <meta http-equiv='X-UA-Compatible' content='IE=edge'>
  >>  <title>Page Title</title>
  >>  <meta name='viewport' content='width=device-width, initial-scale=1'>
  >>  <link rel='stylesheet' type='text/css' media='screen' href='main.css'>
  >>  <script src='main.js'></script>
  >> </head>
  >> <body>
  >>  <p>
  >>  Hello $RecipientName,<br>
  >>  <br>
  >>  I can send an email to you, $RecipientName, using PowerShell and Outlook!!!. Hopefully you are ready for this! <br>
  >>  <br>
  >>  Regards, <br>
  >>  PoshUser <br>
  >>  </p>
  >> </body>
  >> </html>
  >> "@
  PS C:\>
  PS C:\> Send-OutlookEmail `
  >> -To 'Jannus.Fugal@MyDomain.com' `
  >> -Subject 'PowerShell using Outlook to send an HTML message!' `
  >> -Body $Body `
  >> -BodyAsHtml
  PS C:\>

  PS C:\> @" HERE IS WHAT THE EMAIL SAID WHEN IT WAS RECEIVED:
  >> 
  >> Hello John,
  >>
  >> I can send an email to you, John, using PowerShell and Outlook!!!. Hopefully you are ready for this!
  >>
  >> Regards,
  >> PoshUser
  >> "@



  Here we demonstrate how to send an email where the "Body" of the email is formatted as HTML.  In order to create the HTML body we used the built-in code snippet in Visual Studio Code for HTML documents called "HTML Sample", and simply modified the <body> section. This HTML example can be used as a template, and the <body> section can be modified to whatever the desired message might be.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Send-OutlookEmail.ps1
  Author:  Travis Logue
  Version History:  1.4 | 2021-09-11 | Updated aesthetics and Examples
  Dependencies:  Outlook.exe | Run PowerShell not as Administrator
  Notes:
  - This was helpful to get this initial code going -- "Send email from Outlook with Powershell !":  https://www.youtube.com/watch?v=m5I0Lk2uYIg

  - When I first was trying to use PowerShell + ComObjects with Outlook, I needed to run PowerShell in a non-administrative mode (which is how Outlook was running when I called this function) -- I found out about this because I received the same error mentioned in this post (which also mentions the solution):  https://stackoverflow.com/questions/29772500/powershell-cannot-create-outlook-com-object-from-command-prompt
    - This was the Error:  New-Object : Retrieving the COM class factory for component with CLSID {0006F03A-0000-0000-C000-000000000046} failed due to the following error: 80080005 Server execution failed (Exception from HRESULT: 0x80080005 (CO_E_SERVER_EXEC_FAILURE)).

  - Here is how I learned how to attach Attachments (with .Attachments.Add($MyDoc.Fullname)):  https://stackoverflow.com/questions/30742291/using-multiple-attachments-through-comobject-outlook-application


  . 
#>
function Send-OutlookEmail {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string[]]
    $To,
    [Parameter()]
    [string]
    $Subject,
    [Parameter()]
    [string]
    $Body,
    [Parameter()]
    [switch]
    $BodyAsHtml,
    [Parameter()]
    [string[]]
    $Attachment,
    [Parameter()]
    [string[]]
    $Cc,
    [Parameter()]
    [string[]]
    $Bcc
  )
  
  begin {}
  
  process {
    
    $OutlookComObject = New-Object -ComObject outlook.application

    # Create Item - "olMailItem" object
    $MailItem = $OutlookComObject.CreateItem('olMailItem')

    if (!($To) -and !($Cc) -and !($Bcc)) {
      $To = Read-Host "`nPlease enter in the desired email recipient(s)... "
    }

    # Recipients list, the "To:"
    $ToComObjectString = $To -join ';'

    # Carbon Copy list, the "CC:"
    $CcComObjectString = $Cc -join ';'

    # Blind Carbon Copy list, the "BCC:"
    $BccComObjectString = $Bcc -join ';'

    # Attachments - this code adds all of the referenced files as attachments to the email
    $FileObjects = @()
    foreach ($item in $Attachment) {
      $FileObjects += Get-Item $item
    }
    foreach ($obj in $FileObjects) {
      $MailItem.Attachments.Add($obj.FullName) | Out-Null
    }

    # Assigning everything else, and Sending the email
    $MailItem.To = $ToComObjectString
    $MailItem.CC = $CcComObjectString
    $MailItem.BCC = $BccComObjectString
    $MailItem.Subject = $Subject

    if ($BodyAsHtml) {
      $MailItem.HTMLBody = $Body
    }
    else {
      $MailItem.Body = $Body
    }

    $MailItem.Send()

  }
  
  end {}
}