<#
.SYNOPSIS
  The "Get-WmicBios" function is a WMIC command wrapper for getting a list of BIOS information for computer systems.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Bios = Get-WmicBios
  PS C:\> $Bios


  ComputerName          : LocLaptop-PC1
  Manufacturer          : Microsoft Corporation
  Description           : 92.3192.768
  SerialNumber          : 011075754357
  Version               : MSFT   - 0
  SMBIOSBIOSVersion     : 92.3192.768
  SMBIOSMajorVersion    : 3
  SMBIOSMinorVersion    : 2
  ReleaseDate           :
  BiosCharacteristics   : {7,11,12,16,19,20,26,27,32,33,40,42,43}
  Status                : OK
  Name                  : 92.3192.768
  SoftwareElementID     : 92.3192.768
  PrimaryBIOS           : TRUE
  SMBIOSPresent         : TRUE
  SoftwareElementState  : 3
  TargetOperatingSystem : 0
  CurrentLanguage       :
  InstallableLanguages  :
  ListOfLanguages       :
  BuildNumber           :
  CodeSet               :
  IdentificationCode    :
  InstallDate           :
  LanguageEdition       :
  OtherTargetOS         :



  Here we run the function without additional parameters which, by default, queries the local machine.  The output contains information about the BIOS on the computer; some fields will / will not be filled out, depending on the manufacturer. 

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Bios = Get-WmicBios -ComputerName $list
  PS C:\>
  PS C:\> $Bios | ft

  ComputerName                   Manufacturer          Description                           SerialNumber Version          SMBIOSBIOSVersion SMBIOSMajorVersion SMBIOSMinorVersion
  ------------                   ------------          -----------                           ------------ -------          ----------------- ------------------ ------------------
  LocLaptop-PC1                  Microsoft Corporation 92.3192.768                           011075754357 MSFT   - 0       92.3192.768       3                  2
  RemDesktopPC.corp.Roxboard.com LENOVO                Lenovo ThinkStation BIOS Ver 60KT47.0 MJLGCGM      LENOVO - 60400d0 60KT47AUS         2                  6



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Bios" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicBios
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicBios {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $wmic = 'wmic.exe'
    [array]$param = @()

    # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes    
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    $AllResults = foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"",'bios','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicBiosListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicBiosListFull.Count; $i++) {
        if ($WmicBiosListFull[$i] -like "BiosCharacteristics=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicBiosListFull[$i + $counter]
            $counter += 1
          } until ($WmicBiosListFull[$i+1 + $counter] -like "BiosCharacteristics=*" -or $WmicBiosListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^BiosCharacteristics=' { $BiosCharacteristics_Value = (($e -split "=",2).trim())[1] }
              '^BuildNumber=' { $BuildNumber_Value = (($e -split "=",2).trim())[1] }
              '^CodeSet=' { $CodeSet_Value = (($e -split "=",2).trim())[1] }
              '^CurrentLanguage=' { $CurrentLanguage_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^IdentificationCode=' { $IdentificationCode_Value = (($e -split "=",2).trim())[1] }
              '^InstallableLanguages=' { $InstallableLanguages_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^LanguageEdition=' { $LanguageEdition_Value = (($e -split "=",2).trim())[1] }
              '^ListOfLanguages=' { $ListOfLanguages_Value = (($e -split "=",2).trim())[1] }
              '^Manufacturer=' { $Manufacturer_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^OtherTargetOS=' { $OtherTargetOS_Value = (($e -split "=",2).trim())[1] }
              '^PrimaryBIOS=' { $PrimaryBIOS_Value = (($e -split "=",2).trim())[1] }
              '^ReleaseDate=' { $ReleaseDate_Value = (($e -split "=",2).trim())[1] }
              '^SerialNumber=' { $SerialNumber_Value = (($e -split "=",2).trim())[1] }
              '^SMBIOSBIOSVersion=' { $SMBIOSBIOSVersion_Value = (($e -split "=",2).trim())[1] }
              '^SMBIOSMajorVersion=' { $SMBIOSMajorVersion_Value = (($e -split "=",2).trim())[1] }
              '^SMBIOSMinorVersion=' { $SMBIOSMinorVersion_Value = (($e -split "=",2).trim())[1] }
              '^SMBIOSPresent=' { $SMBIOSPresent_Value = (($e -split "=",2).trim())[1] }
              '^SoftwareElementID=' { $SoftwareElementID_Value = (($e -split "=",2).trim())[1] }
              '^SoftwareElementState=' { $SoftwareElementState_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^TargetOperatingSystem=' { $TargetOperatingSystem_Value = (($e -split "=",2).trim())[1] }
              '^Version=' { $Version_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            BiosCharacteristics = $BiosCharacteristics_Value
            BuildNumber = $BuildNumber_Value
            CodeSet = $CodeSet_Value
            CurrentLanguage = $CurrentLanguage_Value
            Description = $Description_Value
            IdentificationCode = $IdentificationCode_Value
            InstallableLanguages = $InstallableLanguages_Value
            InstallDate = $InstallDate_Value
            LanguageEdition = $LanguageEdition_Value
            ListOfLanguages = $ListOfLanguages_Value
            Manufacturer = $Manufacturer_Value
            Name = $Name_Value
            OtherTargetOS = $OtherTargetOS_Value
            PrimaryBIOS = $PrimaryBIOS_Value
            ReleaseDate = $ReleaseDate_Value
            SerialNumber = $SerialNumber_Value
            SMBIOSBIOSVersion = $SMBIOSBIOSVersion_Value
            SMBIOSMajorVersion = $SMBIOSMajorVersion_Value
            SMBIOSMinorVersion = $SMBIOSMinorVersion_Value
            SMBIOSPresent = $SMBIOSPresent_Value
            SoftwareElementID = $SoftwareElementID_Value
            SoftwareElementState = $SoftwareElementState_Value
            Status = $Status_Value
            TargetOperatingSystem = $TargetOperatingSystem_Value
            Version = $Version_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Manufacturer,Description,SerialNumber,Version,SMBIOSBIOSVersion,SMBIOSMajorVersion,SMBIOSMinorVersion,ReleaseDate,BiosCharacteristics,Status,Name,SoftwareElementID,PrimaryBIOS,SMBIOSPresent,SoftwareElementState,TargetOperatingSystem,CurrentLanguage,InstallableLanguages,ListOfLanguages,BuildNumber,CodeSet,IdentificationCode,InstallDate,LanguageEdition,OtherTargetOS

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}