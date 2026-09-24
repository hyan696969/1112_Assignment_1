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

if [ -e "$input_file" ] && [ ! -f "$input_file" ]; then
    echo "usage: input is not a file or it does not exist"
    exit 1
fi

if [[ "$input_file" != *.vsc ]]; then
    echo "usage: input does not have the extension .vsc"
    exit 1
fi

if [ ! -f "$input_file" ]; then
    echo "usage: input is not a file or it does not exist"
    exit 1
fi

if [ ! -s "$input_file" ]; then
    echo "usage: the file is empty - no .bin file is produced"
    exit 1
fi

output="${input_file%.vsc}.bin"

first_line=$(head -n 1 "$input_file" | tr -d '\r')

if [[ "$first_line" != "0" && "$first_line" != "2" ]]; then
    echo "Error: first line must be 0 or 2"
    exit 1
fi

if [ "$first_line" -eq 0 ]; then
    program_type="It is a QUIT program"
else
    program_type="It is an ADD/SUB program"
fi

all_bytes=""
line_number=0

while IFS= read line || [ -n "$line" ]; do

    line_number=$((line_number + 1))

    if [ -z "$line" ]; then
        continue
    fi

    # Line 1 only tells us the program type,
    # so don't process it again
    if [ "$line_number" -eq 1 ]; then
        continue
    fi
    
    if [ "$first_line" -eq 2 ] && [ "$line_number" -le 3 ]; then

        data_hex=$(printf '%02x' "$line")

        all_bytes="$all_bytes $data_hex"

        continue
    fi

    instruction=$(echo "$line" | cut -d ',' -f 1)
    register=$(echo "$line" | cut -d ',' -f 2)
    address=$(echo "$line" | cut -d ',' -f 3)

    if [ "$instruction" = "LOAD" ]; then
        opcode=1
    elif [ "$instruction" = "STORE" ]; then
        opcode=2
    elif [ "$instruction" = "ADD" ]; then
        opcode=3
    elif [ "$instruction" = "SUB" ]; then
        opcode=4
    elif [ "$instruction" = "QUIT" ]; then
        opcode=8
    elif [ "$instruction" = "PRINT" ]; then
        opcode=9
    fi

    first_byte=$((opcode * 4 + register))

    second_byte="$address"

    first_hex=$(printf '%02x' "$first_byte")
    second_hex=$(printf '%02x' "$second_byte")

    all_bytes="$all_bytes $first_hex $second_hex"

done < "$input_file"

> "$output"

for byte in $all_bytes; do
    printf "\x$byte" >> "$output"
done

echo "$program_type"

echo "The content of the .bin file is"

for byte in $all_bytes; do
    echo "$byte"
done

exit 0