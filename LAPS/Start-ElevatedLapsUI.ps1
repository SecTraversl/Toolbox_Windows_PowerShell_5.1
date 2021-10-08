


function Start-ElevatedLapsUI {
  [CmdletBinding()]
  param (
    [Parameter()]
    [pscredential]
    $Credential
  )
  
  begin {}
  
  process {
    $Target = "C:\Program Files\LAPS\AdmPwd.UI.exe"

    if ($Credential) {      
      Start-Process -FilePath $Target -Credential $Credential -WorkingDirectory c:\
    }
    else {
      Start-Process -FilePath $Target -Credential (Get-Credential) -WorkingDirectory c:\
    }

  }
  
  end {}
}