#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: expected one .vsc file as argument"
    exit 1
fi

input=$1

if [ ! -f "input_file"]; then 
    echo "Error: input file not found" >&2
    exit 1
fi

if [[ "$input" != *.vsc ]]; then
    echo "Error: input must be a .vsc file" >&2
    exit 1
fi

output="${input_file%.vsc}.bin"