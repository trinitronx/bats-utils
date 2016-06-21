# Bats tests for yaml/ dir contents

load test-helper
fixtures 'yaml'

@test "installing y2j test dependency works" {
  run install_test_dependency y2j
  [ "$status" -eq 0 ]
  run which y2j
  [ "$status" -eq 0 ]
  [[ $output =~ .*\/bin\/y2j ]]
}

@test "yaml has expected first item" {
  local f=${TEST_FIXTURE_ROOT}/booleans.yaml
  run yq '.[0]' < $f
  [ $status -eq 0 ] || fail "command failed: run yq '.[0]' < $f"
  [[ ${lines[0]} == 'true' ]] || fail "File: '$f' did not match expected output"
}
