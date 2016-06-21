# bats-file

[![GitHub license](https://img.shields.io/github/license/trinitronx/bats-utils.svg?maxAge=2592000)](https://raw.githubusercontent.com/trinitronx/bats-utils/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/ztombol/bats-file.svg)](https://github.com/trinitronx/bats-utils/releases/latest)
[![Build Status](https://travis-ci.org/trinitronx/bats-utils.svg?branch=master)](https://travis-ci.org/trinitronx/bats-utils)

`bats-utils` is a helper library providing common test dependencies
and a function to bootstrap them into [Bats][bats].

The test dependency bootstrap function installs the utility passed using
a recipe found under `src/`.  If an error occurs during install, 
they return 1 on failure and 0 otherwise. 
Output, [formatted][bats-support-output] for readability, is sent
to standard error to make the `install_test_dependency` function 
usable outside of `@test` blocks too.

Dependencies:
- [`bats-support`][bats-support] - output formatting

See the [shared documentation][bats-docs] to learn how to install and
load this library.


## Usage

### `install_test_dependency`

Try to load the test dependency library and execute a function named `install_$dep`.
If a problem installing occurs, output an error and fail.  If installation succeeds,
the utility may be used in subsequent tests.  If the utility already exists, silently
continue.

For included test dependency install recipes, see the `src/` directory.

### Helper Utilities

#### `shellcheck`

**Installs:**

 - [`shellcheck`][koalaman-shellcheck], a static analysis tool for shell scripts http://www.shellcheck.net

```bash
@test '/etc/default files must pass shellcheck tests' {
  install_test_dependency shellcheck
  for f in /etc/default/*; do
    local error_message="File: '$f' did not pass 'shellcheck --shell=bash --exclude=SC1014,SC2148' tests"

    run shellcheck --shell=bash --exclude=SC1014,SC2148 $f
    assert_success                         || fail $error_message
    refute_line --regexp 'SC[[:digit:]]+:' || fail $error_message
    refute_line --regexp 'In.*line'        || fail $error_message
  done
}
```

On failure, the `error_message` is displayed.

```
     `assert_success                         || fail $error_message' failed

   -- command failed --
   status : 1
   output (11 lines):

     In default/foo line 1:
     if [ "$foo" ]
     ^-- SC1049: Did you forget the 'then' for this 'if'?
     ^-- SC1073: Couldn't parse this if expression.


     In default/foo line 2:
     fi
     ^-- SC1050: Expected 'then'.
       ^-- SC1072: Unexpected keyword/token. Fix any mentioned problems and try again.
   --

   File: 'default/foo' did not pass 'shellcheck --shell=bash --exclude=SC1014,SC2148' tests
```


#### `jq`

**Installs:**

 - [`jq`][stedolan-jq], Command-line JSON processor http://stedolan.github.io/jq/

```bash
setup() {
  install_test_dependency jq
}

@test "stedolan/jq should have a description" {
  run bash -c "curl -s 'https://api.github.com/repos/stedolan/jq' | jq '.description'"
  assert_output '"Command-line JSON processor"'
}
```

On failure, the differing output would be displayed.

```
     `assert_output '"Command-line JSON processor"'' failed

   -- output differs --
   expected : "Command-line JSON processor"
   actual   : "pythonic filesystem library"
   --
```

#### `y2j`

**Installs:**

 - [`y2j`][wildducktheories-y2j], A command line tool for converting between YAML and JSON and vice versa.

```bash
setup() {
  install_test_dependency y2j
}

@test "First of list should be true" {
  run bash -c "curl -s 'https://raw.githubusercontent.com/yaml/yaml-node-js/master/tests/booleans.yaml' | y2j | jq '.[0]'"
  assert_output 'true'
}
```

On failure, the differing output would be displayed.

```
     `assert_output 'true'' failed

   -- output differs --
   expected : true
   actual   : false
   --
```

#### `xxd`

**Installs:**

 - [`xxd`][vim-xxd], Utility to make a hexdump or do the reverse. http://vim.wikia.com/wiki/Hex_dump

```bash
setup() {
  install_test_dependency xxd
}

@test "/etc/cron.d files end in newline" {
  for f in /etc/cron.d/*; do
    run xxd $f
    assert [ $status -eq 0 ] || fail "command failed: xxd $f"
    let "last_line = ${#lines[@]} - 1" || true
    let "last_line < 0 ? last_line = 0 : noop" || true
    assert_line --index $last_line --regexp '0a[[:space:]]*.' || fail "File: '$f' did not end in newline"
  done
}
```

On failure, the differing output would be displayed.

```
`assert_line --index $last_line --regexp '0a[[:space:]]*.' || fail "File: '$f' did not end in newline"' failed

-- regular expression does not match line --
index  : 0
regexp : 0a[[:space:]]*.
line   :
--

File: '/etc/cron.d/derp' did not end in newline
```



<!-- REFERENCES -->

[bats]: https://github.com/sstephenson/bats
[bats-support-output]: https://github.com/ztombol/bats-support#output-formatting
[bats-support]: https://github.com/ztombol/bats-support
[bats-docs]: https://github.com/ztombol/bats-docs
[koalaman-shellcheck]: https://github.com/koalaman/shellcheck
[stedolan-jq]: https://github.com/stedolan/jq
[wildducktheories-y2j]: https://github.com/wildducktheories/y2j
[vim-xxd]: http://linux.die.net/man/1/xxd
