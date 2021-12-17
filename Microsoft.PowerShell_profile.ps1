if ( Get-Command Set-PSReadlineKeyHandler -ErrorAction SilentlyContinue ) {
	Set-PSReadlineKeyHandler -Key Tab -Function Complete
	Set-PSReadlineKeyHandler -key ctrl+d -Function ViExit
}

Set-Alias -Name which -Value Get-Command

Set-PSReadLineOption -PredictionSource History

Set-PoshPrompt -Theme half-life
Import-Module -Name Terminal-Icons
