#!/bin/bash

if [ $# -eq 0 ]; then
    echo "usage: no argument is provided"
    exit 1
fi

if [ $# -gt 1 ]; then
    echo "usage: more than one arguments are provided"
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "usage: input is not a file or it does not exist"
    exit 1
fi

if [ "$input_file" != *.vsc ]; then
    echo "usage: input does not have the extension .vsc"
    exit 1
fi

output="${input_file%.vsc}.bin"

if [ ! -s "$input_file" ]; then
    echo "usage: the file is empty - no .bin file is produced"
    exit 1
fi

first_line=$(head -n 1 "$input_file")

if [[ "$first_line" != "0" && "$first_line" != "2" ]]; then
    echo "Error: first line must be 0 or 2"
    exit 1
fi