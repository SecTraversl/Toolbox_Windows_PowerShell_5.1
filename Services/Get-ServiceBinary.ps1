<#
.SYNOPSIS
  The "Get-ServiceBinary" function retrieves the Services found within the computer's registry and identifies the corresponding binary that is invoked when the Service runs. 

.DESCRIPTION
.EXAMPLE
  PS C:\> $ServiceBinaries = Get-ServiceBinary -ErrorAction SilentlyContinue
  PS C:\> $ServiceBinaries | measure
  Count    : 741


  PS C:\> $ServiceBinaries | Select-Object -First 10

  ServiceName   ImagePath                                         Binary       BinaryPath
  -----------   ---------                                         ------       ----------
  1394ohci      \SystemRoot\System32\drivers\1394ohci.sys         1394ohci.sys \SystemRoot\System32\drivers\1394ohci.sys
  3ware         System32\drivers\3ware.sys                        3ware.sys    System32\drivers\3ware.sys
  AarSvc        C:\Windows\system32\svchost.exe -k AarSvcGroup -p AarSvc.dll   %SystemRoot%\system32\AarSvc.dll
  AarSvc_1449c4 C:\Windows\system32\svchost.exe -k AarSvcGroup -p AarSvc.dll   %SystemRoot%\system32\AarSvc.dll
  ACPI          System32\drivers\ACPI.sys                         ACPI.sys     System32\drivers\ACPI.sys
  AcpiDev       \SystemRoot\System32\drivers\AcpiDev.sys          AcpiDev.sys  \SystemRoot\System32\drivers\AcpiDev.sys
  acpiex        System32\Drivers\acpiex.sys                       acpiex.sys   System32\Drivers\acpiex.sys
  acpipagr      \SystemRoot\System32\drivers\acpipagr.sys         acpipagr.sys \SystemRoot\System32\drivers\acpipagr.sys
  AcpiPmi       \SystemRoot\System32\drivers\acpipmi.sys          acpipmi.sys  \SystemRoot\System32\drivers\acpipmi.sys
  acpitime      \SystemRoot\System32\drivers\acpitime.sys         acpitime.sys \SystemRoot\System32\drivers\acpitime.sys



  Here we run the function and store the results in the "$ServiceBinaries" variable (we used the Common Parameter "-ErrorAction" with an argument of 'SilentlyContinue' to omit 2 "PermissionDenied" errors from appearing).  We then determine how many objects are within the variable, and we get a count of 741.  Finally, we display the first 10 objects.  Whenever there is an invocation of the 

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ServiceBinary.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-03-29 | Total uplift to the code, Binary and BinaryPath properties are consistently populated
  Dependencies:  
  Notes:


  .
#>
function Get-ServiceBinary {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {

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
  
  end {}
}