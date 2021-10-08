

<#
.SYNOPSIS
  Wrapper for scp.exe
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  I am simply using the "-r" flag as the default for the time being.  It appears that this is for "-Recursive", such that when only a directory is referenced that it will copy everything underneath it.

  This link was helpful for general syntax: https://en.wikipedia.org/wiki/Secure_copy_protocol
  This link was an initial reference to using the "-r" flag: https://stackoverflow.com/questions/8975798/copying-a-local-file-from-windows-to-a-remote-server-using-scp
#>

function Copy-ScpItem {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the path to the .ssh Identity File, such as "~/.ssh/id_ed25519".')]
    [string]
    $IdentityFile,
    [Parameter(HelpMessage='Reference the path of the file/folder you want to copy.')]
    [string]
    $Path,
    [Parameter(HelpMessage='Reference the destination path for the file/folder you are copying. Example: "-Destination superUser@192.168.10.7:/home/superUser/temp/"')]
    [string]
    $Destination
  )
  
  begin {}
  
  process {
    scp.exe -i $IdentityFile -r $Path $Destination
  }
  
  end {}
}