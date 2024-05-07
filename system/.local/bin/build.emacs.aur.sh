#!/bin/sh
rm -rf emacs-git
git clone https://aur.archlinux.org/emacs-git.git
cd emacs-git
sed -i 's/^JIT=\(     \)/JIT="YES"/' PKGBUILD
makepkg --syncdeps --install
