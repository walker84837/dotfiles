#!/usr/bin/pwsh

$fullPath = "$home/.local/state/nvim/logs/lsp.log"

$logFile = [System.IO.Path]::GetFileName($fullPath)
$logFolder = [System.IO.Path]::GetDirectoryName($fullPath)

Clear-Host

if (Test-Path $logFolder) {
	Write-Host "Removing $logFile" -ForegroundColor Red

	Remove-Item -Path $fullPath -ErrorAction SilentlyContinue
}

Write-Host "Re-creating LSP log file ($fullPath)" -ForegroundColor Yellow

New-Item -ItemType "File" -Path $logFolder -Name $logFile

Write-Host "Watching for changes in LSP log file" -ForegroundColor Green

tail -f $fullPath
