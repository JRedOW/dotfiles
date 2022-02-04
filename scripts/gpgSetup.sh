#!/usr/bin/env bash

[[ ! -z $GNUPG_KEY  ]] &&

[[ ! -z $GNUPG_KEYID  ]] &&

gpg --verbose --batch --import <(echo $GNUPG_KEY|base64 -d) &&

echo 'pinentry-mode loopback' >> ~/.gnupg/gpg.conf  &&

git config --global user.signingkey $GNUPG_KEYID &&

git config --global commit.gpgsign true
