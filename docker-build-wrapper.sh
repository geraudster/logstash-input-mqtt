#!/bin/bash
#
# This script lets you build a dockerfile by running as ./Dockerfile
# if you put a "shebang" in the first line of the Dockerfile, eg:
#
#     #!./tools/docker-build-wrapper -t mos
#
# (BTW, this works on Linux, but not on Mac)
#
set -f
DOCKERFILE=${@: -1}
ARGS="${@:1:$#-1}"
exec docker build $ARGS -f $DOCKERFILE .

