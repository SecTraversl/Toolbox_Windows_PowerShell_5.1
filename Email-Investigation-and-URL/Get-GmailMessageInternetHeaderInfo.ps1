<#
.SYNOPSIS
  The "Get-GmailMessageInternetHeaderInfo" function takes the 'message Internet Headers' from an email sent by a Gmail address and returns useful information about the sender of the email, including the:  SendersInternalIP, SendersExternalIP, UserAgent (if applicable), and possibly the device type that was used to send the email (XMailer). 

.DESCRIPTION
.EXAMPLE
  PS C:\> GmailHeaderInfo -MessageInternetHeaders $headers

  SendersInternalIP : 10.6.6.74
  SendersExternalIP : 73.45.33.125
  Received          : from [10.6.6.74] (c-73-43-33-125.hsd1.wa.comcast.net. [73.45.33.125]) by smtp.gmail.com with ESMTPSA id
                      u126sm354944pfu.113.2021.01.05.14.54.30 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128); Tue,
                      05 Jan 2021 14:54:30 -0800 (PST)
  From              : Cyan <FossMyMan@gmail.com>
  To                :
  Date              : Tue, 5 Jan 2021 14:54:30 -0800
  UserAgent         :
  XMailer           : iPhone Mail (16G140)
  Subject           : Fwd: test BCC to Marvin and Cyan Roxboard

  

  Here we are demonstrating a fast way to invoke this function.  The function "Get-GmailMessageInternetHeaderInfo" has a built-in alias of 'GmailHeaderInfo', which we use in the example above.  This email was sent to our email inbox, we used our email client in order to copy the "message Internet headers" from the email, and we placed those "message Internet headers" inside of the variable '$headers'.  It is important to note, that this email was sent to our email address such that we have been "BCC'd"; which is why in the output above, there is nothing in the "To" property.  Often with Gmail, we will get the sending user's internal network IP Address ("10.6.6.74") as well as their local external IP Address ("73.45.33.125"). 

.EXAMPLE
  PS C:\> GmailHeaderInfo -FilePath '.\Outlook Message Format - Fwd test BCC to Marvin and Cyan Roxboard.msg'

  SendersInternalIP : 10.6.6.74
  SendersExternalIP : 73.45.33.125
  Received          : from [10.6.6.74] (c-73-43-33-125.hsd1.wa.comcast.net. [73.45.33.125]) by smtp.gmail.com with ESMTPSA id
                      u126sm354944pfu.113.2021.01.05.14.54.30 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128); Tue,
                      05 Jan 2021 14:54:30 -0800 (PST)
  From              : Cyan <FossCyanc@gmail.com>
  To                :
  Date              : Tue, 5 Jan 2021 14:54:30 -0800
  UserAgent         :
  XMailer           : iPhone Mail (16G140)
  Subject           : Fwd: test BCC to Marvin and Cyan Roxboard



  Here we are focusing on the same email as the previous example, except this time we saved the entire email as a file.  To do this using Outlook 2016 we opened up the email so that it is full screen (not the Reading Pane), then we clicked: File > Save As > change "Save as type:" to 'Outlook Message Format (*.msg)', and save the file with the desired File Name.  After the email is saved as the appropriate file type, we are able to use the "Get-GmailMessageInternetHeaderInfo" or its built-in alias 'GmailHeaderInfo' by specifying  the "-FilePath" parameter and referencing the path to the email file we saved.

