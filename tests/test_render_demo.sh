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
  '| [Normal case routes](tests/happy-path.test.js) | PASS | `node --test` |' \
  '| [Failure proof](tests/test_failure_path.md) | PASS | [report](https://example.test/PASS/report) |' \
  '| Boundary behavior | PARTIAL | One fixture |' \
  '' \
  '## Failure case' \
  '' \
  '- Missing evidence is marked **UNVERIFIED**.' \
  '' \
  '```mermaid' \
  'flowchart LR' \
  '  Input --> Decision --> Outcome' \
  '```' \
  > "$SOURCE"

"$ROOT_DIR/bin/render-demo" "$SOURCE" "$OUTPUT" >/dev/null

assert_file "$OUTPUT"
assert_contains "$OUTPUT" '<!doctype html>'
assert_contains "$OUTPUT" 'Case routing demo'
assert_contains "$OUTPUT" 'data-status="pass"'
assert_contains "$OUTPUT" 'data-status="partial"'
assert_contains "$OUTPUT" 'window.print()'
assert_contains "$OUTPUT" "event.key.toLowerCase() === 'p'"
assert_contains "$OUTPUT" "const allowed = !/^[a-z][a-z0-9+.-]*:/i.test(url)"
assert_contains "$OUTPUT" 'const tokenFor = (html) =>'
assert_contains "$OUTPUT" 'const renderMermaidFlow = (lines) =>'
assert_not_contains "$OUTPUT" 'src="http'
assert_not_contains "$OUTPUT" 'href="http'

SOURCE_BEFORE=$(cksum "$SOURCE")
if "$ROOT_DIR/bin/render-demo" "$SOURCE" "$SOURCE" >/dev/null 2>&1; then
  fail 'renderer must reject an output path that is the Markdown source'
fi
[ "$(cksum "$SOURCE")" = "$SOURCE_BEFORE" ] || fail 'renderer changed its source file'

printf 'ok - renderer produces self-contained evidence view\n'
