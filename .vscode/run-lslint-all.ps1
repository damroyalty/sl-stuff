# Run lslint on all tracked .lsl files
$files = git ls-files '*.lsl' 2>$null
if (-not $files) { Write-Host 'No .lsl files found'; exit 0 }
$files | ForEach-Object { Write-Host '--- Lint:' $_; & ./.vscode/lslint-run.ps1 $_ }
