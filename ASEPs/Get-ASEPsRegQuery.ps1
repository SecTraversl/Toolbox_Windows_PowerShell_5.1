

# Consider adding registry keys found from these 130 blog posts: https://www.hexacorn.com/blog/category/autostart-persistence/

function Get-ASEPsRegQuery {
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

    foreach ($item in $KeyList) {

      $query = (reg query $item) | ? {$_}
      $Results = $query | Select-Object -Skip 1 | % {$_.trim() -replace "\s{3,}","`t" | ConvertFrom-Csv -Delimiter "`t" -Header Name,Type,Binary}

      foreach ($r in $Results) {
        $prop = [ordered]@{
          Name = $r.Name
          Binary = $r.Binary
          Key = $item
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }

    }  
    
  }
  
  end {}
}