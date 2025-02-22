#!/bin/bash

scversion='v0.10.0'
          
wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
cp "shellcheck-${scversion}/shellcheck" /usr/local/bin
rm -rf "shellcheck-${scversion}"
shellcheck --version