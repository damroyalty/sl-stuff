# Downloads SL Lua Types release assets into .vscode/sl_lua_types
$dest = Join-Path -Path $PSScriptRoot -ChildPath "..\sl_lua_types" | Resolve-Path -Relative
$dest = (Resolve-Path -Path (Join-Path $PSScriptRoot '..\sl_lua_types')).Path
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }

$assets = @(
    'https://github.com/WolfGangS/sl_lua_types/releases/download/v0.8.7/ll.d.luau',
    'https://github.com/WolfGangS/sl_lua_types/releases/download/v0.8.7/ll.d.json',
    'https://github.com/WolfGangS/sl_lua_types/releases/download/v0.8.7/slua.code-snippets',
    'https://github.com/WolfGangS/sl_lua_types/releases/download/v0.8.7/selene.toml',
    'https://github.com/WolfGangS/sl_lua_types/releases/download/v0.8.7/sl_selene_defs.yml'
)

foreach ($url in $assets) {
    $file = Split-Path $url -Leaf
    $out = Join-Path $dest $file
    Write-Host "Downloading $file to $out"
    try {
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Warning "Failed to download $url : $_"
    }
}

# If we downloaded slua.code-snippets, copy it into the workspace .vscode as a snippet file
$snipSrc = Join-Path $dest 'slua.code-snippets'
$snipDest = Join-Path $PSScriptRoot '..\slua.code-snippets' | Resolve-Path -Relative
$snipDest = (Resolve-Path -Path (Join-Path $PSScriptRoot '..\slua.code-snippets')).Path
if (Test-Path $snipSrc) {
    Copy-Item -Path $snipSrc -Destination $snipDest -Force
    Write-Host "Copied slua.code-snippets to $snipDest"
}

Write-Host "Done. Restart VS Code or reload window and then run the 'Update SL Lua Types' task if needed."