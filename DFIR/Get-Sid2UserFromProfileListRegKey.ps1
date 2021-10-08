


function Get-Sid2UserFromProfileListRegKey {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the PSSession to run the command on.')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {

    if ($Session) {
      Invoke-Command -Session $Session -ScriptBlock {
        $Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\'

        Get-ChildItem $Key | ForEach-Object {

        $SID = $_.PSChildName
        $ProfileImagePath = Get-ItemPropertyValue -Path ($_.Name -replace 'HKEY_LOCAL_MACHINE','HKLM:') -Name 'ProfileImagePath'
        $DerivedUserName =  $ProfileImagePath | Split-Path -Leaf
        
        $prop = [ordered]@{
          SID = $SID
          DerivedUserName = if ($DerivedUserName -like 'systemprofile') {
            Write-Output "System"
          }
          else {
            $DerivedUserName
          }
          ProfileImagePath = $ProfileImagePath
        }
        
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
        }
      }
    }
    else {
      Invoke-Command -ScriptBlock {
        $Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\'

        Get-ChildItem $Key | ForEach-Object {
          $SID = $_.PSChildName
          $ProfileImagePath = Get-ItemPropertyValue -Path ($_.Name -replace 'HKEY_LOCAL_MACHINE','HKLM:') -Name 'ProfileImagePath'
          $DerivedUserName =  $ProfileImagePath | Split-Path -Leaf
          
          $prop = [ordered]@{
            SID = $SID
            DerivedUserName = if ($DerivedUserName -like 'systemprofile') {
              Write-Output "System"
            }
            else {
              $DerivedUserName
            }
            ProfileImagePath = $ProfileImagePath
          }        
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

  }
  
  end {}

}