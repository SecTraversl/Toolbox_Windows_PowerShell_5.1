<#
.SYNOPSIS
  The "Get-EmailInvestigationSenderIPAddress" function uses PowerShell + Outlook.exe in order to search through a designated email's Internet Headers and return the IP Address of the source SMTP server of that email.  This function will look at the designated user's mailbox in Outlook.exe (which is hard-coded into the function), and specifically in a folder by the name of 'Email Investigations' for an email sent by the given '-SenderName'.

.DESCRIPTION
.EXAMPLE
  PS C:\> $IPAddress = EmailInvestigationSenderIPAddress -SenderName "Google Ads"

  Here are the 'Received:' lines in the Internet Headers:

  Received: from DM8PR16MB4422.namprd16.prod.outlook.com (2603:10b6:8:1::13) by
  Received: from BN0PR04CA0083.namprd04.prod.outlook.com (2603:10b6:408:ea::28)
  Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
  Received: from mail.MyDomain.com (104.108.143.42) by
  Received: from SEAMailbox1.subd.MyDomain.com (10.30.47.20) by
  Received: from mx.us.email.shauroncloud.com (10.30.233.110) by
  Received: from [10.88.251.132] ([10.88.251.132:34578] helo=smtp-injection-worker)
  Received: from [10.88.221.232] ([10.88.221.232:45743] helo=use1-etp-emps-inbound-prd09-03.vex)
  Received: from localhost.localdomain (localhost [127.0.0.1])
  Received: from ex-wrapper (ip-10-88-250-47.ec2.internal [10.88.250.47])
  Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
  Received: by mail-il1-f200.google.com with SMTP id c5-20020a92c785000000b0023471480cafso3169004ilk.8
  X-Received: by 2002:a92:dc85:: with SMTP id c5mr1253486iln.104.1631734011936;

  Here is what we derived the Source SMTP server IP Address to be:


  PS C:\> $IPAddress
  209.85.166.200



  Here we are run the function by specifying the '-SenderName' of the email we want to further inspect. This email was sent by "Google Ads" and we moved the email into our "Email Investigations" folder in our Outlook mailbox (e.g. the .FolderPath would be equivalent to: '\\Jannus.Fugal@MyDomain.com\Email Investigations').  The '-SenderName' will do a wilcard search, so we could have used "ads" as an argument and that would have worked, too.  The function returns most of the initial output as just screen text using "Write-Host", but returns the final IP Address believed to be the IP Address of the sending SMTP server using "Write-Output" (which is what allowed us to capture the IP Address in the variable $IPAddress).  The initial "Received:" lines output is presented simply as a means of verification, in case the chosen final IP Address was not what we thought it should be.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-EmailInvestigationSenderIPAddress.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-16 | Initial Version
  Dependencies:  Outlook.exe | Run PowerShell not as Administrator
  Notes:
  - This was the best syntax I found that allowed me to come to a good way to retrieve the Internet Headers for a ComObject Email ( That being -- $Email.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E") -- ) :  https://docs.microsoft.com/en-us/office/vba/api/Outlook.PropertyAccessor.GetProperty

  - This was the initial reference I was considering when trying to figure out how to get the Internet Headers in Outlook:  https://www.slipstick.com/developer/code-samples/outlooks-internet-headers/
  
  - This also looked to have good info regarding Internet Header data:  https://answers.microsoft.com/en-us/msoffice/forum/all/what-time-zone-are-you-in-can-you-view-an-email/607f33b8-d58e-4328-9b84-508d99a77af6

  - When I first was trying to use PowerShell + ComObjects with Outlook, I needed to run PowerShell in a non-administrative mode (which is how Outlook was running when I called this function) -- I found out about this because I received the same error mentioned in this post (which also mentions the solution):  https://stackoverflow.com/questions/29772500/powershell-cannot-create-outlook-com-object-from-command-prompt
    - This was the Error:  New-Object : Retrieving the COM class factory for component with CLSID {0006F03A-0000-0000-C000-000000000046} failed due to the following error: 80080005 Server execution failed (Exception from HRESULT: 0x80080005 (CO_E_SERVER_EXEC_FAILURE)).


  . 
#>
function Get-EmailInvestigationSenderIPAddress {
  [CmdletBinding()]
  [Alias('EmailInvestigationSenderIPAddress')]
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
    
    $Received = $InternetHeaders | Select-String "Received:"
    $FirstFromIPAddress = ($InternetHeaders | Select-String "Received: from")[-1]
    $SenderIPAddress = $FirstFromIPAddress -replace ".*\[" -replace "\].*"


    Write-Host "`nHere are the 'Received:' lines in the Internet Headers:`n" -ForegroundColor Yellow -BackgroundColor Black
    $Received | % { Write-Host $_ }
    Write-Host "`nHere is what we derived the Source SMTP server IP Address to be:`n" -ForegroundColor Yellow -BackgroundColor Black
    Write-Output $SenderIPAddress
    Write-Host ""

  }
  
  end {}
}