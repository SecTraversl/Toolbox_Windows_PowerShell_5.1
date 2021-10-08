<#
.SYNOPSIS
  The "Find-AlternateDataStream" function finds files which contain an alternate Data Stream (ADS).


.DESCRIPTION
.EXAMPLE
  PS C:\> $ads = Find-AlternateDataStream -Path $HOME
  PS C:\>
  PS C:\> Get-CommandRuntime
  Seconds           : 39

  PS C:\> $ads | measure
  Count    : 535

  PS C:\> $ads | select -f 10 | ft

  Directory                                                                         FileName      ADSName         Bytes
  ---------                                                                         --------      -------         -----
  C:\Users\mark.johnson\AppData\Local\Microsoft\OneNote\16.0\cache                  00009A7P.bin  Zone.Identifier 142
  C:\Users\mark.johnson\AppData\Local\Microsoft\OneNote\16.0\cache                  0000H0J0.bin  Zone.Identifier 26
  C:\Users\mark.johnson\AppData\Local\Microsoft\OneNote\16.0\cache                  0000H0KR.bin  Zone.Identifier 26
  C:\Users\mark.johnson\AppData\Local\Microsoft\OneNote\16.0\cache                  0000H0MJ.bin  Zone.Identifier 26
  C:\Users\mark.johnson\AppData\Local\Microsoft\OneNote\16.0\cache                  0000HIB8.bin  Zone.Identifier 26
  C:\Users\mark.johnson\AppData\Local\Packages\oice_16_974fa576_32c1d314_2b\AC\Temp 5A383B04.csv  Zone.Identifier 50
  C:\Users\mark.johnson\AppData\Local\Packages\oice_16_974fa576_32c1d314_2b\AC\Temp 5E1F6B61.xlsx Zone.Identifier 50
  C:\Users\mark.johnson\AppData\Local\Packages\oice_16_974fa576_32c1d314_2b\AC\Temp 5E2E714F.xlsx Zone.Identifier 26
  C:\Users\mark.johnson\AppData\Local\Packages\oice_16_974fa576_32c1d314_2b\AC\Temp 5E43F445.xlsx Zone.Identifier 50
  C:\Users\mark.johnson\AppData\Local\Packages\oice_16_974fa576_32c1d314_2b\AC\Temp 9A24263D.xlsx Zone.Identifier 26



  Here we run the function while specifying the "-Path" parameter to start the recursive search at the current user's $HOME directory.  The function takes 39 seconds to complete, and we get back 535 objects that contain an Alternate Data Stream.  We select the first 10 objects and see that the ADS name for each of them is "Zone.Identifier".  Also, the amount / size of the data within the ADS is shown in the "Bytes" propery.

.EXAMPLE
  PS C:\> $ads = Find-AlternateDataStream -Path "C:\"
  PS C:\>
  PS C:\> Get-CommandRuntime
  Minutes           : 3
  Seconds           : 26

  PS C:\> $ads | measure
  Count    : 543

  PS C:\> $ads | Where-Object ADSname -NotLike "Zone.Identifier"

  Directory                                                                 FileName                ADSName                                Bytes
  ---------                                                                 --------                -------                                -----
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    NtKernel.etl            SummaryInformation                    840
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    NtKernel.etl            {4c8cc155-6c1e-11d1-8e41-00c04fb9386d} 0
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    Performance Counter.blg SummaryInformation                    840
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    Performance Counter.blg {4c8cc155-6c1e-11d1-8e41-00c04fb9386d} 0
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    report.xml              Qgrg2rf1Znaluncm1kfl1xla5h            136
  C:\PerfLogs\Admin\New Data Collector Set\LocLaptop-PC1_20200612-000001    report.xml              {4c8cc155-6c1e-11d1-8e41-00c04fb9386d} 0
  C:\Users\mark.johnson\Documents\Temp\Windows Tools and Research\ADS stuff JustAFile.txt           stream1.blah                           57
  C:\Windows\System32\Tasks\Microsoft\Windows\PLA                           New Data Collector Set  0v1ieca3Feahez0jAwxjjk5uRh            656
  C:\Windows\System32\Tasks\Microsoft\Windows\PLA                           New Data Collector Set  {4c8cc155-6c1e-11d1-8e41-00c04fb9386d} 0



  Here we specify the root of the C:\ drive to start our ADS search.  The function finished in ~3 minutes and 30 seconds and 543 objects of files that have Alternate Data Streams were returned.  In this example, we further filter our results by displaying only those files that have an ADS name that is not "Zone.Identifier".  We see here that the file "NtKernel.etl" has two Alternate Data Streams: one called "Summary Information" with a size of 840 Bytes, and another called by a GUID of "{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}" with a size of 0 Bytes.

