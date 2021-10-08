

<#
.SYNOPSIS
  The "New-7zipEncryptedArchive" function is a PowerShell wrapper for 7z.exe that creates a new 7-Zip Encrypted archive.

.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  New-7zipEncryptedArchive.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2020-10-31 | Initial Version
  Dependencies:  7z.exe in Path
  Notes:
  - This was the post the fostered the idea in the first place, good examples of running any .exe with Parameters: https://stackoverflow.com/questions/3592851/executing-a-command-stored-in-a-variable-from-powershell?rq=1

    Here is yet another way without Invoke-Expression but with two variables (command:string and parameters:array). It works fine for me. Assume 7z.exe is in the system path.

      $cmd = '7z.exe'
      $prm = 'a', '-tzip', 'c:\temp\with space\test1.zip', 'C:\TEMP\with space\changelog'

      & $cmd $prm
      If the command is known (7z.exe) and only parameters are variable then this will do

      $prm = 'a', '-tzip', 'c:\temp\with space\test1.zip', 'C:\TEMP\with space\changelog'

      & 7z.exe $prm
      BTW, Invoke-Expression with one parameter works for me, too, e.g. this works

      $cmd = '& 7z.exe a -tzip "c:\temp\with space\test2.zip" "C:\TEMP\with space\changelog"'

      Invoke-Expression $cmd
      P.S. I usually prefer the way with a parameter array because it is easier to compose programmatically than to build an expression for Invoke-Expression.


  - This was the basic use of 7zip to encrypt the archive and the archive headers
      
      7z.exe a encrypt+headers_archive.7z .\blah.txt -p -mhe


  - This was helpful for examples of 7zip usage and descriptions:  https://www.dotnetperls.com/7-zip-examples
  - The FAQs for 7zip: https://www.7-zip.org/faq.html

    ... Extracting items from an Archive:
          7z.exe x .\encrypt_archive.7z

    ...  Listing the items in an Archive that DOES NOT have the Headers encrypted (-mhe)
          7z.exe l .\encrypt_archive.7z


  .  
#>

function New-7zipEncryptedArchive {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $ArchiveName,
    [Parameter()]
    [string]
    $Path
  )
  
  begin {}
  
  process {

    $cmd = '7z.exe'

    $param = 'a', "$ArchiveName", "$Path", '-p', '-mhe'

    #7z.exe a encrypt+headers_archive.7z .\blah.txt -p -mhe

    & $cmd $param

  }
  
  end {}
}