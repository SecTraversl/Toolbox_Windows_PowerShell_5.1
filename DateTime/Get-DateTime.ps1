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
  Name:  Get-DateTime.ps1
  Author:  Travis Logue
  Version History:  1.4 | 2021-09-10 | Added "-TenThousandths" and "-ConvertZuluToPacific_24Clock" Parameter
  Dependencies: 
  Notes:
	- This was helpful in citing some nice succinct syntax (Get-Date).ToString("yyyy-MM-dd") :  https://stackoverflow.com/questions/22826185/setup-default-date-format-like-yyyy-mm-dd-in-powershell
  - Here we have various .NET datetime format specifiers used in an example: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.1#example-3--get-the-date-and-time-with-a--net-format-specifier
  - Here we have an exhaustive list of the .NET datetime format specifiers: https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8


  .
#>
function Get-DateTime {
	[CmdletBinding()]
	[Alias('MyDateTime')]
	param (
		[Parameter(HelpMessage = "The -Full switch will display yyyy-MM-dd_HHmm")][switch]$Full,
		[Parameter(HelpMessage = "The -YearMonthDay switch will display yyyy-MM-dd")][switch]$YearMonthDay,
		[Parameter()]
		[string]
		$ConvertZuluToPacific_24Clock,
		[Parameter(HelpMessage = 'Date Timestamp to the Ten Thousandths of a second')]
		[switch]
		$TenThousandths

	)

	if ($ConvertZuluToPacific_24Clock) {
		$ArrayOfFormats = @( (Get-Date $ConvertZuluToPacific_24Clock).GetDateTimeFormats() )
		$ArrayOfFormats[94] + "PT"
	}
	else {
		if ($Full) {
			Get-Date -Format yyyy-MM-dd_HHmm
		}
		elseif ($YearMonthDay) {
			Get-Date -Format yyyy-MM-dd
			# Another way: (Get-Date).ToString("yyyy-MM-dd")
		}
		elseif ($TenThousandths) {
			Get-Date -Format yyyy-MM-dd_HHmmss.ffff
		}
		else {
			Get-Date -Format yyyy-MM
		}
	}
	


}