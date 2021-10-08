
# REQUIRES the following functions as well:
# - Remove-LinesPerInterval
# - ConvertFrom-SystemByte_To_HexString
# - ConvertFrom-HexString_To_Unicode16Bit


function Get-DFIR_WordWheelQuery {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the PSSession to run the command on.')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {
    # PRELIMINARY FUNCTION(S)
    # - I have defined the underlying functions upon which this code depends on below within the "if ($Session)" code block.

  }
  
  process {

    if ($Session) {         
      
      Invoke-Command -Session $Session {        

        # PRELIMINARY FUNCTION(S)

        # - Since we are running our code in a remote session... all required preliminary functions need to be defined, since they are dependencies for the primary code of this function to work, and the remote machine has no context of functions/code that it is not explicitly made to know

        function Remove-LinesPerInterval {
          [CmdletBinding()]
          param (
            [Parameter(HelpMessage = 'Reference the Object you want to remove Lines from. The first Line is always kept.')]
            [psobject]
            $Array,
            [Parameter(HelpMessage = 'Enter the interval to skip. The default value is "2".')]
            [int]
            $Interval = 2
          )
        
          begin {}
        
          process {
            $i = 0
            $FinalArray = @()
            while ($i -le $Array.Count) {
              $FinalArray += $Array[$i]
              $i += $Interval
            }
            Write-Output $FinalArray
          }
        
          end {}
        }

        function ConvertFrom-SystemByte_To_HexString {
          [CmdletBinding()]
          param (
            [Parameter(HelpMessage = 'Reference the System Byte Array you want to convert to a Hexadecimal string representation.')]
            [System.Byte[]]
            $SystemByteObject
          )
        
          begin {}
        
          process {
            $HexString = [BitConverter]::ToString($SystemByteObject)
            Write-Output $HexString
          }
        
          end {}
        }
      
        function ConvertFrom-HexString_To_Unicode16Bit {
          [CmdletBinding()]
          param (
            [Parameter(HelpMessage = 'Reference the Hexadecimal string to convert to Unicode.  This code expects that there is one byte or 2 Hexadecimal characters together by themselves.  If you have multiple bytes delimited by a hyphen, as in "73-00-61-00-6E-00-73-00-00-00"; use the following syntax:  -split "-"  | foreach {ConvertFrom-HexString_To_Unicode16Bit -HexString $_}')]
            [string]
            $HexString
          )
        
          begin {}
        
          process {
            $Unicode16Bit = [char]([convert]::toint16($HexString, 16))
            Write-Output $Unicode16Bit
          }
        
          end {}
        }

        # PRIMARY CODE

        $WordWheelQuery = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery\

        $WWQ_MRU_Order = Remove-LinesPerInterval  $WordWheelQuery.MRUListEx -Interval 4
    
        # When trying to use .Count or .Length, I was consistently getting one more number more than expected... however when referencing the "Count" property of the Measure-Object cmdlet, I was getting the correct total number of objects... so that is what I am using to remove the last object of value "255" at the end of these MRU lists...
    
        $TotalCount = ($WWQ_MRU_order | measure).count
    
        $Final_MRU_List_Order = $WWQ_MRU_Order | select -First ($TotalCount - 1)
        # OR ... When I tried the method below... there is still this 'mystery' object that is counted, so I had to subtract 2.... very strange... to keep things consistent I will not use this syntax...
        # $Final_MRU_List_Order = $WWQ_MRU_Order[0..($TotalCount - 2)]
    
        
        Write-Host "These were the last # of terms searched for in the Explorer search bar. Ordered from most recent at the top, to least recent at the bottom.`r`n" -BackgroundColor black -ForegroundColor Green
        Write-Host "The terms are displayed in order from most recently searched for to least recently searched for.`r`n" -BackgroundColor Black -ForegroundColor Green
    
        foreach ($Entry in $Final_MRU_List_Order) {
          $Translated = ((ConvertFrom-SystemByte_To_HexString $WordWheelQuery.$Entry) -split '-' | % {
              ConvertFrom-HexString_To_Unicode16Bit $_
            }) -join ''
    
          $i = 0
          $FinalWord = ''  
          while ($i -le $Translated.Length) {
            $FinalWord += $Translated[$i]
            $i += 2
          }
          Write-Output $FinalWord   
        }
      }
    }
    else {

      # PRIMARY CODE

      Invoke-Command -ScriptBlock {
        $WordWheelQuery = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery\

        $WWQ_MRU_Order = Remove-LinesPerInterval  $WordWheelQuery.MRUListEx -Interval 4
    
        # When trying to use .Count or .Length, I was consistently getting one more number more than expected... however when referencing the "Count" property of the Measure-Object cmdlet, I was getting the correct total number of objects... so that is what I am using to remove the last object of value "255" at the end of these MRU lists...
    
        $TotalCount = ($WWQ_MRU_order | measure).count
    
        $Final_MRU_List_Order = $WWQ_MRU_Order | select -First ($TotalCount - 1)
        # OR ... When I tried the method below... there is still this 'mystery' object that is counted, so I had to subtract 2.... very strange... to keep things consistent I will not use this syntax...
        # $Final_MRU_List_Order = $WWQ_MRU_Order[0..($TotalCount - 2)]
    
        
        Write-Host "These were the last # of terms searched for in the Explorer search bar. Ordered from most recent at the top, to least recent at the bottom.`r`n" -BackgroundColor black -ForegroundColor Green
        Write-Host "The terms are displayed in order from most recently searched for to least recently searched for.`r`n" -BackgroundColor Black -ForegroundColor Green
    
        foreach ($Entry in $Final_MRU_List_Order) {
          $Translated = ((ConvertFrom-SystemByte_To_HexString $WordWheelQuery.$Entry) -split '-' | % {
              ConvertFrom-HexString_To_Unicode16Bit $_
            }) -join ''
    
          $i = 0
          $FinalWord = ''  
          while ($i -le $Translated.Length) {
            $FinalWord += $Translated[$i]
            $i += 2
          }
          Write-Output $FinalWord   
        }
      }
      
    }

  }
  
  end {}
  
}