# Bats tests for cron/ dir contents

load test-helper
fixtures 'cron'

@test "installing xxd test dependency works" {
  run install_test_dependency xxd
  [ "$status" -eq 0 ]
  run which xxd
  [ "$status" -eq 0 ]
  [[ $output =~ .*\/bin\/xxd ]]
}

@test "cron.d files end in newline" {
  for f in $(ls -1 ${TEST_FIXTURE_ROOT}/cron/*); do
    run xxd $f
    [ $status -eq 0 ] || fail "command failed: xxd $f"
    let "last_line = ${#lines[@]} - 1" || true
    let "last_line < 0 ? last_line = 0 : noop" || true
    [[ ${lines[-1]} =~ 0a[[:space:]]*. ]] || fail "File: '$f' did not end in newline"
  done
}
