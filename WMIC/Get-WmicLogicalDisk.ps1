<#
.SYNOPSIS
  The "Get-WmicLogicalDisk" function is a WMIC command wrapper for getting a list of volumes / Drive Letters and related information on one or many computers.  The Drive letter, Volume Name, Serial Number, File System, Size, Description, and Free Space are some key aspects of the output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $LogicalDisk = Get-WmicLogicalDisk
  PS C:\> $LogicalDisk | ft

  ComputerName  Caption VolumeName       VolumeSerialNumber FileSystem SizeGB  FreeSpaceGB Description      DriveType VolumeDirty
  ------------  ------- ----------       ------------------ ---------- ------  ----------- -----------      --------- -----------
  LocLaptop-PC1 C:                       10093B7C           NTFS       118.62  9.10        Local Fixed Disk 3         FALSE
  LocLaptop-PC1 D:      Ford Drive Ultra 4424C45B           NTFS       1862.99 1769.00     Local Fixed Disk 3         FALSE
  LocLaptop-PC1 E:      USB10FD          9752FA93           FAT32      461.26  459.89      Removable Disk   2         FALSE



  Here we run the function without additional parameters which, by default, queries the local machine.  Here we see the default "C:" drive details, but we also see that there is an external drive shown (D:) and also a thumb drive (E:).  

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $LogicalDisk = Get-WmicLogicalDisk -ComputerName $list
  PS C:\> $LogicalDisk | ft

  ComputerName                   Caption VolumeName       VolumeSerialNumber FileSystem SizeGB  FreeSpaceGB Description      DriveType VolumeDirty
  ------------                   ------- ----------       ------------------ ---------- ------  ----------- -----------      --------- -----------
  LocLaptop-PC1                  C:                       10093B7C           NTFS       118.62  9.10        Local Fixed Disk 3         FALSE
  LocLaptop-PC1                  D:      Ford Drive Ultra 4424C45B           NTFS       1862.99 1769.00     Local Fixed Disk 3         FALSE
  LocLaptop-PC1                  E:      USB10FD          9752FA93           FAT32      461.26  459.89      Removable Disk   2         FALSE
  RemDesktopPC.corp.Roxboard.com C:                       E6A2C104           NTFS       475.98  51.73       Local Fixed Disk 3         FALSE
  RemDesktopPC.corp.Roxboard.com I:                                                     0.00    0.00        CD-ROM Disc      5



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer computers in the variable "$LogicalDisk", and use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicLogicalDisk.ps1
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicLogicalDisk {
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
      $param = "/node:`"$($Computer)`"",'logicaldisk','get','/format:list'     
      $Results = & $wmic $param #| Where-Object {$_}
      $WmicLogicalDiskListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicLogicalDiskListFull.Count; $i++) {
        if ($WmicLogicalDiskListFull[$i] -like "Access=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicLogicalDiskListFull[$i + $counter]
            $counter += 1
          } until ($WmicLogicalDiskListFull[$i+1 + $counter] -like "Access=*" -or $WmicLogicalDiskListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^Access=' { $Access_Value = (($e -split "=",2).trim())[1] }
              '^Availability=' { $Availability_Value = (($e -split "=",2).trim())[1] }
              '^BlockSize=' { $BlockSize_Value = (($e -split "=",2).trim())[1] }
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^Compressed=' { $Compressed_Value = (($e -split "=",2).trim())[1] }
              '^ConfigManagerErrorCode=' { $ConfigManagerErrorCode_Value = (($e -split "=",2).trim())[1] }
              '^ConfigManagerUserConfig=' { $ConfigManagerUserConfig_Value = (($e -split "=",2).trim())[1] }
              '^CreationClassName=' { $CreationClassName_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^DeviceID=' { $DeviceID_Value = (($e -split "=",2).trim())[1] }
              '^DriveType=' { $DriveType_Value = (($e -split "=",2).trim())[1] }
              '^ErrorCleared=' { $ErrorCleared_Value = (($e -split "=",2).trim())[1] }
              '^ErrorDescription=' { $ErrorDescription_Value = (($e -split "=",2).trim())[1] }
              '^ErrorMethodology=' { $ErrorMethodology_Value = (($e -split "=",2).trim())[1] }
              '^FileSystem=' { $FileSystem_Value = (($e -split "=",2).trim())[1] }
              '^FreeSpace=' { $FreeSpace_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^LastErrorCode=' { $LastErrorCode_Value = (($e -split "=",2).trim())[1] }
              '^MaximumComponentLength=' { $MaximumComponentLength_Value = (($e -split "=",2).trim())[1] }
              '^MediaType=' { $MediaType_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^NumberOfBlocks=' { $NumberOfBlocks_Value = (($e -split "=",2).trim())[1] }
              '^PNPDeviceID=' { $PNPDeviceID_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementCapabilities=' { $PowerManagementCapabilities_Value = (($e -split "=",2).trim())[1] }
              '^PowerManagementSupported=' { $PowerManagementSupported_Value = (($e -split "=",2).trim())[1] }
              '^ProviderName=' { $ProviderName_Value = (($e -split "=",2).trim())[1] }
              '^Purpose=' { $Purpose_Value = (($e -split "=",2).trim())[1] }
              '^QuotasDisabled=' { $QuotasDisabled_Value = (($e -split "=",2).trim())[1] }
              '^QuotasIncomplete=' { $QuotasIncomplete_Value = (($e -split "=",2).trim())[1] }
              '^QuotasRebuilding=' { $QuotasRebuilding_Value = (($e -split "=",2).trim())[1] }
              '^Size=' { $Size_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^StatusInfo=' { $StatusInfo_Value = (($e -split "=",2).trim())[1] }
              '^SupportsDiskQuotas=' { $SupportsDiskQuotas_Value = (($e -split "=",2).trim())[1] }
              '^SupportsFileBasedCompression=' { $SupportsFileBasedCompression_Value = (($e -split "=",2).trim())[1] }
              '^SystemCreationClassName=' { $SystemCreationClassName_Value = (($e -split "=",2).trim())[1] }
              '^SystemName=' { $SystemName_Value = (($e -split "=",2).trim())[1] }
              '^VolumeDirty=' { $VolumeDirty_Value = (($e -split "=",2).trim())[1] }
              '^VolumeName=' { $VolumeName_Value = (($e -split "=",2).trim())[1] }
              '^VolumeSerialNumber=' { $VolumeSerialNumber_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            Access = $Access_Value
            Availability = $Availability_Value
            BlockSize = $BlockSize_Value
            Caption = $Caption_Value
            Compressed = $Compressed_Value
            ConfigManagerErrorCode = $ConfigManagerErrorCode_Value
            ConfigManagerUserConfig = $ConfigManagerUserConfig_Value
            CreationClassName = $CreationClassName_Value
            Description = $Description_Value
            DeviceID = $DeviceID_Value
            DriveType = $DriveType_Value
            ErrorCleared = $ErrorCleared_Value
            ErrorDescription = $ErrorDescription_Value
            ErrorMethodology = $ErrorMethodology_Value
            FileSystem = $FileSystem_Value
            FreeSpaceGB = "{0:f2}" -f ([Math]::Round([Math]::Ceiling(($FreeSpace_Value/1GB) * 100) / 100, 2))
            InstallDate = $InstallDate_Value
            LastErrorCode = $LastErrorCode_Value
            MaximumComponentLength = $MaximumComponentLength_Value
            MediaType = $MediaType_Value
            Name = $Name_Value
            NumberOfBlocks = $NumberOfBlocks_Value
            PNPDeviceID = $PNPDeviceID_Value
            PowerManagementCapabilities = $PowerManagementCapabilities_Value
            PowerManagementSupported = $PowerManagementSupported_Value
            ProviderName = $ProviderName_Value
            Purpose = $Purpose_Value
            QuotasDisabled = $QuotasDisabled_Value
            QuotasIncomplete = $QuotasIncomplete_Value
            QuotasRebuilding = $QuotasRebuilding_Value
            SizeGB = "{0:f2}" -f ([Math]::Round([Math]::Ceiling(($Size_Value/1GB) * 100) / 100, 2))
            Status = $Status_Value
            StatusInfo = $StatusInfo_Value
            SupportsDiskQuotas = $SupportsDiskQuotas_Value
            SupportsFileBasedCompression = $SupportsFileBasedCompression_Value
            SystemCreationClassName = $SystemCreationClassName_Value
            SystemName = $SystemName_Value
            VolumeDirty = $VolumeDirty_Value
            VolumeName = $VolumeName_Value
            VolumeSerialNumber = $VolumeSerialNumber_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Caption,VolumeName,VolumeSerialNumber,FileSystem,SizeGB,FreeSpaceGB,Description,DriveType,VolumeDirty,Compressed,Access,MediaType,MaximumComponentLength,QuotasDisabled,QuotasIncomplete,QuotasRebuilding,SupportsFileBasedCompression,SupportsDiskQuotas,DeviceID,Name,CreationClassName,SystemCreationClassName,PNPDeviceID,Availability,BlockSize,ConfigManagerErrorCode,ConfigManagerUserConfig,ErrorCleared,ErrorDescription,ErrorMethodology,InstallDate,LastErrorCode,NumberOfBlocks,PowerManagementCapabilities,PowerManagementSupported,ProviderName,Purpose,Status,StatusInfo,SystemName

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}