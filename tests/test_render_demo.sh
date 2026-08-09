#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$TEST_DIR/.." && pwd)
. "$TEST_DIR/lib.sh"

TEST_TMP=$(mktemp -d "${TMPDIR:-/tmp}/interview-workbench-render.XXXXXX")
trap 'rm -rf "$TEST_TMP"' EXIT HUP INT TERM

SOURCE="$TEST_TMP/demo.md"
OUTPUT="$TEST_TMP/demo.html"

printf '%s\n' \
  '# Case routing demo' \
  '' \
  '> Thesis: uncertain cases reach a human with their evidence intact.' \
  '' \
  '## Verification' \
  '' \
  '| Claim | Status | Evidence |' \
  '|---|---|---|' \
  '| Normal case routes | PASS | `node --test` |' \
  '| Boundary behavior | PARTIAL | One fixture |' \
  '' \
  '## Failure case' \
  '' \
  '- Missing evidence is marked **UNVERIFIED**.' \
  > "$SOURCE"

"$ROOT_DIR/bin/render-demo" "$SOURCE" "$OUTPUT" >/dev/null

assert_file "$OUTPUT"
assert_contains "$OUTPUT" '<!doctype html>'
assert_contains "$OUTPUT" 'Case routing demo'
assert_contains "$OUTPUT" 'data-status="pass"'
assert_contains "$OUTPUT" 'data-status="partial"'
assert_contains "$OUTPUT" 'window.print()'
assert_contains "$OUTPUT" "event.key.toLowerCase() === 'p'"
assert_not_contains "$OUTPUT" 'src="http'
assert_not_contains "$OUTPUT" 'href="http'

printf 'ok - renderer produces self-contained evidence view\n'
