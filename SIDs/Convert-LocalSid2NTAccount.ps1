<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> Sid2User -SID 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'

  SID                                                            NTAccount
  ---                                                            ---------
  S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420 NT SERVICE\WdiServiceHost



  Here we run the function using the built-in alias for the function, "Sid2User".  The returned object has two properties: the SID and the corresponding NTAccount name

.EXAMPLE
  PS C:\> $LocalSIDs
  S-1-1-0
  S-1-2-0
  S-1-3-0
  S-1-3-1
  S-1-3-2
  S-1-3-3
  S-1-3-4
  S-1-5-1
  S-1-5-2
  S-1-5-3
  S-1-5-4
  S-1-5-6
  S-1-5-7
  S-1-5-8
  S-1-5-18
  S-1-5-9
  S-1-5-10
  S-1-5-11
  S-1-5-12
  S-1-5-13
  S-1-5-14
  S-1-5-17
  S-1-5-19
  S-1-5-20
  S-1-5-32
  

  PS C:\> Convert-LocalSid2NTAccount -SID $LocalSIDs

  SID      NTAccount
  ---      ---------
  S-1-1-0  Everyone
  S-1-2-0  LOCAL
  S-1-3-0  CREATOR OWNER
  S-1-3-1  CREATOR GROUP
  S-1-3-2  CREATOR OWNER SERVER
  S-1-3-3  CREATOR GROUP SERVER
  S-1-3-4  OWNER RIGHTS
  S-1-5-1  NT AUTHORITY\DIALUP
  S-1-5-2  NT AUTHORITY\NETWORK
  S-1-5-3  NT AUTHORITY\BATCH
  S-1-5-4  NT AUTHORITY\INTERACTIVE
  S-1-5-6  NT AUTHORITY\SERVICE
  S-1-5-7  NT AUTHORITY\ANONYMOUS LOGON
  S-1-5-8  NT AUTHORITY\PROXY
  S-1-5-18 NT AUTHORITY\SYSTEM
  S-1-5-9  NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS
  S-1-5-10 NT AUTHORITY\SELF
  S-1-5-11 NT AUTHORITY\Authenticated Users
  S-1-5-12 NT AUTHORITY\RESTRICTED
  S-1-5-13 NT AUTHORITY\TERMINAL SERVER USER
  S-1-5-14 NT AUTHORITY\REMOTE INTERACTIVE LOGON
  S-1-5-17 NT AUTHORITY\IUSR
  S-1-5-19 NT AUTHORITY\LOCAL SERVICE
  S-1-5-20 NT AUTHORITY\NETWORK SERVICE
  S-1-5-32



  Here we ran the function by referencing a list of SIDs (an array of string objects that correlate to actual SID values).  The function returned the translated "NTAccount" value for all of the SIDs except for "S-1-5-32".

.INPUTS
.OUTPUTS
.NOTES
  General notes
#>
function Convert-LocalSid2NTAccount {
  [CmdletBinding()]
  [Alias('Sid2User')]
  param (
    [Parameter(HelpMessage='Reference the SID(s) that you want translated to their human readable name.')]
    [string[]]
    $SID
  )
  
  begin {}
  
  process {

    foreach ($item in $SID) {
      try {
        $SIDObject = New-Object -TypeName System.Security.Principal.SecurityIdentifier($item)
        $NTAccount = ($SIDObject.Translate([Security.Principal.NTAccount])).Value 
  
        $prop = [ordered]@{
          SID = $item
          NTAccount = $NTAccount
        }
  
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
      catch {
        $prop = [ordered]@{
          SID = $item
          NTAccount = $null
        }
  
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }

    }
  }
  
  end {}
}