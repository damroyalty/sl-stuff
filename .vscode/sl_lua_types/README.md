SL Lua Types (workspace copy)

This folder is used to store the SL Luau type definitions and related files downloaded from the `sl_lua_types` release.

How to update:
1. In VS Code: Run the Task `Update SL Lua Types` (Command Palette → Tasks: Run Task → Update SL Lua Types). This runs `.vscode/scripts/update_sl_lua_types.ps1` and downloads the latest release assets into this folder.
2. After the download completes, reload the window (Developer: Reload Window).
3. The workspace settings already point `luau-lsp` to use the downloaded files:
   - `luau-lsp.types.definitionFiles` → `.vscode/sl_lua_types/ll.d.luau`
   - `luau-lsp.types.documentationFiles` → `.vscode/sl_lua_types/ll.d.json`

If you prefer a global install, download the release and set the same paths in your user settings instead of workspace settings.

Troubleshooting:
- If the Luau LSP fails to attach or you still see folding errors for `.slua` files, reload the window and ensure the file association for `*.slua` is set to `luau` (bottom-right of VS Code). You can also run the `SL External Editor: Update LSP Defs` command if you use that extension.