<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> $ADS = ADSWithGetItem -Path $HOME -Recurse

  PS C:\>
  PS C:\> Get-CommandRuntime
  Minutes           : 4
  Seconds           : 11

  PS C:\> $ADS | measure
  Count    : 635

  PS C:\> $ADS | Select-Object -First 10 -Property * -ExcludeProperty PSPath,PSParentPath,PSDrive,PSProvider | Format-Table

  PSChildName                  PSIsContainer FileName                                                                      Stream          Length
  -----------                  ------------- --------                                                                      ------          ------
  00007OA4.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00007OA4.bin Zone.Identifier     26
  00007OA6.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00007OA6.bin Zone.Identifier     26
  00007UNQ.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00007UNQ.bin Zone.Identifier     26
  00007UNS.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00007UNS.bin Zone.Identifier     26
  0000806I.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\0000806I.bin Zone.Identifier     26
  0000806K.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\0000806K.bin Zone.Identifier     26
  00008M7M.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00008M7M.bin Zone.Identifier     50
  00008ME7.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00008ME7.bin Zone.Identifier     26
  00008NIQ.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00008NIQ.bin Zone.Identifier     26
  00008NIS.bin:Zone.Identifier         False C:\Users\Jannus.Fugal\AppData\Local\Microsoft\OneNote\16.0\cache\00008NIS.bin Zone.Identifier     26



  Here we have specified the $HOME directory to begin the search for files with Alternate Data Streams, and have also specified the "-Recurse" switch parameter to find any ADS in subdirectories.  

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ADSWithGetItem.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-03-22 | Initial Version
  Dependencies:  
  Notes:
  - I got this idea from the Sec504 class where it recommended using "Get-Item * -Stream *" in order to view Alternate Data Streams in files / directories

  .
#>
function Get-ADSWithGetItem {
  [CmdletBinding()]
  [Alias('ADSWithGetItem')]
  param (
    [Parameter()]
    [string]
    $Path = (Get-Location),
    [Parameter()]
    [switch]
    $Recurse
  )
  
  begin {}
  
  process {

    if ($Recurse) {

      try {
        Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | % { try {Get-Item -Path $_.FullName -Stream * -ErrorAction SilentlyContinue | ? Stream -NotLike ':$DATA'} catch {} }
      }
      catch { }   

    }
    else {

      try {
        Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | % { try {Get-Item -Path $_.FullName -Stream * -ErrorAction SilentlyContinue | ? Stream -NotLike ':$DATA'} catch {} }
      }
      catch { }
    }

  }
  
  end {}
}