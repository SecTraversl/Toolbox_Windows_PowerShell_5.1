function Get-EmailLinksDefanged{
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Plain Text body of the email.')]
    [string[]]
    $PlainTextEmail
  )
  
  begin {}
  
  process {

    $FindHttp = (($PlainTextEmail | Select-String "http") -replace '.*<' -replace '>' | Select-String "http")
    $LinksConvertedToStringObjects = $FindHttp | ForEach-Object {$_.ToString() -replace "http","hxxp"}

    for ($i = 0; $i -lt $LinksConvertedToStringObjects.Count; $i++) {      
      $prop = @{
        LinkNumber = "Link$($i+1)"
        LinkValue = $LinksConvertedToStringObjects[$i]
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }

  }
  
  end {}
}