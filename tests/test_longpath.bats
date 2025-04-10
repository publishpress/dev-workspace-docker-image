#!/usr/bin/env bats

setup() {
  # Create test directory structure before each test
  TEST_DIR="/tmp/test_longpath_structure"

  # Clean up any existing test directory
  rm -rf "$TEST_DIR"
  mkdir -p "$TEST_DIR"

  # Create files with different path lengths
  touch "$TEST_DIR/short.txt"

  # Create nested directories for long paths
  mkdir -p "$TEST_DIR/nested/directories/create/longer/paths"
  touch "$TEST_DIR/nested/directories/create/longer/paths/deep_file.txt"
  touch "$TEST_DIR/nested/directories/create/longer/paths/another_very_long_filename_to_test_path_length_calculations.txt"

  # Create directories that should be skipped
  mkdir -p "$TEST_DIR/test/subdir"
  touch "$TEST_DIR/test/should_be_skipped.txt"

  mkdir -p "$TEST_DIR/dist"
  touch "$TEST_DIR/dist/skip_this_too.txt"

  mkdir -p "$TEST_DIR/dev-workspace"
  touch "$TEST_DIR/dev-workspace/another_skipped.txt"

  mkdir -p "$TEST_DIR/node_modules/package"
  touch "$TEST_DIR/node_modules/package/should_be_ignored.txt"
}

teardown() {
  # Clean up after tests
  rm -rf "/tmp/test_longpath_structure"
}

@test "longpath script exists and is executable" {
  [ -x "/scripts/longpath" ]
}

@test "longpath shows help message with -h flag" {
  run php /scripts/longpath -h
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Usage: longpath DIRECTORY [NUMBER_OF_PATHS]" ]]
}

@test "longpath detects longest path" {
  run php /scripts/longpath "$TEST_DIR"
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == *"another_very_long_filename_to_test_path_length_calculations.txt"* ]]
}

@test "longpath respects custom number of results" {
  run php /scripts/longpath "$TEST_DIR" 3
  [ "$status" -eq 0 ]

  # Count the number of "Length:" lines
  count=0
  for line in "${lines[@]}"; do
    if [[ "$line" == "Length:"* ]]; then
      count=$((count + 1))
    fi
  done

  [ "$count" -eq 3 ]
}

@test "longpath ignores specified directories" {
  run php /scripts/longpath "$TEST_DIR"
  [ "$status" -eq 0 ]

  # Check that none of the output lines contain paths from ignored directories
  for line in "${lines[@]}"; do
    [[ "$line" != *"/test/"* ]]
    [[ "$line" != *"/dist/"* ]]
    [[ "$line" != *"/dev-workspace/"* ]]
    [[ "$line" != *"/node_modules/"* ]]
  done
}
