# Bats tests for default/ dir contents

load test-helper
fixtures 'default'

@test "installing shellcheck test dependency works" {
  run install_test_dependency shellcheck
  [ "$status" -eq 0 ]
  run which shellcheck
  [ "$status" -eq 0 ]
  [[ $output =~ .*\/bin\/shellcheck ]]
}


@test "each /etc/default/* file must be valid bash syntax" {
  for f in $(ls -1 ${TEST_FIXTURE_ROOT}/default/*); do
    local error_message="File: '$f' did not pass 'bash -n' syntax check"

    run bash -n $f
    assert_success                            || fail $error_message
    refute_line --regexp 'line [[:digit:]]+:' || fail $error_message
    refute_line --regexp 'error'              || fail $error_message
  done
}

@test "each /etc/default/* file must pass shellcheck tests" {
  for f in $(ls -1 ${TEST_FIXTURE_ROOT}/default/*); do
    local error_message="File: '$f' did not pass 'shellcheck --shell=bash --exclude=SC1014,SC2148' tests"

    run shellcheck --shell=bash --exclude=SC1014,SC2148 $f
    [ "$status" -eq 0 ]                    || fail $error_message
    [[ ! $output =~ .*SC[[:digit:]]+:.* ]] || fail $error_message
    [[ ! $output =~ .*In.*line.* ]]        || fail $error_message
  done
}
