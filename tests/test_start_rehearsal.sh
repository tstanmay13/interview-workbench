#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$TEST_DIR/.." && pwd)
. "$TEST_DIR/lib.sh"

TEST_TMP=$(mktemp -d "${TMPDIR:-/tmp}/interview-workbench-rehearsal.XXXXXX")
trap 'rm -rf "$TEST_TMP"' EXIT HUP INT TERM

TARGET="$TEST_TMP/session"
"$ROOT_DIR/bin/start-rehearsal" 90 "$TARGET" >/dev/null

assert_dir "$TARGET/case-service/.git"
assert_dir "$TARGET/review-console/.git"
assert_file "$TARGET/.workbench/challenge.md"
assert_file "$TARGET/.workbench/rehearsal.md"
assert_file "$TARGET/.workbench/scorecard.md"
assert_contains "$TARGET/.workbench/rehearsal.md" '90-minute'
assert_contains "$TARGET/.workbench/challenge.md" 'Failure-safe evidence'

case_status=$(git -C "$TARGET/case-service" status --porcelain)
review_status=$(git -C "$TARGET/review-console" status --porcelain)
[ -z "$case_status" ] || fail "case-service fixture should start clean"
[ -z "$review_status" ] || fail "review-console fixture should start clean"

printf 'ok - rehearsal creates two clean repositories and a timed brief\n'
