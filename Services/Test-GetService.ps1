<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
#>
function Test-GetService {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Computer(s) for which you want to retrieve services information.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    foreach ($Computer in $ComputerName) {
      try {
        $Services = Get-Service -ComputerName $ComputerName -ErrorVariable err
      }
      catch [System.ComponentModel.Win32Exception] {
        $ErrorResults = $err.GetBaseException()
      }

      $Services | Select-Object MachineName,ServiceName,Status,DisplayName,StartType,RequiredServices,ServiceType      
    }

  }
  
  end {}
}