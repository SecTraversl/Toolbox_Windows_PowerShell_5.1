


function Get-LocalGroupMemberPlus {
  [CmdletBinding()]
  [Alias('LocalGroupMemberPlus')]
  param ( )
  
  begin { }
  
  process {
    Get-LocalGroup -PipelineVariable original | Get-LocalGroupMember | ForEach-Object {
      $prop = [ordered]@{
        LocalGroupName = $original.Name
        LocalGroupSID = $original.SID
        MemberObjectClass = $_.ObjectClass
        MemberName = $_.Name
        MemberSID = $_.SID
        MemberPrincipalSource = $_.PrincipalSource
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
  }
  
  end { }
}

