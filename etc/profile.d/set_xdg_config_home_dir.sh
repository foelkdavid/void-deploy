#!/bin/bash

# Set XDG_CONFIG_HOME if it's not already set
if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME=$HOME/.config
    mkdir -p "$XDG_CONFIG_HOME"
fi
