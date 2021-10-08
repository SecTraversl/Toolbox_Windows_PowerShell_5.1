

function Get-ASEPsRegistry {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {

    $KeyList = @(
      'HKLM\Software\Microsoft\Windows\CurrentVersion\Run'
      'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce'
      'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx'
      'HKCU\Software\Microsoft\Windows\CurrentVersion\Run'
      'HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce'
      'HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnceEx'
    )

    $ConvertedList = foreach ($item in $KeyList) {
      $item -replace "HKLM","HKLM:" -replace "HKCU","HKCU:"
    }

    $Results = foreach ($item in $ConvertedList) {
      Get-Item $item -ErrorVariable err -ErrorAction Ignore
    }

    Write-Output $Results
  }
  
  end {}
}




