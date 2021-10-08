
#########################
# Good tips / tricks and tutorial here:
# - https://adamtheautomator.com/send-mailmessage/


function Send-EmailAlert {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Enter the Subject Line of the email')]
    [string]
    $Subject,
    [Parameter(HelpMessage = 'Switch Parameter that uses hardcoded values for the "From" and "To" values')]
    [switch]
    $Default,
    [string]
    $Body,
    [Parameter(HelpMessage = 'This Switch Parameter is used to specify that the Body parameter contains HTML.')]
    [switch]
    $BodyAsHtml
  )
  
  begin {

    $From = Read-Host 'From whom is the email being sent? Format should be "John Smith <john.smith@yourdomain.com>"'
    $To = Read-Host 'To whom is the email being sent? Format should be "John Smith <john.smith@yourdomain.com>"'
    $SMTP = Read-host 'What is the SMTP server DNS name? Example - "smtp.yourdomain.com"'

  }
  
  process {

    if ($Body) {
      if ($BodyAsHtml ) {
        Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTP -Body $Body -BodyAsHtml
      }
      else {
        Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTP -Body $Body
      }
      
    }
    else {
      Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTP
    }

  }
  
  end {
    
  }
}