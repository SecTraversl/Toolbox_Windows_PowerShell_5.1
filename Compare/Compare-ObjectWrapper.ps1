<#
.SYNOPSIS
  The "Compare-ObjectWrapper" function augments the "Compare-Object" cmdlet by populating additional properties that can be used to more easily sort the results based off of the original objects that were compared.

.DESCRIPTION
.EXAMPLE
  PS C:\> CompareWrapper -ReferenceObject $UniqueSortedOutlierDomains  -DifferenceObject $BlahList

  DifferenceDetected InReferenceObj SideIndicator InDifferenceObj
  ------------------ -------------- ------------- ---------------
  Blahblah.com                      =>                       True



  Here we run the function using its built-in alias "CompareWrapper".  We have two lists of strings that we are comparing and when we use the function we see that there is an additional line containing the string "Blahblah.com".  This additional string is found in the "DifferenceObject", which is the list of strings within the "$Blahlist" variable, in this case.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Compare-ObjectWrapper.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-09 | Initial Version
  Dependencies:  
  Notes:


  .  
#>
function Compare-ObjectWrapper {
  [CmdletBinding()]
  [Alias('CompareWrapper')]
  param (
    [Parameter()]
    [psobject]
    $ReferenceObject,
    [Parameter()]
    [psobject]
    $DifferenceObject
  )
  
  begin {}
  
  process {
    
    $CompareResults = Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $DifferenceObject

    foreach ($Result in $CompareResults) {

      $FoundInReferenceObject = $null
      $FoundInDifferenceObject = $null

      if ($Result.SideIndicator -eq "<=") {
        $FoundInReferenceObject = $True
      }
      elseif ($Result.SideIndicator -eq "=>") {
        $FoundInDifferenceObject = $True
      }

      $prop = [ordered]@{

        DifferenceDetected = $Result.InputObject
        InReferenceObj = $FoundInReferenceObject
        SideIndicator = $Result.SideIndicator
        InDifferenceObj = $FoundInDifferenceObject
  
      }
  
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj

    }


  }
  
  end {}
}