

<#
.SYNOPSIS
  Tool wrapper of "mklink" to create file or directory Symbolic Links, Hard Links, or Directory Junctions.
.DESCRIPTION
.EXAMPLE
  PS C:\> New-MkLink mysymlink .\Embedded\SecretFolder\blah.txt
  Creates a File Symbolic Link called "mysymllink" that points to ".\Embedded\SecretFolder\blah.txt"

.EXAMPLE
  PS C:\> New-MkLink -LinkName myLinkFolder -TargetPath .\Embedded\SecretFolder\ -LinkType DirectorySymLink
  Creates a Directory Symbolic Link called "myLinkFolder" that points to ".\Embedded\SecretFolder"
.INPUTS
.OUTPUTS
.NOTES
  - Article on mklink and "SymLinks on Windows 10": https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/
  - Discussion on the difference of a " 'directory Juntion' and a 'directory Symbolic Link' ": https://superuser.com/questions/343074/directory-junction-vs-directory-symbolic-link
  - Discussion on "the difference between a Symbolic Link and a Shortcut":  https://superuser.com/questions/253935/what-is-the-difference-between-symbolic-link-and-shortcut?noredirect=1&lq=1
#>

function New-MkLink {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $LinkName,
    [Parameter()]
    [string]
    $TargetPath,
    [Parameter(HelpMessage='ValidateSet Parameter to choose what kind of "Link" to create.  DEFAULT is "FileSymLink".')]
    [ValidateSet('FileSymLink','DirectorySymLink','HardLink','DirectoryJunction')]
    [string]
    $LinkType = 'FileSymLink'
  )
  
  begin {}
  
  process {    
    
    # Had to do a little extra specific quoting here.  "mklink" needs to have "double quotes" around the Argument (which is the Full Path) you give to the '/d' Parameter; particularly when you are giving a Full Path which has spaces in it.  
    # - EXAMPLE: "C:\Users\john.smith\Documents\Temp\DFIR testing\Volume Shadow Stuff\demo"

    switch ($LinkType) {
      'FileSymLink' { $cmdstring = 'mklink' + ' "' + $LinkName + '" ' + ' "' + $TargetPath + '" '    }
      'DirectorySymLink' { $cmdstring = 'mklink /D' + ' "' + $LinkName + '" ' + ' "' + $TargetPath + '" '  }
      'HardLink' { $cmdstring = 'mklink /H' + ' "' + $LinkName + '" ' + ' "' + $TargetPath + '" ' }
      'DirectoryJunction' { $cmdstring = 'mklink /J' + ' "' + $LinkName + '" ' + ' "' + $TargetPath + '" ' }
    }

    $cmdstring | cmd.exe 
    
  }
  
  end {}
}