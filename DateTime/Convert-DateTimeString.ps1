<#
.SYNOPSIS
  The "Convert-DateTimeString" function takes a given datetime string along with the specified format that datetime string has, then converts it to a different string format as specified. 
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Convert-DateTimeString -DateTimeString '20210303' -CurrentFormat 'yyyyMMdd' -NewFormat 'MM/dd/yyyy'
  03/03/2021



  Here we take the given datetime string, indicate the current format, and specify the desired format.

.EXAMPLE
  PS C:\> (get-date).ToString()
  8/6/2021 9:35:43 AM

  PS C:\> Convert-DateTimeString `
  >> -DateTimeString ((get-date).ToString()) `
  >> -CurrentFormat 'M/d/yyyy h:mm:ss tt' `
  >> -NewFormat 'yyyy-MM-dd HH:mm:ss'
  2021-08-06 09:35:46



  Here we first show the datetime string representation we are working with.  Then in the function we specify how the datetime string is currently formatted, as well as the final format we want.  An exhaustive list of the .NET datetime format specifiers can be found here: https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8

.EXAMPLE
  PS C:\> (get-date).ToUniversalTime().ToString()
  8/6/2021 6:03:34 PM

  PS C:\> Convert-DateTimeString `
  >> -DateTimeString (get-date).ToUniversalTime().ToString() `
  >> -CurrentFormat 'M/d/yyyy h:mm:ss tt' `
  >> -NewFormat 'yyyy-MM-dd HH:mm:ss'
  2021-08-06 18:03:50

  PS C:\> (get-date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ss')
  2021-08-06 18:08:19



  Here we do something similar to the previous example.  In this example we are first converting the string to UTC time.  Here we see the significance of the "h" representing a 12-hour format versus the "H" representing a 24-hour format - if we don't specify the correct "h/H" designator there are circumstances when our conversion will error out.  The last example here demonstrates a way to use built-in capability of DateTime object methods to achieve the same conversion we are accomplishing with the function.

.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-DateTimeString.ps1
  Author: Travis Logue
  Version History: 1.1 | 2020-08-02 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in creating a succinct way to make the conversions: https://stackoverflow.com/questions/38717490/convert-a-string-to-datetime-in-powershell
  - Here we have various .NET datetime format specifiers used in an example: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.1#example-3--get-the-date-and-time-with-a--net-format-specifier
  - Here we have an exhaustive list of the .NET datetime format specifiers: https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8



  .
#>
function Convert-DateTimeString {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $DateTimeString,
    [Parameter(Mandatory)]
    [string]
    $CurrentFormat,
    [Parameter(Mandatory)]
    [string]
    $NewFormat
  )
  
  begin {}
  
  process {
    $ObjectForm = [datetime]::ParseExact($DateTimeString, $CurrentFormat, $null)
    $ObjectForm.ToString($NewFormat)
  }
  
  end {}
}

