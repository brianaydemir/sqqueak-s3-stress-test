#!/bin/bash

set -eux


## Command-line arguments (reminiscent of `make.sh`).

num_files="$1"
file_size="$2"
destination_dir="${3:-.}"
mode="$4"


## Create the test data.

mkdir -p "${destination_dir}"
./make.sh "${num_files}" "${file_size}" "${destination_dir}"
md5sum "${destination_dir}"/* > md5sums.txt


## Upload the test data.

for x in "${destination_dir}"/*; do
  ./time_cmd.py "${x},put" "${x}" ./move.sh "${mode}" put "${x}"
done


## Delete the local copy of our test data.

rm -rf "${destination_dir:?}"/*


## Wait for a bit.

sleep "$((RANDOM % 60))"


## Download the test data.

for x in $(awk '{ print $2 }' md5sums.txt); do
  ./time_cmd.py "${x},get" "${x}" ./move.sh "${mode}" get "${x}"
done


## Verify checksums.

md5sum -c md5sums.txt
