

<#
2020-08-03

Idea gleaned from:
 - https://superuser.com/questions/591438/how-can-i-display-the-time-stamp-of-a-file-with-seconds-from-the-command-line

#>



function Get-YanDir {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    dir -Force | 
    select Name, 
    @{n = 'Birth (CreationTime)'; e = { $_.CreationTime } }, 
    @{n = 'Access (LastAccessTime)'; e = { $_.LastAccessTime } }, 
    @{n = 'Modified (LastWriteTime'; e = { $_.LastWriteTime } },
    Mode, Length, FullName
  }
  
  end {}
}