
function Get-Error {
  [CmdletBinding()]
  param (

  )
   
  process {
    $count = 0

    foreach ($e in $error) {
      $hashtable = [ordered]@{ }

      if ($null -eq $e.Exception.InnerException) {
        $hashtable.Index = $count
        $hashtable.ItemName = $e.Exception.ItemName
        $hashtable.InnerException = "No"
        if ($null -eq $e.Exception.GetType().Fullname) {
          $hashtable.ErrorType = $null
        }
        else {
          $hashtable.ErrorType = $hashtable.ErrorType = $e.Exception.GetType().Fullname
        }
        $hashtable.Exception = $e.Exception.Message
        $hashtable.InvocationInfo = $e.InvocationInfo.PositionMessage

        New-Object -TypeName psobject -Property $hashtable
    
        $count += 1
    
      }
      else {          
        $hashtable.IndexVal = $count
        $hashtable.ItemName = $e.Exception.ItemName
        $hashtable.InnerException = "Yes"
        $hashtable.ErrorType = $e.Exception.InnerException.GetType().Fullname
        $hashtable.Exception = $e.Exception.Message
        $hashtable.InvocationInfo = $e.InvocationInfo.PositionMessage

        New-Object -TypeName psobject -Property $hashtable
    
        $count += 1

      }
    }
  }
}



