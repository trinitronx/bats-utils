install_shellcheck() {
  if [[ $OSTYPE = *darwin* ]]; then
    if which brew &>/dev/null; then
      brew install shellcheck &>/dev/null || fail "Could not install test helper: shellcheck via homebrew.  Tests cannot proceed."
    elif which port &>/dev/null; then
      port install shellcheck &>/dev/null || fail "Could not install test helper: shellcheck via MacPorts.  Tests cannot proceed."
    fi
  else
    apt-get update -qq &>/dev/null && apt-get install -yq shellcheck &>/dev/null || fail "Could not install test helper: shellcheck via apt-get.  Tests cannot proceed."
  fi
}