.INPUTS
.OUTPUTS
.NOTES
  Name: Find-AlternateDataStream.ps1
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:  
  Notes:
    - This tutorial from Tobias Weltner was helpful in creating a RegEx pattern match, labeling the sections we want to keep, and referencing them later within the "$prop" hashtable: https://youtu.be/Hkzd8spCfCU?t=495


  .
#>
function Find-AlternateDataStream {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Specify the path from which to start the recursive search. DEFAULT is the current directory.')]
    [string]
    $Path = (Get-Location)
  )
  
  begin {}
  
  process {    
    
    # Here we are recursively searching for files (/s - recursion), while also displaying the Alternate Data Stream for the given file if it exists (/r - displays the ADS), removing Directories from the final output (/A:-D)
    $GetADSRecursively = "dir $Path /r /s /A:-D" | cmd.exe

    # Next we filter for each line that starts with " Directory of" or for each line that ends with "$DATA" using a Case Sensitive matching criteria
    # We want the final list to be "String Objects", not a "MatchInfo Object"  so we use the ".ToString()" method on each MatchInfo object
    $FilterForDirectoryNameAndADSFiles = $GetADSRecursively | Select-String -CaseSensitive '^ Directory of|\$DATA$' | ForEach-Object { $_.ToString() }

    # Here we add a marker to the end of our String Array that we will use as a stop action trigger in our loops
    $FilterForDirectoryNameAndADSFiles += "END OF THE LINE"

    for ($i = 0; $i -lt $FilterForDirectoryNameAndADSFiles.Count; $i++) {

      if ($FilterForDirectoryNameAndADSFiles[$i] -like " Directory of*" `
          -and $FilterForDirectoryNameAndADSFiles[$i + 1] -notlike " Directory of*" `
          -and $FilterForDirectoryNameAndADSFiles[$i + 1] -notlike "END OF THE LINE") {

        $counter = 0
        $ObjectArray = @()
        $DirectoryName = $FilterForDirectoryNameAndADSFiles[$i].Trimstart(" Directory of ")

        $pattern = '^(?<Bytes>\d{1,})\s(?<FileName>.*):(?<StreamName>.*):\$DATA$'

        do {
          $ObjectArray += $FilterForDirectoryNameAndADSFiles[$i + 1 + $counter] 
          $counter += 1
        } until ($FilterForDirectoryNameAndADSFiles[$i + 1 + $counter] -like " Directory of*" -or $FilterForDirectoryNameAndADSFiles[$i + 1 + $counter] -like "END OF THE LINE") 
  
        foreach ($e in $ObjectArray) {
          $CleanedUp = $e.Trimstart()

          if ($CleanedUp -match $pattern) {
            $prop = [ordered]@{
              Directory = $DirectoryName
              FileName = $Matches.FileName
              ADSName = $Matches.StreamName
              Bytes = $Matches.Bytes
            }

            $obj = New-Object -TypeName psobject -Property $prop
            Write-Output $obj
          }
          else {
            Write-Output "WE HAVE HAD A PROBLEM WITH OUR MATCHING SYNTAX!!!"
          }     

        }
        
      }

    }


  }
  
  end {}
}