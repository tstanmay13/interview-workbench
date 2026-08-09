#!/bin/sh

set -eu

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file: $1"
}

assert_dir() {
  [ -d "$1" ] || fail "expected directory: $1"
}

assert_contains() {
  file=$1
  value=$2
  grep -F "$value" "$file" >/dev/null 2>&1 || fail "expected '$value' in $file"
}

assert_not_contains() {
  file=$1
  value=$2
  if grep -F "$value" "$file" >/dev/null 2>&1; then
    fail "did not expect '$value' in $file"
  fi
}
