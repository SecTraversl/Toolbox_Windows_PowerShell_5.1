<#
.SYNOPSIS
  The "Get-UrlFromText" function takes a body of text as input and returns the URLs found within that body of text.

.DESCRIPTION
.EXAMPLE
  PS C:\> UrlFromText $x
  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "Url" and then pressing the Tab key allows us to toggle through any commands that start with "Url".  Since the "Get-UrlFromText" function has a built-in alias of 'UrlFromText' we are able to use this method to quickly access the function.

.EXAMPLE
  
  PS C:\> $z

  Dear Developer, 
  Starting March 3, 2021, additional authentication is required for all users to sign in to App Store Connect. This extra layer of security for your Apple ID helps ensure that you’re the only person who can access your account. When you sign in, you’ll be prompted to update your account. 
  If you have any questions, learn more <https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5hey6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J6i2P8M>  or contact us <https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5hey6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J3w3q3h> . 
  Best regards,
  Apple Developer Relations 
    
  TM and © 2021 Apple Inc.
  One Apple Park Way, MS 903-4DEV, Cupertino, CA 95014.
  All Rights Reserved <https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5hey6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J5B8y8P>  | Privacy Policy <https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5hey6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J5n6C8v>  | Account <https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5hey6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J7i3k5v> 
	

  PS C:\> Get-UrlFromText -Text $z -HxxpFormat

  Number Link
  ------ ----
  Link1  hxxps://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcn...
  Link2  hxxps://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcn...
  Link3  hxxps://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcn...
  Link4  hxxps://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcn...
  Link5  hxxps://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcn...


  PS C:\> Get-UrlFromText -Text $z -RawStringData
  https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5he
  y6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J6i2P8M
  https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5he
  y6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J3w3q3h
  https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5he
  y6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J5B8y8P
  https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5he
  y6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J5n6C8v
  https://c.apple.com/r?v=2&la=en&lc=usa&a=a0xgsmasGziWIglbv1wa1RxbUkCZFlcBs%2Fl5qhtS4RrQqeQVP3lcvdG1FTYAi4exIPbYUD4t%2BOvNcnZULgKvoG5he
  y6o%2FxE%2F85VrUm%2Bg8VsDuckwZM3mlI%2BLsggODFB3&ct=ac4J7i3k5v



  Here we have a body of text within the variable "$z".  We first run the function by explicitly specifying the "-Text" parameter and referencing the "$z" variable as the argument. We also specified the "-HxxpFormat" switch parameter, which replaces each occurrence of 'http' with 'hxxp', so that the link will not be "clickable" if we end up copying and pasting it.  The output contains the links from the body of text and the corresponding "Link Number" of each link.  The second time we run the function we specify the switch parameter "-RawStringData" which returns each link as a string, one per line.  This "-RawStringData" switch parameter can be useful especially in cases when we want to pipe directly to cmdlets like "Set-Clipboard".

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-UrlFromText.ps1
  Author:  Travis Logue
  Version History:  3.2 | 2021-05-27 | Overall Improvements, Examples, and In-line comments added
  Dependencies: Convert-ShauronProtectUrl.ps1 | Convert-UrlPercentEncoding.ps1
  Notes:
    - This was where I found the initial code used as the base for the function below - "Identifying Website Visitor IP Addresses Using PowerShell" by Jeff Hicks: https://www.petri.com/powershell-problem-solver


  .
#>
function Get-UrlFromText {
  [CmdletBinding()]
  [Alias('UrlFromText')]
  param (
    [Parameter(HelpMessage = 'Reference the body of text, such as a plain text email.')]
    [string[]]
    $Text,
    [Parameter(HelpMessage = 'This Switch Parameter outputs the links as simple strings, one link per line.')]
    [switch]
    $RawStringData,
    [Parameter(HelpMessage = 'This Switch Parameter replaces each occurrence of "http" with "hxxp".')]
    [switch]
    $HxxpFormat,
    [Parameter()]
    [switch]
    $ConvertShauronUrlProtection
  )
  
  begin {}
  
  process {

    # Here we take the whole body of email text, split on a space ' ', find the lines that have http:// or https://, and remove the '<' and '>' if they exist.  
    # Need to make sure that this is always an array, even if it only has 1 item in it, wo wrapping it in @( )  
    $Links = try {
      @( ($Text -split ' ' | ? { $_ -match "https?://" }).TrimStart('<').TrimEnd('>') )
    }
    catch {}

    if ($ConvertShauronUrlProtection) {
      $NewLinks = foreach ($Link in $Links) {
        if ($Link -like '*protect2.Shauron.com*') {
          $Link | Convert-ShauronProtectUrl
        }
        else {
          $Link
        }
      }

      $Links = $NewLinks
    }

    if ($HxxpFormat) {
      $Links = $Links -replace 'http', 'hxxp'
    }

    if ($RawStringData) {
      Write-Output $Links
    }
    else {
      for ($i = 0; $i -lt $Links.Count; $i++) {      
        $prop = [ordered]@{
          Number = "Link$($i+1)"
          URL    = @($Links)[$i]  # Need to make sure that this is always considered and array, even when there is one item, so wrapped it in @( )
        }
  
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
    }

  }
  
  end {}
}