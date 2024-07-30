#!/bin/bash

set -eux

current_time() { python3 -c 'import time; print(time.time())'; }


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
  start=$(current_time)

  ./move.sh "${mode}" put "${x}"

  end=$(current_time)
  bytes=$(stat -c "%s" "${x}")

  printf '%s\n' >>stats.csv "${x},put,${bytes},${start},${end}"
done


## Delete the local copy of our test data.

rm -f "${destination_dir:?}"/{small,medium,large}-*


## Wait for a bit.

sleep "$((RANDOM % 60))"


## Download the test data.

for x in $(awk '{ print $2 }' md5sums.txt); do
  start=$(current_time)

  ./move.sh "${mode}" get "${x}"

  end=$(current_time)
  bytes=$(stat -c "%s" "${x}")

  printf '%s\n' >>stats.csv "${x},put,${bytes},${start},${end}"
done


## Verify checksums.

md5sum -c md5sums.txt
