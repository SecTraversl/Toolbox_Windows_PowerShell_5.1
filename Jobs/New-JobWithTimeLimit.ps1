<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  New-JobWithTimeLimit.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-04-01 | Initial Version
  Dependencies:  
  Notes:
  - This was where I retrieved the base for this code: https://stackoverflow.com/questions/3019954/how-can-you-set-a-time-limit-for-a-powershell-script-to-run-for

  - The StackOverflow post cited Adam Bertram as the inspiration, referencing this code: https://blog.ipswitch.com/creating-a-timeout-feature-in-your-powershell-scripts

  - In order to use a non-native function that you built as the -ScriptBlock, you must use this syntax - 
  -ScriptBlock ${function:Get-SomethingDone} - reference: https://social.technet.microsoft.com/Forums/en-US/cb4ee706-8e49-4548-a08a-9cd5aaf5a2bf/using-powershell-startjob-to-start-powershell-function-with-parameters?forum=ITCG
    - Tests conducted proving out the " -ScriptBlock ${function:Get-SomethingDone} " syntax nuance:
      Start-Job -ScriptBlock {HOSTNAME.EXE} | Wait-Job | Receive-Job
      Start-Job -ScriptBlock {(Get-LocalUser).Name} | Wait-Job | Receive-Job
      Start-Job -ScriptBlock {(Get-FileHash *)} | Wait-Job | Receive-Job
      Start-Job -ScriptBlock {Get-LocalGuestAccountSID} | Wait-Job | Receive-Job  # This is a function I built - This syntax resulted in error
      Start-Job -ScriptBlock ${function:Get-LocalGuestAccountSID} | Wait-Job | Receive-Job  # This syntax yielded success 

  - Using an "-InitializationScript" is apparently another way to being able to reference a custom-built function... discovered this here: https://stackoverflow.com/questions/7162090/how-do-i-start-a-job-of-a-function-i-just-defined
    - Tested conducted proving out the use of an "-InitializationScript" :
      # THIS FAILED
      Start-Job -ScriptBlock { uptime } | Wait-Job | Receive-Job

      # THIS SUCCEEDED
      $functions = {
        function uptime {
          (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        }
      }
      Start-Job -InitializationScript $functions -ScriptBlock { uptime } | Wait-Job | Receive-Job

  - This was also an interesting post for " How do I pass a scriptblock as one of the parameters in start-job "... The syntax provided here is a "workaround" when you want / need to embed some action in the '-ArgumentList' parameter... may be handy in the future: https://stackoverflow.com/questions/11844390/how-do-i-pass-a-scriptblock-as-one-of-the-parameters-in-start-job/11844992#11844992
      - Example: 
        Start-Job -ArgumentList "write-host hello"  -scriptblock {
            param (
                [parameter(Mandatory=$true)][string]$ScriptBlock
            )
            & ([scriptblock]::Create($ScriptBlock))
        } | Wait-Job | Receive-Job
      - Result:
        hello

  - This was a good reference for viewing / interacting with automatic "ChildJobs" and "Errors" with Start-Job:  https://www.gngrninja.com/script-ninja/2016/5/29/powershell-getting-started-part-10-jobs

  - A good reference (more Adam Bertram) for reflecting $args[0] within a -ScriptBlock, using a refernce to -ArgumentsList $MyArgument -- I have needed this for previous trials with Start-Job:  https://mcpmag.com/articles/2018/04/18/background-jobs-in-powershell.aspx

  .
#>
function New-JobWithTimeLimit {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [ScriptBlock]
    $ScriptBlock,
    [Parameter()]
    [psobject]
    $ArgumentList,
    [Parameter(Mandatory=$true, HelpMessage="Specify the Time Limit in Seconds.")]
    [int]
    $TimeLimit,
    [Parameter()]
    [int]
    $TimeCheckInterval = 1
  )
  
  begin {}
  
  process {
    try {

      if ($ArgumentList) {
        $job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList
      }
      else {
        $job = Start-Job -ScriptBlock $ScriptBlock
      }

      $timer = [Diagnostics.Stopwatch]::StartNew()

      while (($timer.Elapsed.TotalSeconds -lt $TimeLimit) -and ('Running' -eq $job.JobStateInfo.State)) {
        $totalSecs = [math]::Round($timer.Elapsed.TotalSeconds, 0)
        $tsString = $("{0:hh}:{0:mm}:{0:ss}" -f [timespan]::fromseconds($totalSecs))
        Write-Progress "Still waiting for action $($Job.Name) to complete after [$tsString] ..."
        Start-Sleep -Seconds ([math]::Min($TimeCheckInterval, [System.Int32]($TimeLimit - $totalSecs)))
      }
      $timer.Stop()
      $totalSecs = [math]::Round($timer.Elapsed.TotalSeconds, 0)
      $tsString = $("{0:hh}:{0:mm}:{0:ss}" -f [timespan]::fromseconds($totalSecs))

      if ($timer.Elapsed.TotalSeconds -gt $TimeLimit -and ('Running' -eq $job.JobStateInfo.State)) {
        Stop-Job $job
        Write-Verbose "Action $($Job.Name) did not complete before timeout period of $tsString."

      } 
      else {
        if ('Failed' -eq $job.JobStateInfo.State) {
          $err = $job.ChildJobs[0].Error
          $reason = $job.ChildJobs[0].JobStateInfo.Reason.Message
          Write-Error "Job $($Job.Name) failed after with the following Error and Reason: $err, $reason"
        }
        else {
          Write-Verbose "Action $($Job.Name) completed before timeout period. job ran: $tsString."
          $Job | Receive-Job
        }
      }

    }
    catch {
      
      Write-Error $_.Exception.Message

    }
    
  }
  
  end {}
}

