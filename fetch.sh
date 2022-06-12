#!/bin/sh
#
# Copy script(s) from my iCloud Scripts folder to here
# Decompile any


ICLOUD="$HOME/Library/Mobile Documents"
SCRIPTS_DIR="$ICLOUD/com~apple~ScriptEditor2/Documents"
PROJ_DIR="$SCRIPTS_DIR/NotesPort"

mkdir -p ScriptEditor
test -d "$PROJ_DIR" && rsync  "$PROJ_DIR/"*.* ScriptEditor

cd ScriptEditor
for f in *.scpt ; do
    osadecompile "$f" > "${f%%scpt}applescript"
done
