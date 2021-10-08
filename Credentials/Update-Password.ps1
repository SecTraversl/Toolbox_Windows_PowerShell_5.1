
function Update-Password {
  [CmdletBinding()]
  param ()  
  
  process {
    try {
      $Identity = Read-Host "Enter the Username"
      $OldCred = Read-Host -AsSecureString "Enter the Old Password"
      $NewCred = Read-Host -AsSecureString "Enter the New Password"

      Set-ADAccountPassword -Identity $Identity -OldPassword $OldCred -NewPassword $NewCred -ErrorVariable err #-ErrorAction Stop 
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
      
      # 2/26/2020 - Here is what I discovered... each time I was doing "Write-Host" it was apparently converting the whole object .ToString() and was giving me the FULL MESSAGE.  When I simply kept it as an object ($err.GetBaseException), it was a succinct one-liner... but when it was turned into a String... it was multi-line and undesirable.  And because PSReadline just updated and totally changed its syntax, that method of colorizing output changed... and seems complicated, currently.  So, instead we are hacking the String and grabbing only the first line and using good old Write-Host

      # Incorrect Username / identity
      Write-Host "`nYou entered a non-existant Username / Identity. The update failed with the following error..."
      Write-Host "`n$(($err.GetBaseException().ToString() -split "`r`n")[0])`n" -BackgroundColor Black -ForegroundColor Yellow   
     
    }
    catch [System.ServiceModel.FaultException] {

      # Incorrect Password
      Write-Host "`nThe 'Old Password' you entered is incorrect. The update failed with the following error..."     
      Write-Host "`n$(($err.GetBaseException().ToString() -split "`r`n")[0])`n" -BackgroundColor Black -ForegroundColor Yellow 

    }
    catch {
      Write-Host "`nThe Update Failed due to the following Error..." 
      Write-Host "`n$(($err.GetBaseException().ToString() -split "`r`n")[0])`n" -BackgroundColor Black -ForegroundColor Yellow 
      
    }
    
    if ( -not ($err)) {
      Write-Host "`nPassword has been updated`n"
    }
    
  }
  
 
}