#!/bin/bash

#global variables
og_num=""

function to_binary() {
    # decimal to binary
    decimal_chart=(128 64 32 16 8 4 2 1)

    binary=()

    read -p "Input the decimal number: " decimal

    declare -g og_num=$decimal

    for num in "${decimal_chart[@]}"; do
        if (("$decimal" >= "$num")); then
            decimal=$((decimal - num))
            binary+=(1)
        else
            binary+=(0)
        fi
    done

    echo "${binary[*]}"
}

function to_class() {
    arr=($@) # convert all arguments into an array

    first_four=""

    for i in {0..3}; do
        first_four+="${arr[i]}"
    done

    # Determine the class based on the first four digits
    case $first_four in
    "0"*) echo "Class A" ;;
    "10"*) echo "Class B" ;;
    "110"*) echo "Class C" ;;
    "1110"*) echo "Class D" ;;
    "1111"*) echo "Class E" ;;
    esac
}

# call the function and set the echo to a variable and echo the variable since no return like in python
binary=$(to_binary)

class=$(to_class $binary)

echo "The integer $og_num in binary is $binary."

echo "It is a $class address."
