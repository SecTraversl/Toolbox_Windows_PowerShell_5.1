<#
.SYNOPSIS
  Establishes a connection to either "ADMIN$" or "C$" of a specified computer and creates a PSDrive reference for it.
.DESCRIPTION
.EXAMPLE
  PS C:\> Mount-RemoteShareAsPSDrive -Computer MyDesktopComputer -Share 'ADMIN$'

  Name           Used (GB)     Free (GB) Provider      Root
  ----           ---------     --------- --------      ----
  KansaDrive                             FileSystem    \\MyDesktopComputer\ADMIN$

  

  Here we are referencing the computer named "MyDesktopComputer" and creating a PSDrive of "KansaDrive" that is mounted to the remote computer's "ADMIN$" share point.

.EXAMPLE
  PS C:\> Mount-RemoteShareAsPSDrive -Computer JumpBox -Share 'C$' -PSDriveName 'JumpDrive'

  Name           Used (GB)     Free (GB) Provider      Root                                               CurrentLocation
  ----           ---------     --------- --------      ----                                               ---------------
  JumpDrive                              FileSystem    \\JumpBox\C$


  Here we are specifying what we want the name of the PSDrive to be and are mounting this PSDrive to that share point on the "C$" remote computer.

.INPUTS
.OUTPUTS
.NOTES
  - When running "New-PSDrive" in a function like this, if you don't use "-Scope Global" then it won't show up after the function has been run.  This is because the default "-Scope" is Local, and so PSDrive connection perishes once the function closes.
#>
function Mount-RemoteShareAsPSDrive {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the name of the remote computer')]
    [string]
    $Computer,
    [Parameter(HelpMessage='This Parameter contains a ValidateSetAttribute to mount either the "C$" or "ADMIN$" shares on the remote machine',Mandatory=$true)]
    [ValidateSet('C$','ADMIN$')]
    [string]
    $Share,
    [Parameter(HelpMessage='Reference the PSDrive name you want to give this connection.  DEFAULT is "KansaDrive".')]
    [string]
    $PSDriveName = 'KansaDrive'
  )
  
  begin {}
  
  process {

    New-PSDrive -PSProvider FileSystem -Name $PSDriveName -Root "\\$Computer\$Share" -Scope Global
    
  }
  
  end {}
}

