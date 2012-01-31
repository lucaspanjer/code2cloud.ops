#!/bin/sh

TOP_DIR="`dirname $0`/.."

if [ "x$1" = "x" ]; then
    echo "Usage: $0 local|tt"
    exit 1
else
    ENV="$1"
fi

if [ ! -d "${TOP_DIR}/roles/${ENV}" ]; then
    echo "'${ENV}' environment does not exist"
    exit 1
fi

echo "Using '${ENV}' environment..."

for path in `ls ${TOP_DIR}/roles/${ENV}/*.rb`
do
    knife role from file $path
done

for path in `ls ${TOP_DIR}/roles/*.rb`
do
    knife role from file $path
done

for path in `ls ${TOP_DIR}/environments/*.rb`
do
    knife environment from file $path
done
