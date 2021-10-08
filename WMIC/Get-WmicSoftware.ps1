<#
.SYNOPSIS
  The "Get-WmicSoftware" function is a WMIC command wrapper for getting a list of programs installed on a computer (specifically those that were installed using a ".msi" package).

.DESCRIPTION
.EXAMPLE
  PS C:\> $Software = Get-WmicSoftware
  PS C:\> $Software[15]


  ComputerName      : LocLaptop-PC1
  Description       : Microsoft PowerPoint MUI (English) 2016
  Vendor            : Microsoft Corporation
  PackageName       : PowerPointMUI.msi
  Version           : 16.0.4266.1001
  InstallDate       : 20201120
  InstallLocation   : C:\Program Files\Microsoft Office\
  IdentifyingNumber : {90160000-0018-0409-1000-0000000FF1CE}
  PackageCache      : C:\Windows\Installer\12e8fd.msi
  PackageCode       : {1993A186-9BA0-4528-A854-B414F42038BA}
  InstallSource     : C:\MSOCache\All Users\{90160000-0018-0409-1000-0000000FF1CE}-C\
  HelpLink          :
  URLInfoAbout      :
  URLUpdateInfo     :
  ProductID         :
  Transforms        :
  RegOwner          :
  InstallState      : 5
  LocalPackage      : C:\Windows\Installer\12e8fd.msi
  Name              : PowerPointMUI.msi
  RegCompany        :
  WordCount         : 0
  Caption           : Microsoft PowerPoint MUI (English) 2016
  Language          : 1033
  AssignmentType    :
  HelpTelephone     :
  InstallDate2      :
  SKUNumber         :



  Here we run the function without additional parameters which, by default, queries the local machine.  We then display the information regarding the installation of the "PowerPoint" program.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Software = Get-WmicSoftware -ComputerName $list
  PS C:\> $Software | sort InstallDate -Descending | select -f 10 | ft

  ComputerName                   Description                                     Vendor                     PackageName                   Version        InstallDate InstallLocation
  ------------                   -----------                                     ------                     -----------                   -------        ----------- ---------------
  LocLaptop-PC1                  Oracle VM VirtualBox 6.1.16                     Oracle Corporation         VirtualBox-6.1.16-r140961.msi 6.1.16         20201215
  LocLaptop-PC1                  Adobe Acrobat Reader DC                         Adobe Systems Incorporated AcroRead.msi                  20.013.20074   20201209    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft PowerPoint MUI (English) 2016         Microsoft Corporation      PowerPointMUI.msi             16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Outlook MUI (English) 2016            Microsoft Corporation      OutlookMUI.msi                16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Word MUI (English) 2016               Microsoft Corporation      WordMUI.msi                   16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Skype for Business MUI (English) 2016 Microsoft Corporation      LyncMUI.msi                   16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Office Professional Plus 2016         Microsoft Corporation      ProPlusWW.msi                 16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Excel MUI (English) 2016              Microsoft Corporation      ExcelMUI.msi                  16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Microsoft Visio Professional 2016               Microsoft Corporation      VisProWW.msi                  16.0.4266.1001 20201207    C:\Program F...
  RemDesktopPC.corp.Roxboard.com Google Update Helper                            Google LLC                 GoogleUpdateHelper.msi        1.3.36.51      20201203



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Software" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we also selected the first 10 programs between the two machines that were most recently installed.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicSoftware
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicSoftware {
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
      $param = "/node:`"$($Computer)`"",'product','get','/format:list'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicProductListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicProductListFull.Count; $i++) {
        if ($WmicProductListFull[$i] -like "AssignmentType=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicProductListFull[$i + $counter]
            $counter += 1
          } until ($WmicProductListFull[$i+1 + $counter] -like "AssignmentType=*" -or $WmicProductListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AssignmentType=' { $AssignmentType_Value = (($e -split "=",2).trim())[1] }
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^HelpLink=' { $HelpLink_Value = (($e -split "=",2).trim())[1] }
              '^HelpTelephone=' { $HelpTelephone_Value = (($e -split "=",2).trim())[1] }
              '^IdentifyingNumber=' { $IdentifyingNumber_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate2=' { $InstallDate2_Value = (($e -split "=",2).trim())[1] }
              '^InstallLocation=' { $InstallLocation_Value = (($e -split "=",2).trim())[1] }
              '^InstallSource=' { $InstallSource_Value = (($e -split "=",2).trim())[1] }
              '^InstallState=' { $InstallState_Value = (($e -split "=",2).trim())[1] }
              '^Language=' { $Language_Value = (($e -split "=",2).trim())[1] }
              '^LocalPackage=' { $LocalPackage_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^PackageCache=' { $PackageCache_Value = (($e -split "=",2).trim())[1] }
              '^PackageCode=' { $PackageCode_Value = (($e -split "=",2).trim())[1] }
              '^PackageName=' { $PackageName_Value = (($e -split "=",2).trim())[1] }
              '^ProductID=' { $ProductID_Value = (($e -split "=",2).trim())[1] }
              '^RegCompany=' { $RegCompany_Value = (($e -split "=",2).trim())[1] }
              '^RegOwner=' { $RegOwner_Value = (($e -split "=",2).trim())[1] }
              '^SKUNumber=' { $SKUNumber_Value = (($e -split "=",2).trim())[1] }
              '^Transforms=' { $Transforms_Value = (($e -split "=",2).trim())[1] }
              '^URLInfoAbout=' { $URLInfoAbout_Value = (($e -split "=",2).trim())[1] }
              '^URLUpdateInfo=' { $URLUpdateInfo_Value = (($e -split "=",2).trim())[1] }
              '^Vendor=' { $Vendor_Value = (($e -split "=",2).trim())[1] }
              '^Version=' { $Version_Value = (($e -split "=",2).trim())[1] }
              '^WordCount=' { $WordCount_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AssignmentType = $AssignmentType_Value
            Caption = $Caption_Value
            Description = $Description_Value
            HelpLink = $HelpLink_Value
            HelpTelephone = $HelpTelephone_Value
            IdentifyingNumber = $IdentifyingNumber_Value
            InstallDate = $InstallDate_Value
            InstallDate2 = $InstallDate2_Value
            InstallLocation = $InstallLocation_Value
            InstallSource = $InstallSource_Value
            InstallState = $InstallState_Value
            Language = $Language_Value
            LocalPackage = $LocalPackage_Value
            Name = $Name_Value
            PackageCache = $PackageCache_Value
            PackageCode = $PackageCode_Value
            PackageName = $PackageName_Value
            ProductID = $ProductID_Value
            RegCompany = $RegCompany_Value
            RegOwner = $RegOwner_Value
            SKUNumber = $SKUNumber_Value
            Transforms = $Transforms_Value
            URLInfoAbout = $URLInfoAbout_Value
            URLUpdateInfo = $URLUpdateInfo_Value
            Vendor = $Vendor_Value
            Version = $Version_Value
            WordCount = $WordCount_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,Vendor,PackageName,Version,InstallDate,InstallLocation,IdentifyingNumber,PackageCache,PackageCode,InstallSource,HelpLink,URLInfoAbout,URLUpdateInfo,ProductID,Transforms,RegOwner,InstallState,LocalPackage,Name,RegCompany,WordCount,Caption,Language,AssignmentType,HelpTelephone,InstallDate2,SKUNumber

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}