#!/bin/sh

SCRIPTDIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPTDIR"
set -e
set -x

mkdir -p build
rm -f build/*
for B in $(cat main.scad | sed -n 's:^.*BUILD[ \t]*== [ \t]*"\([^"]*\)".*$:\1:gp'); do
  echo "---------------------------------------------------------------------------"
  openscad -o "build/$B.stl" main.scad -D"BUILD=\"$B\""
done

