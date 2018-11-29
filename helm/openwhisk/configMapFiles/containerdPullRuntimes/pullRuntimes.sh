#!/bin/bash
# This script parses the runtime manifest json and pulls all runtime images via wskc
pos=0
name=""
prefix=""
tag=""
# sort keys to ensure that parsing is independent of json key order
echo ${RUNTIMES_MANIFEST} | jq -S ".runtimes[][].image" | jq -r ".[]" | while read line
do
    if [ $pos -eq 0 ]; then
        name=${line}
        pos=$((pos+1))
    elif [ $pos -eq 1 ]; then
        prefix=${line}
        pos=$((pos+1))
    elif [ $pos -eq 2 ]; then
        tag=${line}
        echo "pulling ${RUNTIMES_REGISTRY}${prefix}/${name}:${tag}"
        wskc -n wsk pull "${RUNTIMES_REGISTRY}${prefix}/${name}:${tag}"
        name=""
        prefix=""
        tag=""
        pos=0
    fi
done