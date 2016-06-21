install_xxd() {
  apt-get update -qq &>/dev/null && apt-get install -yq vim-common &>/dev/null || echo "Could not install test helper: xxd via vim-common.  Tests cannot proceed." | fail
}
