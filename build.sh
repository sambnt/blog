#!/usr/bin/env bash
# Use -Q flag to ensure we don't load our own configuration
mkdir -p public
emacs -Q --script build-site.el