.EXAMPLE
  PS C:\> GmailHeaderInfo -FilePath .\stevhew45@gmail.com_email-with-headers.txt

  SendersInternalIP :
  SendersExternalIP : 154.21.208.188
  Received          : from welcome-PC ([154.21.208.188]) by smtp.gmail.com with ESMTPSA id y123sm9684442pfb.122.2021.02.26.06.06.38
                      for <Orion.Gurner@Roxboard.com> (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128); Fri, 26 Feb 2021
                      06:06:40 -0800 (PST)
  From              : steve <stevhew45@gmail.com>
  To                : Orion.Gurner@Roxboard.com
  Date              : Fri, 26 Feb 2021 06:06:40 -0800 (PST)
  UserAgent         :
  XMailer           :
  Subject           : Order ID : AW71-81JF-QM4C-85VM


  PS C:\> GmailHeaderInfo -FilePath .\rubygregfss@gmail.com_email-with-headers.txt

  SendersInternalIP :
  SendersExternalIP : 103.230.142.228
  Received          : from itsolution ([103.230.142.228]) by smtp.gmail.com with ESMTPSA id i184sm2776829pfe.19.2021.02.18.03.13.33
                      for <Barteus.Caketon@Roxboard.com> (version=TLS1 cipher=DES-CBC3-SHA bits=112/168); Thu, 18 Feb 2021 03:13:35
                      -0800 (PST)
  From              : "g-e-e-k- billing team" <rubygregfss@gmail.com>
  To                : "Barteus.Caketon@Roxboard.com" <Barteus.Caketon@Roxboard.com>
  Date              : Thu, 18 Feb 2021 04:35:45 +1200
  UserAgent         :
  XMailer           :
  Subject           : invoice



  Here we have two different phishing emails that were downloaded with the original "message Internet Headers".  We run the function using the "-FilePath" parameter and reference the path to each of the files.  While there was no reference within the "message Internet Headers" to the internal/private RFC1918 address of the sender (the "SendersInternalIP"), we still retrieved the public IP Address of the email sender.  We can now use this public IP Address and do WhoIs and GeoIP lookups to gain further information.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-GmailMessageInternetHeaderInfo.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-02 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-GmailMessageInternetHeaderInfo {
  [CmdletBinding()]
  [Alias('GmailHeaderInfo')]
  param (
    [Parameter()]
    [string[]]
    $MessageInternetHeaders,
    [Parameter()]
    [string]
    $FilePath
  )
  
  begin {}
  
  process {

    if ($MessageInternetHeaders) {
      $Content = $MessageInternetHeaders
    }
    elseif ($FilePath) {
      $Content = Get-Content $FilePath
    } 
    else {
      break
    }
   
    $Lines = $Content + "END OF THE LINE"    
      
    for ($i = 0; $i -lt $Lines.Count; $i++) {

      if ($Lines[$i] -like "X-Received:*") {

        $counter = 0

        do {

          $miniCounter = 0

          switch -regex ($Lines[$i + $counter]) {
            
            '^Received:' {
              do {
                $Received += $Lines[$i + $counter + $miniCounter] -replace "^Received: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            }
            '^From:' {
              do {
                $From += $Lines[$i + $counter + $miniCounter] -replace "^From: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            }
            '^To:' {
              do {
                $To += $Lines[$i + $counter + $miniCounter] -replace "^To: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            }
            '^Date:' {
              do {
                $Date += $Lines[$i + $counter + $miniCounter] -replace "^Date: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            }
            '^User-Agent:' {
              do {
                $UserAgent += $Lines[$i + $counter + $miniCounter] -replace "^User-Agent: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            } # not always there
            '^X-Mailer:' {
              do {
                $XMailer += $Lines[$i + $counter + $miniCounter] -replace "^X-Mailer: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            } # not always there
            '^Subject:' {
              do {
                $Subject += $Lines[$i + $counter + $miniCounter] -replace "^Subject: "
                $miniCounter += 1
              } until ($Lines[$i + $counter + $miniCounter] -notmatch "^\s")
            }

          }

          $counter += 1

        } until ( 

          ($Lines[$i + $counter] -like "X-FE-ETP-METADATA:*") -or 
          ($Lines[$i + $counter] -like "END OF THE LINE") 

        )

        [array]$IPAddresses = $Received -split ' ' | ? { $_ -match "\[*\]" }
        if ($IPAddresses.Count -gt 1) {
          $SendersInternalIP = $IPAddresses[0] -replace ".*\[" -replace "\].*"
          $SendersExternalIP = $IPAddresses[1] -replace ".*\[" -replace "\].*"
        }
        else {
          $SendersInternalIP = $null
          $SendersExternalIP = $IPAddresses[0] -replace ".*\[" -replace "\].*"
        }

        
        $prop = [ordered]@{
          SendersInternalIP = $SendersInternalIP
          SendersExternalIP = $SendersExternalIP
          Received          = $Received
          From              = $From
          To                = $To
          Date              = $Date
          UserAgent         = $UserAgent  # not always there
          XMailer           = $XMailer # not always there
          Subject           = $Subject          
        }

        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj


      }
    }


  }
  
  end {}
}