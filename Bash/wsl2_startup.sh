#!/bin/bash

current_dir=$(pwd)

echo "cd $current_dir" >> ~/.bashrc

source ~/.bashrc

echo "Changed startup location successfully!"