

function Get-WmicSid2User {
  [CmdletBinding()]
  param ()
  
  begin {    }
  
  process {
    $wmic = wmic useraccount get name,sid
    
    # We Trim the trailing spaces.  We replace the multiple Spaces with a Single Tab.  We Delimit on Tab.  The cmdlet automatically interprets the top line as the header.
    $wmic.trim() -replace '\s+',"`t" | ConvertFrom-Csv -Delimiter "`t"
  }
  
  end {    }
}