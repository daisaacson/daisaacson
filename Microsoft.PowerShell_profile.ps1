if ( Get-Command Set-PSReadlineKeyHandler -ErrorAction SilentlyContinue ) {
	Set-PSReadLineKeyHandler -Chord Tab    -Function Complete
	Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
	Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar
	Set-PSReadLineKeyHandler -Chord  Alt+b -Function BackwardWord
	Set-PSReadLineKeyHandler -Chord Ctrl+d -Function ViExit
	Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
	Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar
	Set-PSReadLineKeyHandler -Chord  Alt+f -Function ForwardWord
	Set-PSReadLineKeyHandler -Chord Ctrl+t -Function SwapCharacters
}

$GIT = "\\nas\home\Documents\GIT"

Set-Alias -Name g     -Value git.exe
Set-Alias -Name h     -Value helm.exe
Set-Alias -Name jq    -Value ConvertTo-Json
Set-Alias -Name k     -Value kubectl.exe
Set-Alias -Name which -Value Get-Command

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\half-life.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
