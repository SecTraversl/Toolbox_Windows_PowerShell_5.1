<#
.SYNOPSIS
  The "Get-WmicShare" function is a WMIC command wrapper for getting a list of shared folders and related information on one or many computers.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> $Shares = Get-WmicShare
  PS C:\> $Shares | ft

  ComputerName  Name   Description   Path       Status Type       AllowMaximum AccessMask InstallDate MaximumAllowed
  ------------  ----   -----------   ----       ------ ----       ------------ ---------- ----------- --------------
  LocLaptop-PC1 ADMIN$ Remote Admin  C:\Windows OK                TRUE
  LocLaptop-PC1 C$     Default share C:\        OK                TRUE
  LocLaptop-PC1 D$     Default share D:\        OK                TRUE
  LocLaptop-PC1 E$     Default share E:\        OK                TRUE
  LocLaptop-PC1 IPC$   Remote IPC               OK     2147483651 TRUE



  Here we run the function without additional parameters which, by default, queries the local machine.  Share name, Description, and Path are key components of the output.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Shares = Get-WmicShare -ComputerName $list
  PS C:\>
  PS C:\> $Shares | ft

  ComputerName                   Name   Description   Path       Status Type       AllowMaximum AccessMask InstallDate MaximumAllowed
  ------------                   ----   -----------   ----       ------ ----       ------------ ---------- ----------- --------------
  LocLaptop-PC1                  ADMIN$ Remote Admin  C:\Windows OK                TRUE
  LocLaptop-PC1                  C$     Default share C:\        OK                TRUE
  LocLaptop-PC1                  D$     Default share D:\        OK                TRUE
  LocLaptop-PC1                  E$     Default share E:\        OK                TRUE
  LocLaptop-PC1                  IPC$   Remote IPC               OK     2147483651 TRUE
  RemDesktopPC.corp.Roxboard.com ADMIN$ Remote Admin  C:\WINDOWS OK     2147483651 TRUE
  RemDesktopPC.corp.Roxboard.com C$     Default share C:\        OK     2147483651 TRUE
  RemDesktopPC.corp.Roxboard.com IPC$   Remote IPC               OK     2147483651 TRUE
  RemDesktopPC.corp.Roxboard.com Users                C:\Users   OK     0          TRUE



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Shares" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we see an additional share that is not default on Windows leading to the directory path of "C:\Users".

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicShare
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicShare {
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
      $param = "/node:`"$($Computer)`"",'share','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicShareListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicShareListFull.Count; $i++) {
        if ($WmicShareListFull[$i] -like "AccessMask=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicShareListFull[$i + $counter]
            $counter += 1
          } until ($WmicShareListFull[$i+1 + $counter] -like "AccessMask=*" -or $WmicShareListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AccessMask=' { $AccessMask_Value = (($e -split "=",2).trim())[1] }
              '^AllowMaximum=' { $AllowMaximum_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^MaximumAllowed=' { $MaximumAllowed_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^Path=' { $Path_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
              '^Type=' { $Type_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AccessMask = $AccessMask_Value
            AllowMaximum = $AllowMaximum_Value
            Description = $Description_Value
            InstallDate = $InstallDate_Value
            MaximumAllowed = $MaximumAllowed_Value
            Name = $Name_Value
            Path = $Path_Value
            Status = $Status_Value
            Type = $Type_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Name,Description,Path,Status,Type,AllowMaximum,AccessMask,InstallDate,MaximumAllowed

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}