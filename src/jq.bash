install_jq() {
  if [[ $OSTYPE = *darwin* ]]; then
    if which brew &>/dev/null; then
      brew install jq
    else
      mkdir -p /tmp/install-jq
      
      ## Install jq + dependencies from source
      # Install Dependencies (Bison 3)
      cd /tmp
      wget http://ftp.gnu.org/gnu/bison/bison-3.0.3.tar.gz
      tar -xvzf bison-3.0.3.tar.gz
      cd bison-3.0.3
      sudo port install m4
      ./configure --prefix=/usr/local/bison
      sudo make install || fail "Could not install test helper dependency: jq -> bison via install from source method.  Tests cannot proceed."
      sudo ln -s /usr/local/bison/bin/bison /usr/bin/bison
      
      # Install Dependencies (Oniguruma)
      cd /tmp/install-jq
      wget https://web.archive.org/web/20150803013327/http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.6.tar.gz
      tar -xf onig-5.9.6.tar.gz
      cd onig-5.9.6
      ./configure
      make
      sudo make install || fail "Could not install test helper dependency: jq -> oniguruma via install from source method.  Tests cannot proceed."

      # Build jq
      cd /tmp/install-jq/
      git clone https://github.com/stedolan/jq.git
      cd ./jq
      
      autoreconf -i
      ./configure
      make -j8
      sudo make install || fail "Could not install test helper: jq via install from source method.  Tests cannot proceed."
    fi
  else
    apt-get update -qq &>/dev/null && apt-get install -yq jq &>/dev/null || fail "Could not install test helper: jq via apt-get.  Tests cannot proceed."
  fi
}
