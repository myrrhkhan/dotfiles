#!/bin/zsh

xargs brew install --cask < ./cask-apps.txt
xargs brew install < ./packages.txt
