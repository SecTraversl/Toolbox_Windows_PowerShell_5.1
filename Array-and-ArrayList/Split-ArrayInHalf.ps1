<#
.SYNOPSIS
  The "Split-ArrayInHalf" function splits an array in half and will return either the "LowerSet" or "UpperSet" depending on which of those options is chosen with the "-ReturnSet" parameter.  The "-ReturnSet" parameter contains a 'ValidateSet' Attribute which allows us to tab through the two options ('LowerSet'/'UpperSet') when calling the "Split-ArrayInHalf" function. 

.DESCRIPTION
.EXAMPLE
  PS C:\> $array = @()
  PS C:\> $array += 1..54

  PS C:\> (Split-ArrayInHalf -Array $array -ReturnSet LowerSet) -join ", "
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27
  
  PS C:\> (Split-ArrayInHalf -Array $array -ReturnSet UpperSet) -join ", "
  28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54
  
  PS C:\> (Split-ArrayInHalf -Array $array -ReturnSet LowerSet) | measure
  Count    : 27

  PS C:\> (Split-ArrayInHalf -Array $array -ReturnSet UpperSet) | measure
  Count    : 27



  Here we created an array of integers 1 through 54.  We then used the "Split-ArrayInHalf" function to return the LowerSet and UpperSet, respectively.

.EXAMPLE
  PS C:\> $NameList -join ', '
  Alex, Amy, Bishal, Bryan, Dave, David, De Anna, Donald, Donn, Doug, Elizabeth, Gordon, Greg, Hasani, Jeff, Jeffrey, Jerry, Joe,
  Larry, Laurie, Mario, Mark, Neil, Paige, Paromita, Pat, Piper, Priyadharshini, Priyanka, Ray, Ryan, Sherrie, Sudha, Travis

  PS C:\> $NameList | measure
  Count    : 34

  PS C:\> $FirstHalf = Split-ArrayInHalf -Array $NameList -ReturnSet LowerSet

  PS C:\> $FirstHalf -join ', '
  Alex, Amy, Bishal, Bryan, Dave, David, De Anna, Donald, Donn, Doug, Elizabeth, Gordon, Greg, Hasani, Jeff, Jeffrey, Jerry

  PS C:\> $FirstHalf | measure
  Count    : 17
  
  PS C:\> $SecondHalf = Split-ArrayInHalf -Array $NameList -ReturnSet UpperSet

  PS C:\> $SecondHalf -join ', '
  Joe, Larry, Laurie, Mario, Mark, Neil, Paige, Paromita, Pat, Piper, Priyadharshini, Priyanka, Ray, Ryan, Sherrie, Sudha, Travis

  PS C:\> $SecondHalf | measure
  Count    : 17



  Here we have an array of names.  We use "Split-ArrayInHalf" to capture the first half of names in the variable "$FirstHalf" and the latter half of the names in the variable "$SecondHalf".

.INPUTS
.OUTPUTS
.NOTES
  Name: Split-ArrayInHalf
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Split-ArrayInHalf {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, HelpMessage='Reference the Array you want to split in half.')]
    [array]
    $Array,
    [Parameter(Mandatory=$true, HelpMessage='This parameter contains a ValidateSet adAttribute.  Choose whether to return the "LowerSet" or the "UpperSet" of the Array.')]
    [ValidateSet("LowerSet","UpperSet")]
    [string]
    $ReturnSet
  )
  
  begin {}
  
  process {
    $TotalLength = $Array.Count
    $HalfwayNumber = $Array.Count / 2
    $LowerSet = $Array[0..($HalfwayNumber -1)]
    $UpperSet = $Array[($HalfwayNumber)..($TotalLength)]

    switch ($ReturnSet) {
      "LowerSet" { Write-Output $LowerSet }
      "UpperSet" { Write-Output $UpperSet }
    }
  }
  
  end {}
}