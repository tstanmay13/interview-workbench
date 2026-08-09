#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$TEST_DIR/.." && pwd)
. "$TEST_DIR/lib.sh"

command -v node >/dev/null 2>&1 || fail "node is required for rehearsal fixture tests"

TEST_TMP=$(mktemp -d "${TMPDIR:-/tmp}/interview-workbench-http.XXXXXX")
SERVICE_LOG="$TEST_TMP/service.log"
REVIEW_LOG="$TEST_TMP/reviewer.log"
SERVICE_PID=''
REVIEW_PID=''

cleanup() {
  [ -z "$SERVICE_PID" ] || kill "$SERVICE_PID" 2>/dev/null || true
  [ -z "$REVIEW_PID" ] || kill "$REVIEW_PID" 2>/dev/null || true
  rm -rf "$TEST_TMP"
}
trap cleanup EXIT HUP INT TERM

PORT=18787 node "$ROOT_DIR/rehearsal/fixture/case-service/server.mjs" >"$SERVICE_LOG" 2>&1 &
SERVICE_PID=$!
PORT=18788 node "$ROOT_DIR/rehearsal/fixture/review-console/server.mjs" >"$REVIEW_LOG" 2>&1 &
REVIEW_PID=$!

node --input-type=module - <<'NODE'
const waitFor = async (url) => {
  for (let attempt = 0; attempt < 30; attempt += 1) {
    try {
      const response = await fetch(url);
      if (response.ok) return response;
    } catch {}
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  throw new Error(`server did not become ready: ${url}`);
};

await waitFor('http://127.0.0.1:18787/health');
const response = await fetch('http://127.0.0.1:18787/evaluate', {
  method: 'POST',
  headers: { 'content-type': 'application/json' },
  body: JSON.stringify({
    caseId: 'CASE-101',
    requestedAmount: 2400,
    evidence: ['invoice', 'manager-approval']
  })
});
const result = await response.json();
if (!response.ok) throw new Error(`evaluation failed: ${JSON.stringify(result)}`);
if (result.status !== 'auto-approved') {
  throw new Error(`unexpected status: ${JSON.stringify(result)}`);
}
if (!Array.isArray(result.citations) || result.citations.length === 0) {
  throw new Error(`missing citations: ${JSON.stringify(result)}`);
}

const reviewer = await waitFor('http://127.0.0.1:18788/');
const html = await reviewer.text();
if (!html.includes('Casework review')) throw new Error('reviewer page missing title');
NODE

printf 'ok - rehearsal services expose their public HTTP behavior\n'
