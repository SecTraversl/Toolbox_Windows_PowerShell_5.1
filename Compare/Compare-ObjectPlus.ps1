<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> $joinstapMostRecent = $MostRecent | ? 'domain-name' -like 'joinstap.com'
  PS C:\> $joinstapMostRecent


  fuzzer          : bitsquatting
  domain-name     : joinstap.com
  dns-a           : 198.54.117.197
  dns-aaaa        :
  dns-mx          :
  dns-ns          : dns101.registrar-servers.com
  geoip-country   :
  whois-registrar :
  whois-created   :
  ssdeep-score    :



  PS C:\> $joinstapToday = $Today | ? 'domain-name' -like 'joinstap.com'
  PS C:\> $joinstapToday


  fuzzer          : bitsquatting
  domain-name     : joinstap.com
  dns-a           : 51.89.198.210
  dns-aaaa        :
  dns-mx          : joinstap.com
  dns-ns          : ns31.dnshostcentral.com
  geoip-country   :
  whois-registrar :
  whois-created   :
  ssdeep-score    :



  PS C:\> compare $joinstapMostRecent $joinstapToday
  PS C:\> Compare-Object $joinstapMostRecent $joinstapToday
  PS C:\>


  Explanation of what the example does

.INPUTS
.OUTPUTS
.NOTES
  Name:  Compare-ObjectPlus.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-26 | Initial Version
  Dependencies:
  Notes:
    - I referenced the code in "Get-PSObjectPropertyNames.ps1" to derive the Property names for comparison
    - I referenced the code in "Compare-Directories.ps1" to further customize the comparison properties in the code below
    - I referenced the code in "Select-PSObjectPropertiesWithValues.ps1" in order to iterate over the Properties where values existed

    
  .
#>
function Compare-ObjectPlus {
  [CmdletBinding()]
  [Alias('ComparePlus')]
  param (
    [Parameter()]
    [psobject]
    $ReferenceObject,
    [Parameter()]
    [psobject]
    $DifferenceObject,
    [Parameter()]
    [string]
    $AnchorProperty
  )
  
  begin {}
  
  process {

    if ($ReferenceObject.Count -ne $DifferenceObject.count) {
      
      $Comparison = $null
      $Comparison = Compare-Object -ReferenceObject $ReferenceObject.$AnchorProperty -DifferenceObject $DifferenceObject.$AnchorProperty
      
      foreach ($ComparedObject in $Comparison) {

        $ObjectInQuestion = $null
        $TempObject = $null

        # Based off of the 'SideIndicator' we are determining if the outlier is in the Reference or Difference Object
        if ($ComparedObject.SideIndicator -eq '<=') {
          $ObjectInQuestion = $ReferenceObject | ? { $_.$AnchorProperty -eq $ComparedObject.InputObject }
        }  
        elseif ($ComparedObject.SideIndicator -eq '=>') {
          $ObjectInQuestion = $DifferenceObject | ? { $_.$AnchorProperty -eq $ComparedObject.InputObject }
        } 

        # First we retrieve a list of the properties in the object that contain values that are not "$null"
        $PropertiesWithValues = ($ObjectInQuestion.PSObject.Properties | ? { $_.Value -notlike $null }).name

        # Then we specifically select only those properties
        $TempObject = $ObjectInQuestion | Select-Object -Property $PropertiesWithValues

        foreach ($TempPropName in $PropertiesWithValues) {

          $prop = [ordered]@{

            AnchorProperty                = $AnchorProperty
            $AnchorProperty               = $TempObject.$AnchorProperty
            PropertyThatHasChanged        = $TempPropName
            ReferenceObjectPropertyValue  = $TempObject.$TempPropName
            DifferenceObjectPropertyValue = $null

          }

          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj

        }
      }
    }

    foreach ($Object in $ReferenceObject) {
      $joinerObject = $DifferenceObject | ? $AnchorProperty -like $Object.$AnchorProperty

      $PropertyNameList = ($Object | Get-Member -MemberType *Property*).Name

      foreach ($name in $PropertyNameList) {

        $Comparison = $null
        $Comparison = try { Compare-Object -ReferenceObject $Object.$name -DifferenceObject $joinerObject.$name } catch {}
        if ($Comparison) {

          $prop = [ordered]@{

            AnchorProperty                = $AnchorProperty
            $AnchorProperty               = $Object.$AnchorProperty
            PropertyThatHasChanged        = $name
            ReferenceObjectPropertyValue  = $Object.$name
            DifferenceObjectPropertyValue = $joinerObject.$name

          }

          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }

      }
      
    }



  }
  
  end {}
}