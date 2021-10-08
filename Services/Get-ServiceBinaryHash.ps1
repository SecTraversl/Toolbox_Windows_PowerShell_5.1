<#
.SYNOPSIS
  The "Get-ProcessHash" function retrieves the Hash values for the running processes on a given computer.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ProcessHash | Select-Object -First 10 | Format-Table -AutoSize

  Algorithm Hash                             Path
  --------- ----                             ----
  MD5       9FE02707E656B3838324773E91890508 C:\Program Files\OpenVPN Connect\agent_ovpnconnect_1594367036109.exe
  MD5       2A8844003A718C98D367E202BCBAA752 C:\Windows\system32\ApplicationFrameHost.exe
  MD5       107ED01477C07219C0985B3E876824BE C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe
  MD5       02123BE5D4D5CA48E93AC914EC936DC4 C:\Windows\system32\BtwRSupportService.exe
  MD5       907050710CE174DD35C446D8973AE8C5 C:\Windows\CCM\CcmExec.exe
  MD5       AA2E522A405CB5A295D3502C4FF6CA39 C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
  MD5       469507E2E82B818A8AEE68C6CDBF41B8 C:\Windows\CCM\RemCtrl\CmRcService.exe
  MD5       717EA327CCF46F0101E99E599233A436 C:\Users\Jannus.Fugal\AppData\Local\Programs\Microsoft VS Code\Code.exe
  MD5       C5E9B1D1103EDCEA2E408E9497A5A88F C:\Windows\system32\conhost.exe
  MD5       A1F2CF496F181AA75352E102978E60D0 C:\Windows\system32\ctfmon.exe


  PS C:\> Get-ProcessHash -Algorithm SHA256 | Select-Object -First 10 | Format-Table -AutoSize

  Algorithm Hash                                                             Path
  --------- ----                                                             ----
  SHA256    D4ACBCCD0A1E1E0475B46A866F54F24543536A717C12133354D9840259DF3033 C:\Program Files\OpenVPN Connect\agent_ovpnconnect_1594367...
  SHA256    60336E9BB7517FF6B7D96DD5E1F935DF5705C31FD9FDACC5410.80.D49595C45 C:\Windows\system32\ApplicationFrameHost.exe
  SHA256    A98F45BC4050E9E17345D66BE726F41269CE0340C4D2F16004BD384E1164DDDE C:\Program Files (x86)\BraveSoftware\Brave-Browser\Applica...
  SHA256    1F5EBE116590726D0F601D487F26C7FC550F62144A0F9A64022E3DC2C940F17E C:\Windows\system32\BtwRSupportService.exe
  SHA256    6538A2535817F6E9E90E3AC1726655954E0D416A77AE557AEF3E400F8FBB50EB C:\Windows\CCM\CcmExec.exe
  SHA256    BB8B199F504DB7E81CF32CE3C458D2A8533BEAC8DCEFA5DF024FA79FE132648A C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
  SHA256    B07227072C4220B199A9FB25B75FA45BF8934D104315279B0A7C4F423EF30A0C C:\Windows\CCM\RemCtrl\CmRcService.exe
  SHA256    C8256C3B78FD7BEA3622A045C07BD49372537158621298DF05A505CD8EEE56FF C:\Users\Jannus.Fugal\AppData\Local\Programs\Microsoft VS ...
  SHA256    BAF97B2A629723947539CFF84E896CD29565AB4BB68B0CEC515EB5C5D6637B69 C:\Windows\system32\conhost.exe
  SHA256    A0DF21D82DAA60F8181589F4CE96441891B6E13716F353E9D71C8B303CF398D2 C:\Windows\system32\ctfmon.exe



  Here we run the function twice.  The first example demonstrates the function running with no additional parameters, which evaluates all running processes that has a "Path" property and retrieves the MD5 hash for that executable.  In the second example we change the hash algorithm using the "-Algorithm" parameter (which contains a Validate Set Attribute, allowing us to tab through the available algorithms) and get back a similar output as we did in the first example.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ServiceBinaryHash.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-03-29 | Initial Version
  Dependencies:  
  Notes:


  .
