function Get-VssAdminListShadows {
  [CmdletBinding()]
  param ()
  
  begin {
    class TLsVssAdminListShadowsDataClass {
      $ContentsShadowCopySetID
      $CreationTime
      $ShadowCopyID
      $OriginalVolume
      $ShadowCopyVolume
      $OriginatingMachine
      $ServiceMachine
      $Provider
      $Type
      $Attributes
    }
    
    $propertyNameMap = @{
      'Contained 1 shadow copies at creation time' = 'CreationTime'
      'Shadow Copy ID' = 'ShadowCopyID'
      'Original Volume' = 'OriginalVolume'
      'Shadow Copy Volume' = 'ShadowCopyVolume'
      'Originating Machine' = 'OriginatingMachine'
      'Service Machine' = 'ServiceMachine'
      'Provider' = 'Provider'
      'Type' = 'Type'
      'Attributes' = 'Attributes'
    }

    $VssAdminListShadows = vssadmin.exe list shadows

    $Trimmed = $VssAdminListShadows[3..($VssAdminListShadows).Length]
    #$Trimmed | % {$_.trim()}

  }
  
  process {

    $Trimmed -join "`n" | % {
      $currentObject = $null;
      switch -regex ($_ -split "`n") {
        '^(\S.*)' { 
          # record start pattern, in this case line that doesn't start with a whitespace.
          if ($null -ne $currentObject) {
            $currentObject                      # output to pipeline if we have a previous data object
          }
          $currentObject = [TLsVssAdminListShadowsDataClass] @{   # create new object for this record
            ContentsShadowCopySetID = ($matches.1 -replace  ".*:" ).Trim()  # with Action like 'permitted' or 'blocked'
          }
          continue
        }
        # set the properties on the data object
        '^\s{0,}([^:]+):(.*)' {
          $name, $value = $matches[1, 2]
          # project property names
          $propName = $propertyNameMap[$name]
          if ($null -eq $propName) {
              $propName = $name
          }
          # assign the parsed value to the projected property name
          $currentObject.$propName = $value.trim()
          continue
        }     
      } 
    
      Write-Output $currentObject
    }

  }
  
  end {
    
  }
}