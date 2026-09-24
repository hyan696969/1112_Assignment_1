#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: no argument is provided" 
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then 
    echo "Error: input file not found"
    exit 1
fi

if [[ "$input_file" != *.vsc ]]; then
    echo "Error: input must be a .vsc file" 
    exit 1
fi

output="${input_file%.vsc}.bin"

if [ ! -s "$input_file" ]; then
    echo "Error: input file is empty"
    exit 1
fi

first_line=$(head -n 1 "$input_file")

if [[ "$first_line" != "0" && "$first_line" != "2" ]]; then
    echo "Error: first line must be 0 or 2"
    exit 1
fi