#>
function Get-ServiceBinaryHash {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Specifies the cryptographic hash function to use for computing the hash value of the contents of the specified file. A cryptographic hash function includes the property that it is not possible to find two distinct inputs that generate the same hash values. Hash
    functions are commonly used with digital signatures and for data integrity. The acceptable values for this parameter are:'SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160'")]
    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160')]
    [String]
    $Algorithm = 'MD5'
  )
  
  begin {}
  
  process {

    function Get-ServiceBinary {
      [CmdletBinding()]
      param ()    
    
      # Location in the registery where "Services" for the system are located
      $hklm_svcs = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\*    
      foreach ($item in $hklm_svcs) {       
        
        if ($item.ImagePath -match "\.sys$|\.exe$") {   
          # This first check matches all objects with an ImagePath ending in '.sys' or '.exe'
  
          $prop = [ordered]@{
            ServiceName = $item.PSChildName
            ImagePath = $item.ImagePath
            Binary = ($item.ImagePath | Split-Path -Leaf) -replace ",-\d+$", "" -replace "^@", ""
            BinaryPath = ($item.ImagePath) -replace ",-\d+$", "" -replace "^@", ""
          }    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj    
        }
        elseif ($item.ImagePath -match '\.exe"') {    
          # This check maches any object that has " " around the ImagePath where the the final characters are '.exe"'
  
          $BinaryPath = $item.imagepath -replace 'exe".*','exe' -replace '"'    
          $prop = [ordered]@{
            ServiceName = $item.PSChildName
            ImagePath = $item.ImagePath
            Binary = $BinaryPath | Split-Path -Leaf
            BinaryPath = $BinaryPath
          }    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
        elseif ($item.PSChildName -eq "exfat" -or $item.PSChildName -eq "fastfat") {    
          # The "exfat" and "fastfat" drivers are outliers (that don't show any binary references on the computer I'm testing on) so we are handling them individually
  
          $prop = [ordered]@{
            ServiceName = $item.PSChildName
            ImagePath = $item.ImagePath
            Binary =  $null
            BinaryPath = $null
          }    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
        else {
          # This matches everything else and is very useful for all of the "ScvHost" services
  
          if ($null -notlike $item.Description) {
            $Binary = ($item.Description | Split-Path -Leaf) -replace ",-\d+$", "" -replace "^@", ""
          }
          else {
            $Binary = $null
          }
          
          $BinaryPath = ($item.Description) -replace ",-\d+$", "" -replace "^@", ""
  
          # Here we are doing a check for any outliers... often "Description" has the correct information we are after, which is why we have used it as the primary property to parse for the resulting "Binary|BinaryPath"... but in one occasion we had a straggler where the "Description" did not contain the Binary / Binary Path
          if ($Binary -notmatch "\.\w{3}$" -and $item.ImagePath -match "\.exe /") {    
            $BinaryPath = $item.ImagePath -replace "\.exe /.*", "\.exe"
            $Binary = $BinaryPath | Split-Path -Leaf    
          }
  
          $prop = [ordered]@{
            ServiceName = $item.PSChildName
            ImagePath = $item.ImagePath
            Binary =  $Binary
            BinaryPath = $BinaryPath
          }    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }   
      
      }     
 
    }


    $ServiceBinaries = Get-ServiceBinary

    $BinaryPathNotBlank = $ServiceBinaries | ? {$_.BinaryPath}

    $BinaryPathNotBlank | % {
      if ($_.BinaryPath -notlike "*\*") {
        $_.BinaryPath = "$env:SystemRoot\System32\$($_.BinaryPath)"
      }
      else {
        $_.BinaryPath = $_.BinaryPath `
        -replace "^\\SystemRoot","$env:SystemRoot" `
        -replace "^%SystemRoot%","$env:SystemRoot" `
        -replace "^System32","$env:SystemRoot\System32" `
        -replace "^%windir%","$env:windir" `
        -replace "^\\\?\?\\","" `
        -replace "^C:\\Program\ Files\ \(x86\)","${env:ProgramFiles(x86)}" `
        -replace "^C:\\Program\ Files","$env:ProgramFiles" `
        -replace "^C:\\ProgramData","$env:ProgramData"
      }
        
    }

    #Write-Output $BinaryPathNotBlank

    foreach ($Binary in $BinaryPathNotBlank.BinaryPath) {
      Get-FileHash -Algorithm $Algorithm -Path $Binary
    }










    #$GroupedByPath = $Procs | Group-Object Path 

    # Here we filter out any processes that have a blank 'Path', such as "csrss" and "smss"
    #$PathNotBlank = $GroupedByPath | ? {$_.Name}

    <#
    foreach ($Path in $PathNotBlank.Name) {
      Get-FileHash -Path $Path -Algorithm $Algorithm
    }
    #>
    
  }
  
  end {}
}