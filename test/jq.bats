# Bats tests for json/ dir contents

load test-helper
fixtures 'json'

@test "installing xxd test dependency works" {
  run install_test_dependency jq
  [ "$status" -eq 0 ]
  run which jq
  [ "$status" -eq 0 ]
  [[ $output =~ .*\/bin\/jq ]]
}

@test "json has expected description" {
  local f=${TEST_FIXTURE_ROOT}/jq.json
  run jq '.description' < $f
  [ $status -eq 0 ] || fail "command failed: jq '.description' < $f"
  [[ ${lines[0]} == '"Command-line JSON processor"' ]] || fail "File: '$f' did not match expected output"
}
