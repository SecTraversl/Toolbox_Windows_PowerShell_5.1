<#
.SYNOPSIS
  This function tests CIM and DCOM access by querying the "Win32_ComputerSystem" class and retrieving the "Name" property of the computer.
.DESCRIPTION
.EXAMPLE
.INPUTS
.OUTPUTS
.NOTES
  Notes: 
  - This was helpful in creating the code to use CIM cmdlets with the DCOM protocol: https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/use-get-ciminstance-with-dcom


  .
#>
function Test-CimDcom {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the ComputerName(s) to test for CIM / DCOM access.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $Protocol = [Microsoft.Management.Infrastructure.CimCmdlets.ProtocolType]::Dcom
    $Option = New-CimSessionOption -Protocol $Protocol

    foreach ($Computer in $ComputerName) {
      $Session = New-CimSession -SessionOption $Option -ComputerName $Computer
      $ComputerResults = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem 
      Remove-CimSession $Session

      Write-Output $ComputerResults
    }

    

    <#
    try {
      Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName -AsJob | Receive-Job -Wait  -ErrorAction Ignore
    }
    # By using the final catch below and writing " $($PSItem.Exception) " to the screen, I was able to derive the correct Error class to catch - which was in this case: [System.Runtime.InteropServices.COMException]
    catch [System.Runtime.InteropServices.COMException] {
      # This is here in order to prevent this particular Error class from being displayed to the screen
    }
    catch {
      Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
    }
    #>

  }
  
  end {}
}