<#
.SYNOPSIS
  The "Check-PrinterSpooler" function checks to see the Status and StartType for the Print Spooler service.

.DESCRIPTION
.EXAMPLE
  PS C:\> Check-PrinterSpooler -ComputerName $PrintLoc01,$PrintLoc02

  ComputerName Service  Status StartType
  ------------ -------  ------ ---------
  printloc01   Spooler Running Automatic
  printloc02   Spooler Running Automatic



  We give the function two print servers to query, and it returns the Status and StartType of those computers.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Check-PrinterSpooler.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-07-01 | Initial Version
  Dependencies:
  Notes:

  .
#>
function Check-PrinterSpooler {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {
    foreach ($Computer in $ComputerName) {
      $SpoolerInfo = Get-Service -Name 'Spooler'  -ComputerName $Computer

      $prop = [ordered]@{
        ComputerName = $Computer
        Service      = 'Spooler'
        Status       = $SpoolerInfo.Status
        StartType    = $SpoolerInfo.StartType
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
  }
  
  end {}
}