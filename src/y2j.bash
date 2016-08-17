install_y2j() {
  docker run --rm trinitronx/y2j:develop y2j.sh installer /usr/local/bin | bash &>/dev/null || fail "Could not install test helper: y2j via docker bash script install method.  Tests cannot proceed."
}
