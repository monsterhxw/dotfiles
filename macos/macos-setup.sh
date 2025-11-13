#!/usr/bin/env bash

# Keyboard #
# -Refs: 
#   https://linkarzu.com/posts/2024-macos-workflow/macos-keyrepeat-rate
#   https://github.com/tshu-w/dotfiles/blob/main/darwin/macOS.sh#L132-L134
#   https://gist.github.com/hofmannsven/ff21749b0e6afc50da458bebbd9989c5
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
