<#
.SYNOPSIS
  The "Expand-TarGzArchiveWith7zip" function is a wrapper for 7z.exe (7-Zip) that decompresses a .gzip file and untars that file with one command. 

.DESCRIPTION
.EXAMPLE
  PS C:\> Expand-TarGzArchiveWith7zip -TarGz .\node01accesslogs.tar.gz

  7-Zip 19.00 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2019-02-21

  Extracting archive:
  --
  Path =
  Type = tar
  Code Page = UTF-8

  Everything is Ok

  Files: 47
  Size:       81128952
  Compressed: 34304
  PS C:\> ls


      Directory: C:\Users\mark.johnson\Documents\Temp\Sec Ops\www.Roxboard.com_site-down\Apache logs


  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  d-----        1/19/2021   7:05 PM                node01accesslogs
  -a----        1/19/2021   6:33 PM       44658578 node01accesslogs.tar.gz



  Here we navigate to the directory that has the .tar.gz archive and run the function.  The result is an directory that has been decrompressed and ready to be accessed.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Expand-TarGzArchiveWith7zip.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-01-19 | Initial Version
  Dependencies:
  Notes:
  - This was where I retrieved the syntax used below: https://stackoverflow.com/questions/1359793/programmatically-extract-tar-gz-in-a-single-step-on-windows-with-7-zip/14699663#14699663


  .
#>
function Expand-TarGzArchiveWith7zip {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the .tar.gz archive you want to expand.')]
    [string]
    $TarGz
  )
  
  begin {}
  
  process {
    $File = Get-Item $TarGz
    $FullName = $File.FullName
    $PSChildName = $File.PSChildName
    #$CurrentPathOfArchive = $TarGz | Split-Path
    $BaseNameOfArchive = $PSChildName -replace ".tar.gz"

    #$ExpandedArchiveFullPath = "$CurrentPathOfArchive\$BaseNameOfArchive"

    & cmd.exe "/C 7z x `"$($FullName)`" -so | 7z x -aoa -si -ttar -o$(`"$BaseNameOfArchive`")"
  }
  
  end {}
}