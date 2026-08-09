#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$TEST_DIR/.." && pwd)
. "$TEST_DIR/lib.sh"

TEST_TMP=$(mktemp -d "${TMPDIR:-/tmp}/interview-workbench-bootstrap.XXXXXX")
trap 'rm -rf "$TEST_TMP"' EXIT HUP INT TERM

WORKSPACE="$TEST_TMP/workspace"
mkdir -p "$WORKSPACE"
git -C "$WORKSPACE" init -q
printf 'team-owned instructions\n' > "$WORKSPACE/AGENTS.md"

"$ROOT_DIR/bin/bootstrap" "$WORKSPACE" >/dev/null

assert_dir "$WORKSPACE/.workbench/artifacts"
assert_dir "$WORKSPACE/.workbench/prompts"
assert_file "$WORKSPACE/.workbench/OPERATING-BRIEF.md"
assert_file "$WORKSPACE/.workbench/START-HERE.md"
assert_file "$WORKSPACE/.workbench/notebook.md"
assert_file "$WORKSPACE/.workbench/demo.md"
assert_contains "$WORKSPACE/AGENTS.md" "team-owned instructions"

git -C "$WORKSPACE" check-ignore -q .workbench/notebook.md || \
  fail ".workbench should be locally excluded"

printf '\nUSER_MARKER\n' >> "$WORKSPACE/.workbench/notebook.md"
"$ROOT_DIR/bin/bootstrap" "$WORKSPACE" >/dev/null
assert_contains "$WORKSPACE/.workbench/notebook.md" "USER_MARKER"

printf 'ok - bootstrap is safe and idempotent\n'
