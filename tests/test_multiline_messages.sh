#!/usr/bin/env bash
#
# Purpose:
# Test how the demo performs when a commit is made with \ and newlines.

# Load utilities.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/util.sh

# Create git history
set -e
cd $src
git init
git add .
git commit -am 'Oh no!\

This spans multiple lines.
Can our script handle it?

There should be a skipped above and after this line.

This also includes a bad \ character at the very end.

The End!\'
git log

# Build the project
set -e
cd $build
cmake -G "$TEST_GENERATOR" $src
cmake --build . --target demo

# Run the demo.
# It should report EXIT_SUCCESS because git history was found.
set +e
./demo &> output.txt
assert "$? -eq 0" $LINENO

if ! grep -q 'The End!\\' output.txt; then
    echo "Dropped the last line"
    assert "1 -eq 0" $LINENO
fi

