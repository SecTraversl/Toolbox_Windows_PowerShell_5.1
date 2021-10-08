<#
.SYNOPSIS
  The "Parse-GPOsForComputerXml" takes either a reference GPO Report file XML or an "XmlDocument" Object and parses it to return the meaninful portions of the changes the GPO is making on the computer.

.DESCRIPTION
.EXAMPLE
  PS C:\> Parse-GPOsForComputerXml -XmlFile '.\GPOReport_Logging Policy_EXAMPLE.xml'

  The Extension is: .... q1:SecuritySettings      The Property of Interest is: .... Audit


  Name                 SuccessAttempts FailureAttempts
  ----                 --------------- ---------------
  AuditAccountLogon    true            true
  AuditAccountManage   true            true
  AuditLogonEvents     true            true
  AuditObjectAccess    false           false
  AuditPrivilegeUse    false           false
  AuditProcessTracking true            true
  AuditSystemEvents    true            true



  The Extension is: .... q1:SecuritySettings      The Property of Interest is: .... Blocked

  false

  The Extension is: .... q2:AuditSettings         The Property of Interest is: .... AuditSetting


  PolicyTarget SubcategoryName           SubcategoryGuid                        SettingValue
  ------------ ---------------           ---------------                        ------------
  System       Audit Process Creation    {0cce922b-69ae-11d9-bed3-505054503030} 1
  System       Audit Logoff              {0cce9216-69ae-11d9-bed3-505054503030} 1
  System       Audit Logon               {0cce9215-69ae-11d9-bed3-505054503030} 3
  System       Audit Audit Policy Change {0cce922f-69ae-11d9-bed3-505054503030} 3



  The Extension is: .... q3:RegistrySettings      The Property of Interest is: .... Policy



  Name      : Include command line in process creation events
  State     : Enabled
  Explain   : This policy setting determines what information is logged in security audit events when a new process has been created.

              This setting only applies when the Audit Process Creation policy is enabled. If you enable this policy setting the
              command line information for every process will be logged in plain text in the security event log as part of the Audit
              Process Creation event 4688, "a new process has been created," on the workstations and servers on which this policy
              setting is applied.

              If you disable or do not configure this policy setting, the process's command line information will not be included in
              Audit Process Creation events.

              Default: Not configured

              Note: When this policy setting is enabled, any user with access to read the security events will be able to read the
              command line arguments for any successfully created process. Command line arguments can contain sensitive or private
              information such as passwords or user data.

  Supported : At least Windows Server 2012 R2, Windows 8.1 or Windows RT 8.1
  Category  : System/Audit Process Creation




  Here we parsed a GPO Report that contained three "Extensions".  Each one of those Extensions was processed as an individual object with certain properties dynamically selected for each object.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Parse-GPOsForComputerXml.ps1
  Author:  Travis Logue
  Version History:  
  Dependencies:
  Notes:


  .
#>
function Parse-GPOsForComputerXml {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $XmlFile,
    [Parameter()]
    [psobject]
    $XmlObject
  )
  
  begin {}
  
  process {

    if ($XmlObject) {
      [xml]$GPO = $XmlObject
    }
    elseif ($XmlFile) {
      [xml]$GPO = Get-Content $XmlFile
    }


    # There are an arbitrary number of extensions and we want to iterate over each of them
    $Extensions = $GPO.GPO.Computer.ExtensionData.extension


    foreach ($Extension in $Extensions) {
      
      # We want to output all of the Properties between the "type" property and the "Name" property in these GPO XML reports
      
      # We start by getting the array of properties that pertain to the Extension, then identify the Index Number of where the 'type' and 'Name' properties are in the Array
      [array]$ArrayOfProperties = $Extension.psobject.properties
      $NamePropIndex = 0
      $TypePropIndex = 0

      for ($i = 0; $i -lt $ArrayOfProperties.Count; $i++) {
        if ($ArrayOfProperties[$i].Name -eq 'type') {
          [int]$TypePropIndex = $i
        }
        if ($ArrayOfProperties[$i].Name -eq 'Name') {
          [int]$NamePropIndex = $i
        }

      }

      
      # In some cases there are 2 properties between 'type' and 'Name', and in other cases there is just one property between them

      # The code below determines the difference between the 'type' and 'Name' properties and runs a "While" loop to output the values until all of the properties have been displayed

      [int]$DifferenceBetween = ($NamePropIndex - $TypePropIndex)

      while ($DifferenceBetween -gt 1) {
        
        $IndexOfInterest = [int]$NamePropIndex - $DifferenceBetween + 1

        $NameOfPropertyOfInterest = ($ArrayOfProperties[$IndexOfInterest]).Name
  
        Write-Host "`nThe Extension is: ...." -BackgroundColor Black -ForegroundColor Yellow -NoNewline
        Write-Host " $($Extension.Type) " -NoNewline
        Write-Host "`tThe Property of Interest is: ...." -BackgroundColor Black -ForegroundColor Yellow -NoNewline
        Write-Host " $NameOfPropertyOfInterest`n"
  
        $obj = $Extension | Select-Object -ExpandProperty $NameOfPropertyOfInterest
  
        Out-Host -InputObject $obj

        $DifferenceBetween -= 1
      }


    }

    
  }
  
  end {}
}