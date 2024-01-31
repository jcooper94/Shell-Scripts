#!/bin/bash

#global variables
og_num=""
og_ip=""

function to_binary() {
    # decimal to binary
    decimal_chart=(128 64 32 16 8 4 2 1)

    binary=()

    read -p "Input the IP Address: " ip

    declare -g og_ip=$ip

    decimal="${ip%%.*}"

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
    "0"*) echo "A" ;;
    "10"*) echo "B" ;;
    "110"*) echo "C" ;;
    "1110"*) echo "D" ;;
    "1111"*) echo "E" ;;
    esac
}

function to_subnet() {
    case $class in
    "A") echo "255.0.0.0.";;
    "B") echo "255.255.0.0";;
    "C") echo "255.255.255.0";;
    "D") echo "Undefined";;
    "E") echo "Undefined";;
    esac
}

function to_subhosts() {
    echo "test"
    # #of subnets = 2^subnet bits
    # # hosts per subnet = 2^host bits - 2
}

function to_info() {
    echo "test $og_ip"
    #network address
    #network broadcast address
    #first usable address
    #last usable host address
}

# call the function and set the echo to a variable and echo the variable since no return like in python
binary=$(to_binary)

class=$(to_class $binary)

subnet=$(to_subnet $class)

echo "The integer $og_num in binary is $binary."

echo "It is a class $class address."

echo "The subnet mask is $subnet."