


function Sysmon-IdMapping {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory)]
    [string]
    $Import_SysmonIDtable,
    # Parameter help description
    [int]$DaysPrior
    
  )
  
  begin {
    $IDtable = Import-Csv $Import_SysmonIDtable
    $GoBackTheseManyDays = (Get-Date).AddDays(-$DaysPrior)
    
    $timetable = @{ }
    $timetable.Add("StartTime", $GoBackTheseManyDays)
    $timetable.Add("EndTime", (Get-Date))
    $timetable.Add("LogName", "Microsoft-Windows-Sysmon/Operational")
    $sysmon = Get-WinEvent -FilterHashtable $timetable
  }
  
  process {
    $grouping = $sysmon | select LevelDisplayName, id, message | group id -NoElement

    
    $count_list = @()
    $id_list = @()
    $tag_list = @()
    $event_list = @()

    $grouping | % { 
      if ($_.Name -in $IDtable.ID) {
        $number = $_.Name
        $ID = $IDtable | ? { $_.ID -like "$number" }
        
        $count_list += $_.Count
        $id_list += $_.Name
        $tag_list += $ID.tag
        $event_list += $ID.Event
      }      
    }
  }
  
  end {
    $hashtable = [ordered]@{ }
    $counter = 0

    $results = foreach ($e in (1..$count_list.Length)) { 
          
      $hashtable.RecordCount = $count_list[$counter]
      $hashtable.ID = $id_list[$counter]
      $hashtable.Tag = $tag_list[$counter]
      $hashtable.Event = $event_list[$counter]
      New-Object -TypeName psobject -Property $hashtable

      $counter += 1
        
    }

    write $results

  }  

  
}


