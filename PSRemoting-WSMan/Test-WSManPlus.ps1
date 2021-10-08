<#
.SYNOPSIS
  This function is an improvement on the "Test-WSMan" cmdlet.  It takes the given -ComputerName(s), Tests to see if WSMan is available, and returns the ComputerName and the details of the WSMan version on the remote computer. If WSMan is not available for the given machine, the "WSManDetails" property has a value of $null.
.DESCRIPTION
.EXAMPLE
  PS C:\> $UpList = $pingResults | ? pingable -eq $true
  PS C:\> $UpList | measure
  Count    : 218
    
  PS C:\> $PlusResults = Test-WSManPlus -ComputerName ($UpList.dnshostname)
  PS C:\> Get-CommandRuntime
  Days              : 0
  Hours             : 0
  Minutes           : 27
  Seconds           : 5

  PS C:\> $PlusResults | measure
  Count    : 218

  PS C:\> $PlusResults | ? WSManDetails -like $null | measure
  Count    : 4

  PS C:\> $PlusResults | ? WSManDetails -notlike $null | measure
  Count    : 214

  PS C:\> $PlusResults | ? WSManDetails -notlike $null | epcsv -NTI '.\Sec Ops\Workstations-with-WSMan.csv'
  PS C:\> $PlusResults | ? WSManDetails -notlike $null | select -f 10

  ComputerName                      WSManDetails
  ------------                      ------------
  RBHQAHARDER2-D.corp.Roxboard.com  http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQAHARDER-L.corp.Roxboard.com   http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQALIU-L.corp.Roxboard.com      http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQASMIT-L.corp.Roxboard.com     http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQASMITS-D.corp.Roxboard.com    http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQAWOO-L.corp.Roxboard.com      http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQBBartman1-L.corp.Roxboard.com http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQBFRUITS1-L.corp.Roxboard.com  http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQBPAUL-L.corp.Roxboard.com     http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  RBHQBPENOY-L.corp.Roxboard.com    http://schemas.dmtf.org/wbem/wsman/1/wsman.xsdMicrosoft CorporationOS: 0.0.0 SP: 0.0 Stack: 3.0
  


  Here is an example of taking a list of pingable workstations (the $UpList variable) and passing the collection of machine names to the "Test-WSManPlus" function.  Here we gave the function 218 hosts and it returned the status that WSMan is reachable for 214 of those hosts. No special credentials were used in this test.  This took almost 30 minutes to finish.

.INPUTS
.OUTPUTS
.NOTES  
#>
function Test-WSManPlus {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Computer(s) to test.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    foreach ($item in $ComputerName) {
      try {
        $TestResults = Test-WSMan -ComputerName $item -ErrorAction Stop
      }
      # I used "$Error[0]" to find the "FullyQualifiedErrorId" which was: [Microsoft.WSMan.Management.TestWSManCommand]
      catch [Microsoft.WSMan.Management.TestWSManCommand]{
        # This is simply used to remove the Error text from being displayed to the screen
      }
    
      if ($TestResults) {
        $WSManDetails = $TestResults.InnerText
      }
      else {
        $WSManDetails = $null
      }
    
      $prop = [ordered]@{
        ComputerName = $item
        WSManDetails = $WSManDetails 
      }
    
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj    
    }

  }
  
  end {}
}