<#
$urlList = @(
  'http://l.e.starbucks.com/rts/go2.aspx?h=35273&tp=i-1NGB-Ij-bQ-AaHIN-1p-EAb4p-1c-AXcoI-l5t5u1rYbL-rc3NU'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35274&tp=i-1NGB-Ij-bQ-AaHIN-1p-EAb4p-1c-AXcoI-l5t5u1rYbL-rc3NU'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35275&tp=i-1NGB-Ij-bQ-AaHIN-1p-EAb4p-1c-AXcoI-l5t5u1rYbL-rc3NU'
  'https://www.starbucksearthmonthgame.com'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35276&tp=i-1NGB-Ij-bQ-AaHIN-1p-EAb4p-1c-AXcoI-l5t5u1rYbL-rc3NU'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35278&tp=i-1NGB-Ij-bQ-AaHIN-1p-EAb4p-1c-AXcoI-l5t5u1rYbL-rc3NU'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35264&tp=i-1NHD-Ij-bQ-AaHIN-1p-EAb4p-1c-2Rx-AXcoI-l5t5u1rYbL-HNap9'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35271&tp=i-1NHD-Ij-bQ-AaHIN-1p-EAb4p-1c-2Rx-AXcoI-l5t5u1rYbL-HNap9'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35272&tp=i-1NHD-Ij-bQ-AaHIN-1p-EAb4p-1c-2Rx-AXcoI-l5t5u1rYbL-HNap9'
  'http://l.e.starbucks.com/rts/go2.aspx?h=35267&tp=i-1NHD-Ij-bQ-AaHIN-1p-EAb4p-1c-2Rx-AXcoI-l5t5u1rYbL-HNap9'
)

$MyFunction = ${function:Get-CertificateByUrl}

$CertInfo = foreach ($url in $urlList) {
  New-JobWithTimeLimit -ScriptBlock $MyFunction -ArgumentList $url -TimeLimit 5 -Verbose
}

CertInfo | Select -First 1
$CertInfo | Select CertThumbprint, CertSubject 
$CertInfo | Select WebServer,WebCharacterSet,CertSerialNumber,CertThumbprint,CertSubject,WebResponseUri


Start-Job -ScriptBlock $MyFunction -ArgumentList $url | Wait-Job | Receive-Job




#>