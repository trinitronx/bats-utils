# bats-utils - Common test utilities for Bats
#
# Written in 2016 by James Cuzella <james dot cuzella at lyraphase dot com>

#
# dependencies.bash
# -----------
#
# A simple bootstrap function to load test dependencies using recipes
# under src/*.bash
#

# Attempt to load dependency install helper functions, then execute them
# if the target dependency command is not found in $PATH
#
# Globals:
#   none
# Arguments:
#   $1 - dependency
# Returns:
#   0 - install was successful
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure

install_test_dependency() {
  local dep=$1
  local bats_lib_file="$(dirname "${BASH_SOURCE[0]}")/${dep}.bash"
  if [ -f "$bats_lib_file" ]; then
    source "$bats_lib_file"
  else
    fail "Could not load $bats_lib_file"
  fi
  
  which $dep  &>/dev/null || install_$dep
}

