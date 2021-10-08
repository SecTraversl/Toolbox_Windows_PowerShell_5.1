<#
.SYNOPSIS
  The "Get-FileEncoding" function takes a given file and returns the encoding used in the file (ASCII, UTF7, Unicode, BigEndianUnicode, UTF32, UTF8).

.DESCRIPTION
.EXAMPLE
  PS C:\> ls | Get-FileEncoding

  Encoding                    Path
  --------                    ----
  System.Text.UnicodeEncoding C:\Users\Jannus.Fugal\Documents\Temp\temp\FireWall_network_objects.txt
  System.Text.UnicodeEncoding C:\Users\Jannus.Fugal\Documents\Temp\temp\HelloWorld.ps1
  System.Text.UnicodeEncoding C:\Users\Jannus.Fugal\Documents\Temp\temp\outlook-blocked-sender_list.txt
  System.Text.ASCIIEncoding   C:\Users\Jannus.Fugal\Documents\Temp\temp\output.err
  System.Text.UnicodeEncoding C:\Users\Jannus.Fugal\Documents\Temp\temp\output.msg
  System.Text.UnicodeEncoding C:\Users\Jannus.Fugal\Documents\Temp\temp\temp.txt
  System.Text.ASCIIEncoding   C:\Users\Jannus.Fugal\Documents\Temp\temp\testfile.txt



  Here we call "Get-ChildItem" by using its alias of 'ls'.  We then pipe the returned objects into "Get-FileEncoding"

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-FileEncoding.ps1
  Author:  
  Version History:  1.1 | 2021-09-09 | Initial Version
  Dependencies: 
  Notes:
  - This looks to be some more gold from Tobias Weltner... I retrieved the entirety of the code from here:  https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/get-text-file-encoding
  - I changed the name from "Get-Encoding" to "Get-FileEncoding"
  - I was looking for some code like this because of the following reason --- 
      - This was helpful in understanding some nuances of using "findstr" under CMD.exe versus PowerShell.exe -- by default if using findstr.exe with default $OutputEncoding of PowerShell, you won't find Unicode text - look under the header of "Finding Unicode Text under PowerShell" for info and how to make a change to find Unicode text when using 'findstr.exe' under PowerShell:  https://ss64.com/nt/findstr.html

  . 
#>
function Get-FileEncoding {
  [CmdletBinding()]
  [Alias('FileEncoding')]
  param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]
    $Path
  )
  
  begin {}
  
  process {

    $bom = New-Object -TypeName System.Byte[](4)
        
    $file = New-Object System.IO.FileStream($Path, 'Open', 'Read')
    
    $null = $file.Read($bom, 0, 4)
    $file.Close()
    $file.Dispose()
    
    $enc = [Text.Encoding]::ASCII
    if ($bom[0] -eq 0x2b -and $bom[1] -eq 0x2f -and $bom[2] -eq 0x76) 
    { $enc = [Text.Encoding]::UTF7 }
    if ($bom[0] -eq 0xff -and $bom[1] -eq 0xfe) 
    { $enc = [Text.Encoding]::Unicode }
    if ($bom[0] -eq 0xfe -and $bom[1] -eq 0xff) 
    { $enc = [Text.Encoding]::BigEndianUnicode }
    if ($bom[0] -eq 0x00 -and $bom[1] -eq 0x00 -and $bom[2] -eq 0xfe -and $bom[3] -eq 0xff) 
    { $enc = [Text.Encoding]::UTF32 }
    if ($bom[0] -eq 0xef -and $bom[1] -eq 0xbb -and $bom[2] -eq 0xbf) 
    { $enc = [Text.Encoding]::UTF8 }
        
    [PSCustomObject]@{
      Encoding = $enc
      Path     = $Path
    }

  }
  
  end {}
}