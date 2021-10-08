<#
.SYNOPSIS
  The "Get-WmicComputerSerialNumber" function leverages WMIC to get a computer's Serial Number.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-WmicComputerSerialNumber.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-04-05 | Initial Version
  Dependencies: 
  Notes:
  - This was helpful for getting the correct syntax:  https://support.microsoft.com/en-us/topic/how-to-find-computer-serial-number-7ceeffe0-1028-840e-dce9-d41634d54cff


  . 
#>
function Get-WmicComputerSerialNumber {
  [CmdletBinding()]
  [Alias('WmicSerialNumber')]
  param (

  )
  
  begin {}
  
  process {
    wmic bios get serialnumber /format:list
  }
  
  end {}
}