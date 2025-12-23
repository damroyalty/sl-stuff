Run LSLint (safe)

This workspace includes a helper script to run LSLint on files that may contain non-ASCII characters in the filename.

Files added:

- `.vscode/lslint-run.ps1` - copies the target file to a sanitized temporary filename and runs `lslint` on the copy, then deletes it.
- `.vscode/tasks.json` - adds a task labeled `Run LSLint (safe)`. Use `Terminal > Run Task...` and pick the task.

How to run:

- Open the LSL file in the editor (even if it has emoji in the filename).
- Press Ctrl+Shift+P, type `Tasks: Run Task`, select `Run LSLint (safe)`.

Notes:

- The helper looks for `lslint` on the PATH. You already have it added to your User PATH.
- If you want, I can add a problem matcher to parse linter output into Problems; tell me if you'd like that next.
