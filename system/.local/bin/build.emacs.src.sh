#!/bin/sh

EMACSGITREPO=~/code/emacs
TAG=emacs-29.3

printf "\n\n... buildin' Emacs time ...\n"

clone_repo() {
    printf "...grabbing a fresh copy of the source. this takes a minute...\n\n"
    git clone https://github.com/mirrors/emacs.git $EMACSGITREPO
    cd $EMACSGITREPO
}

nuke_repo() {
    cd $HOME
    printf "...nuking  %s...\n\n" $EMACSGITREPO
    sudo rm -rf $EMACSGITREPO
}

pull_latest() {
    printf "...okay, but lemme tidy up this mess first...\n\n"
    cd $EMACSGITREPO
    make clean
    printf "...pulling some fresh source code...\n\n"
    git pull
}

build_emacs() {
	printf "...checking out tag %s...\n\n" $TAG
	git checkout $TAG
    printf "...starting the build...\n\n"
    cd $EMACSGITREPO
    $EMACSGITREPO/autogen.sh
    $EMACSGITREPO/configure --with-x-toolkit=lucid  \
                --with-modules \
                --with-xwidgets \
                --with-treesitter \
                --with-mailutils \
                --with-libsystemd \
                --with-imagemagick  \
                --with-xml2 \
                --with-libsystemd \
                -with-gif --with-jpeg --with-png --with-tiff \
                CFLAGS='-O2 -march=native'
    make -j$(nproc)
}

if [ -d "$EMACSGITREPO" ]; then
    printf "\n...one sec. an Emacs repository exists at %s already. Shall I first...\n" $EMACSGITREPO
    printf "(r)efresh the existing repository with any latest commits, or\n"
    printf "(c)lobber what's there and grab a fresh copy of the source, or \n"
    printf "(b)uild what's there?\n\n"
    read -p "Your choice: (r/c/s): " answer
    printf "\n\n"
    case ${answer:0:1} in
        c|C )
            nuke_repo
            clone_repo
            ;;
        r|R)
            pull_latest
            ;;
        b|B)
            printf "...ok, just buildin'...\n\n"
            ;;
        * )
            printf "wake up. you didn't choose a valid option. enjoy your day.\n\n"
            exit 1
            ;;
    esac
else
    printf "...everything checks out, so let's get this rolling....\n"
    clone_repo
fi

build_emacs
