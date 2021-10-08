
<#
.SYNOPSIS
  This function creates a Shortcut for the given Target file/folder.
.DESCRIPTION
.EXAMPLE
  PS C:\> New-Shortcut -ShortcutName .\ps1_files\ComObjects-WScript\New-Shortcut.ps1.lnk -TargetPath .\ps1_files\New-Shortcut.ps1
  
  Creates a Shortcut file in the Directory "ComObjects-WScript\" with a target of this .ps1 file
.INPUTS
.OUTPUTS
.NOTES
  - This forum post was helpful in building the body of this code: https://stackoverflow.com/questions/9701840/how-to-create-a-shortcut-using-powershell
  - Also, used this as a reference: https://www.reddit.com/r/PowerShell/comments/bbjp4l/how_can_i_create_a_shortcut_lnk_file_using/

  Troubleshooting the initial Code
  - I was running into some errors because I was referencing relative paths (  the error that I searched the Internet for was "Unable to save shortcut save()"  )... so ↓
  - I had to add a bit more logic for the way I wanted to use this tool; specifically, I wanted to use relative paths. That is the reason for the "New-Item" creation and then referencing that object with WshShell.  Also, I do something similar with the Target, I reference the "fullname" of the designated "DirectoryInfo/FileInfo" object -- which is the Full Path that I need to submit to WshShell


  Working through some initial test runs... these were some examples of what I tried initially which led me to add the compensation code for the "relative path" usage I mention above

  # This got saved here: c:\Windows\System32\new-shortcut-test2.lnk
  New-Shortcut -ShortcutName "new-shortcut-test2.lnk" -TargetPath C:\Users\john.smith\Documents\Temp\ps1_files\New-Shortcut.ps1

  # This got saved here: c:\Windows\System32\new-shortcut-test3.lnk
  New-Shortcut -ShortcutName "new-shortcut-test3.lnk" -TargetPath .\New-Shortcut.ps1
  
#>

function New-Shortcut {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the name you want to give the Shortcut')]
    [string]
    $ShortcutName,
    [Parameter(HelpMessage='Reference the file/folder for which you are making a Shortcut.')]
    [string]
    $TargetPath
  )
  
  begin {}
  
  process {
    $ShortcutObj = (New-Item $ShortcutName)
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutObj.FullName)
    $Shortcut.TargetPath = (Get-Item $TargetPath).FullName
    $Shortcut.Save()

  }
  
  end {}
}


