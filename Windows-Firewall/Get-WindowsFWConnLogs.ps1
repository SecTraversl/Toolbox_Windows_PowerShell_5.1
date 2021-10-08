

function Get-WindowsFWConnLogs {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Specify which Windows Firewall Connection logs to grab. Default is 'AllowedAndBlocked'")]
    [ValidateSet('Allowed','Blocked','AllowedAndBlocked')]
    [string]
    $ConnectionLogs = 'AllowedAndBlocked',
    [Parameter(HelpMessage="Specify the connection logs you want based on the number of Minutes prior to the present time.")]
    [string]
    $MinutesPrior,
    [Parameter(HelpMessage="Specify the connection logs you want based on the number of Hours prior to the present time.")]
    [string]
    $HoursPrior,
    [Parameter(HelpMessage="Specify the connection logs you want based on the number of Days prior to the present time.")]
    [string]
    $DaysPrior
  )
  
  begin {
    switch ($ConnectionLogs) {
      'Allowed' { $ID = '5156' }
      'Blocked' { $ID = '5157' }
      'AllowedAndBlocked' { $ID = @('5156','5157') }
      Default {}
    }

    if ($MinutesPrior) {
      $StartTime = (Get-Date).AddMinutes(-$MinutesPrior)
    }
    elseif ($HoursPrior) {
      $StartTime = (Get-Date).AddHours(-$HoursPrior)
    }
    elseif ($DaysPrior) {
      $StartTime = (Get-Date).AddDays(-$DaysPrior)
    }
    else {
      Write-Host "Capturing the Windows Firewall Connection logs for the last 5 minutes." -ForegroundColor Green -BackgroundColor Black
      $StartTime = (Get-Date).AddMinutes(-2)
    }
    

    $hashtable = @{
      'StartTime' = $StartTime
      'EndTime' = Get-Date
      'Logname' = 'Security'
      'ID' = $ID
      } 
  }
  
  process {     
    Get-WinEvent -FilterHashtable $hashtable
  }
  
  end {
    
  }
}