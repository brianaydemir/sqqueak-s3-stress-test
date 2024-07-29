#!/bin/bash

set -eux


# Check if the two required positional arguments are provided
if [ "$#" -lt 2 ]; then
        echo "Usage: $0 <num_files> <file_size> [destination_dir]"
        exit 1
fi


# Get the number of files, file size, and destination directory from positional arguments
num_files="$1"
file_size="$2"
destination_dir="${3:-.}"
min=1
s_max=2048
m_max=512
l_max=2


# Check if the number of files is a positive integer
if ! [[ "$num_files" =~ ^[1-9][0-9]*$ ]]; then
        echo "Number of files must be a positive integer."
        exit 1
fi

# Check if the destination directory is actually a directory
if [ ! -d "$destination_dir" ]; then
        echo "Destination is not a directory."
        exit 1
fi


# Generate random files based on the specified size
for i in $(eval echo "{1..$num_files}"); do
        case "$file_size" in
                "small")
                        dd bs=1K count=$((RANDOM % s_max + min)) if=/dev/urandom of="${destination_dir}/small-$i"
                        ;;
                "medium")
                        dd bs=1M count=$((RANDOM % m_max + min)) if=/dev/urandom of="${destination_dir}/medium-$i"
                        ;;
                "large")
                        dd bs=1G count=$((RANDOM % l_max + min)) if=/dev/urandom of="${destination_dir}/large-$i"
                        ;;
                *)
                        echo "Invalid file size. Please specify 'small', 'medium', or 'large'."
                        exit 1
                        ;;
        esac
done
