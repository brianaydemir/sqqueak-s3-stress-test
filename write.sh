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
