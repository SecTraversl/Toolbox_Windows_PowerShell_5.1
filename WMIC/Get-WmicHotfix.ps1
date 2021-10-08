<#
.SYNOPSIS
  The "Get-WmicHotfix" function is a WMIC command wrapper for getting a list of patches installed on a computer.  The results are similar to those of the "Get-HotFix" cmdlet.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Hotfixes = Get-WmicHotfix
  PS C:\> $Hotfixes | ft

  ComputerName  Description     HotFixID  InstalledOn InstalledBy                 Caption
  ------------  -----------     --------  ----------- -----------                 -------
  LocLaptop-PC1 Update          KB4586878 11/21/2020  NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4586878
  LocLaptop-PC1 Security Update KB4503308 7/9/2019                                http://support.microsoft.com/?kbid=4503308
  LocLaptop-PC1 Update          KB4506472 7/9/2019                                http://support.microsoft.com/?kbid=4506472
  LocLaptop-PC1 Security Update KB4509096 7/9/2019                                http://support.microsoft.com/?kbid=4509096
  LocLaptop-PC1 Security Update KB4516115 12/23/2019  NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4516115
  LocLaptop-PC1 Update          KB4517245 12/23/2019  NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4517245
  LocLaptop-PC1 Security Update KB4524569 12/23/2019  NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4524569
  LocLaptop-PC1 Security Update KB4537759 2/19/2020   LocLaptop-PC1\Administrator http://support.microsoft.com/?kbid=4537759
  LocLaptop-PC1 Security Update KB4538674 2/19/2020   NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4538674
  LocLaptop-PC1 Security Update KB4541338 3/13/2020   NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4541338
  LocLaptop-PC1 Security Update KB4561600 9/6/2020    NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4561600
  LocLaptop-PC1 Security Update KB4569073 9/6/2020    NT AUTHORITY\SYSTEM         http://support.microsoft.com/?kbid=4569073
  LocLaptop-PC1 Security Update KB4577670 10/17/2020  NT AUTHORITY\SYSTEM         https://support.microsoft.com/help/4577670
  LocLaptop-PC1 Security Update KB4580325 10/18/2020  NT AUTHORITY\SYSTEM         https://support.microsoft.com/help/4580325
  LocLaptop-PC1 Security Update KB4586863 11/21/2020  NT AUTHORITY\SYSTEM         https://support.microsoft.com/help/4586863
  LocLaptop-PC1 Security Update KB4586786 11/21/2020  NT AUTHORITY\SYSTEM         https://support.microsoft.com/help/4586786



  Here we run the function without additional parameters which, by default, queries the local machine.  Installation Date and HotFixID are key components of the output.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Hotfixes = Get-WmicHotfix -ComputerName $list
  PS C:\>
  PS C:\> $Hotfixes | sort HotFixId -Descending | select -f 10 | ft

  ComputerName                   Description     HotFixID  InstalledOn InstalledBy         Caption
  ------------                   -----------     --------  ----------- -----------         -------
  LocLaptop-PC1                  Update          KB4586878 11/21/2020  NT AUTHORITY\SYSTEM http://support.microsoft.com/?...
  LocLaptop-PC1                  Security Update KB4586863 11/21/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  LocLaptop-PC1                  Security Update KB4586786 11/21/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  LocLaptop-PC1                  Security Update KB4580325 10/18/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  RemDesktopPC.corp.Roxboard.com Security Update KB4580325 10/13/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  RemDesktopPC.corp.Roxboard.com Update          KB4578974 10/13/2020  NT AUTHORITY\SYSTEM http://support.microsoft.com/?...
  RemDesktopPC.corp.Roxboard.com Security Update KB4577671 10/13/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  RemDesktopPC.corp.Roxboard.com Security Update KB4577670 10/13/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  LocLaptop-PC1                  Security Update KB4577670 10/17/2020  NT AUTHORITY\SYSTEM https://support.microsoft.com/...
  LocLaptop-PC1                  Security Update KB4569073 9/6/2020    NT AUTHORITY\SYSTEM http://support.microsoft.com/?...



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Hotfixes" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we sorted by the highest numbered HotFixId and selected the top 10.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicHotfix
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicHotfix {
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
      $param = "/node:`"$($Computer)`"",'qfe','get','/format:list'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicHotfixPatchesListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicHotfixPatchesListFull.Count; $i++) {
        if ($WmicHotfixPatchesListFull[$i] -like "Caption=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicHotfixPatchesListFull[$i + $counter]
            $counter += 1
          } until ($WmicHotfixPatchesListFull[$i+1 + $counter] -like "Caption=*" -or $WmicHotfixPatchesListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^Caption=' { $Caption_Value = (($e -split "=",2).trim())[1] }
              '^CSName=' { $CSName_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^FixComments=' { $FixComments_Value = (($e -split "=",2).trim())[1] }
              '^HotFixID=' { $HotFixID_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^InstalledBy=' { $InstalledBy_Value = (($e -split "=",2).trim())[1] }
              '^InstalledOn=' { $InstalledOn_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^ServicePackInEffect=' { $ServicePackInEffect_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            Caption = $Caption_Value
            CSName = $CSName_Value
            Description = $Description_Value
            FixComments = $FixComments_Value
            HotFixID = $HotFixID_Value
            InstallDate = $InstallDate_Value
            InstalledBy = $InstalledBy_Value
            InstalledOn = $InstalledOn_Value
            Name = $Name_Value
            ServicePackInEffect = $ServicePackInEffect_Value
            Status = $Status_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Description,HotFixID,InstalledOn,InstalledBy,Caption,FixComments,InstallDate,Name,ServicePackInEffect,Status,CSName

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}