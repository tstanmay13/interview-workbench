#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

for test_file in "$TEST_DIR"/test_*.sh; do
  printf '%s\n' "==> $(basename "$test_file")"
  sh "$test_file"
done
