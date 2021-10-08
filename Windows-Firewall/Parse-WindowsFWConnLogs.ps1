

function Parse-WindowsFWConnLogs {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Windows FW Connection Logs that were grabbed using "Get-WindowsFWConnLogs.ps1')]
    [psobject]
    $ConnLogs
  )
  
  begin {
    $LogsToParse = $ConnLogs

    class TLsWindowsFWDataClass {
      $ProcID
      $Application
      $Direction
      $SrcIP
      $SrcPort
      $DstIP
      $DstPort
      $Protocol
      $Action
      $FilterID
      $LayerName
      $LayerID
    }
    
    $propertyNameMap = @{
      'Process ID'          = 'ProcID'
      'Application Name'    = 'Application'
      'Direction'           = 'Direction'
      'Source Address'      = 'SrcIP'
      'Source Port'         = 'SrcPort'
      'Destination Address' = 'DstIP'
      'Destination Port'    = 'DstPort'
      'Protocol'            = 'Protocol' 
      'Filter Run-Time ID'  = 'FilterID'
      'Layer Name'          = 'LayerName'
      'Layer Run-Time ID'   = 'LayerID'
    }
  }
  
  process {
    $LogsToParse | ? {$_} -PipelineVariable original | % {
      $currentObject = $null;
      switch -regex ($_.message -split "\r?\n") {
        'The Windows Filtering Platform has (permitted|blocked) a connection.' { 
          # record start pattern, in this case line that doesn't start with a whitespace.
          if ($null -ne $currentObject) {
            $currentObject                      # output to pipeline if we have a previous data object
          }
          $currentObject = [TLsWindowsFWDataClass] @{   # create new object for this record
            Action = ($Matches.1).ToUpper()     # with Action like 'permitted' or 'blocked'
          }
          continue
        }
        # set the properties on the data object
        '^\s+([^:]+):(.*)' {
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
      $prop = [ordered]@{
        TimeCreated = $original.TimeCreated
        EventID = $original.Id
        Action = $currentObject.Action
        ProcID = $currentObject.ProcID
        Application = $currentObject.Application
        Direction = $currentObject.Direction
        SrcIP = $currentObject.SrcIP
        SrcPort = $currentObject.SrcPort
        DstIP = $currentObject.DstIP
        DstPort = $currentObject.DstPort
        Protocol = $currentObject.Protocol
        FilterID = $currentObject.FilterID    
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
  }
  
  end {
    
  }
}