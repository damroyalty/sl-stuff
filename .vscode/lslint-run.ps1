param(
    [Parameter(Mandatory=$true)][string]$File,
    [string]$LslintArgs = ""
)

# Resolve and validate
if (-not (Test-Path -LiteralPath $File)) {
    Write-Error "File not found: $File"
    exit 2
}

$exe = (Get-Command lslint -ErrorAction SilentlyContinue).Source
if (-not $exe) {
    # Compute script root reliably (PSScriptRoot not always set in older PowerShell versions)
    $scriptRoot = $PSScriptRoot
    if (-not $scriptRoot) { $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition }
    $scriptRoot = [string]$scriptRoot

    # Try common workspace-local locations for lslint (e.g. bundled in repo)
    $candidates = @(
        [System.IO.Path]::GetFullPath("$scriptRoot\..\lslint_v1.2.7_win64\lslint.exe"),
        [System.IO.Path]::GetFullPath("$scriptRoot\..\lslint.exe"),
        [System.IO.Path]::GetFullPath("$scriptRoot\..\bin\lslint.exe")
    )
    foreach ($full in $candidates) {
        if (Test-Path -LiteralPath $full) {
            $exe = $full
            break
        }
    }
    if (-not $exe) {
        Write-Error "lslint not found in PATH or workspace. Make sure lslint is installed or placed in the repository (e.g. ./lslint_v1.2.7_win64/lslint.exe)."
        exit 3
    }
}

# Create a safe ASCII filename for the temp copy
$base = [System.IO.Path]::GetFileNameWithoutExtension($File)
$ext  = [System.IO.Path]::GetExtension($File)
# Replace non-printable/non-ascii characters with underscore
$sanitizedBase = ($base -replace '[^\u0020-\u007E]', '_')
$tempFile = Join-Path $env:TEMP ($sanitizedBase + '-' + [System.Guid]::NewGuid().ToString() + $ext)

try {
    Copy-Item -LiteralPath $File -Destination $tempFile -Force -ErrorAction Stop
    Write-Host "Copied to temp file: $tempFile"

    # Run lslint on the temp file and preserve its exit code
    & "$exe" $LslintArgs $tempFile
    $exit = $LASTEXITCODE
} catch {
    Write-Error $_.Exception.Message
    $exit = 4
} finally {
    # Clean up the temp file (best-effort)
    if (Test-Path -LiteralPath $tempFile) {
        Remove-Item -LiteralPath $tempFile -Force -ErrorAction SilentlyContinue
    }
}
exit $exit
