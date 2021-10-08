<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-SPFRecords -Domain spe.sony.com -Match "185.183.30.70"
  ip4:185.183.30.70



  Explanation of what the example does

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-SPFRecord.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-03-04 | Simplified code, Added an alias
  Dependencies: 
  Notes:


  .
#>
function Get-SPFRecord {
  [CmdletBinding()]
  [Alias('SPFGet')]
  param (
    [Parameter()]
    [string]
    $Domain,
    [Parameter()]
    [switch]
    $NetworkStringsOnly
  )
  
  begin {}
  
  process {
    
    $SpfResults = Resolve-DnsName $Domain -Type TXT | ? Strings -Match "spf"
    $SpfResults | Add-Member -MemberType NoteProperty -Name 'String' -Value $($SpfResults.Strings -join '')
    $SpfResults | Add-Member -MemberType NoteProperty -Name 'SplitString' -Value $($SpfResults.String -split ' ')
    $Final = $SpfResults | Select-Object Name,SplitString,String

    if ($NetworkStringsOnly) {
      $Networks = $Final.SplitString | where {$_ -like "ip4:*"} | foreach { $_ -replace "ip4:","" }
      Write-Output $Networks
    }
    else {
      Write-Output $Final
    }
    

  }
  
  end {}
}