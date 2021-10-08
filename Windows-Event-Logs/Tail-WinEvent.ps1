
function Tail-WinEvent {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter the LogName')]
        [string]$LogName
    )
   

    $FirstLine = @{
        Name       = 'FirstLine';
        Expression = {
            ($_.message -split "`n")[0]
        }
    }

    $Properties = 'RecordId', 'TimeCreated', 'Id', $FirstLine

    $Primer = Get-WinEvent -LogName $LogName -MaxEvents 1

    $Primer | Format-Table -Property $Properties -AutoSize -Wrap

    while ($true) {
        Start-Sleep -Seconds 1;
        $Compare = Get-WinEvent -LogName $LogName -MaxEvents 1;
        if ($Primer.RecordId -eq $Compare.RecordId) {
            $null
        }
        elseif ($Compare.RecordId - $Primer.RecordId -eq 1) {
            Write-Output $Compare | 
            Format-Table -Property $Properties -AutoSize -Wrap;
            $Primer = $Compare
        }
        else { 
            $MaxEvents = $Compare.RecordId - $Primer.RecordID;
            Get-WinEvent $LogName -MaxEvents $MaxEvents |
            Sort-Object RecordId |
            Format-Table -Property $Properties -AutoSize -Wrap;
            $Primer = $Compare
        }
    }

}
