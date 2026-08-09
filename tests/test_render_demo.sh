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
assert_not_contains "$OUTPUT" 'src="http'
assert_not_contains "$OUTPUT" 'href="http'

RUNTIME="$TEST_TMP/runtime.js"
sed -n '/^  <script>$/,/^  <\/script>$/p' "$OUTPUT" | sed '1d;$d' > "$RUNTIME"
node --input-type=commonjs - "$RUNTIME" "$SOURCE" <<'NODE'
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const runtime = fs.readFileSync(process.argv[2], 'utf8');
const context = {};
vm.runInNewContext(`${runtime}\nglobalThis.__parser = DemoParser;`, context);
const parser = context.__parser;

assert.equal(
  parser.inline('[proof](tests/test_failure_path.md)'),
  '<a href="tests/test_failure_path.md" rel="noreferrer">proof</a>',
);
assert.match(parser.inline('[report](https://example.test/PASS/report)'), /href="https:\/\/example\.test\/PASS\/report"/);
assert.doesNotMatch(parser.inline('[unsafe]( javascript:alert(1))'), /<a\b/);
assert.doesNotMatch(parser.inline('[unsafe](java\tscript:alert(1))'), /<a\b/);
assert.match(parser.renderMermaidFlow(['flowchart LR', 'Input --> Decision --> Outcome']), /class="flow-diagram"/);
assert.equal(parser.renderMermaidFlow(['flowchart LR', 'A -->|approved| B']), null);

class Element {
  constructor() {
    this.children = [];
    this.classList = { add() {}, toggle() {} };
    this.dataset = {};
    this.id = '';
    this.innerHTML = '';
  }
  addEventListener() {}
  append(child) { this.children.push(child); }
  querySelectorAll(selector) {
    if (selector === '.section') return this.children.filter((child) => child.className === 'section');
    if (selector === 'a') return this.children;
    return [];
  }
  scrollIntoView() {}
}

const sourceElement = new Element();
sourceElement.value = fs.readFileSync(process.argv[3], 'utf8');
const deck = new Element();
const trace = new Element();
const button = new Element();
const documentMock = {
  addEventListener() {},
  createElement() { return new Element(); },
  querySelector(selector) {
    if (selector === '#source') return sourceElement;
    if (selector === '#deck') return deck;
    if (selector === '#trace') return trace;
    return button;
  },
  title: '',
};
const browserContext = {
  document: documentMock,
  window: { print() {} },
  IntersectionObserver: class { observe() {} },
};
vm.runInNewContext(runtime, browserContext);
assert.ok(deck.children.length >= 3, 'runtime should create the hero and sections');
assert.ok(deck.children.some((child) => child.innerHTML.includes('flow-diagram')), 'runtime should use the flow renderer');
NODE

SOURCE_BEFORE=$(cksum "$SOURCE")
if "$ROOT_DIR/bin/render-demo" "$SOURCE" "$SOURCE" >/dev/null 2>&1; then
  fail 'renderer must reject an output path that is the Markdown source'
fi
[ "$(cksum "$SOURCE")" = "$SOURCE_BEFORE" ] || fail 'renderer changed its source file'

printf 'ok - renderer produces self-contained evidence view\n'
