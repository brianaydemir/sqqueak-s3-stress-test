#!/bin/bash

set -eux

current_time() { python3 -c 'import time; print(time.time())'; }


## Command-line arguments (reminiscent of `make.sh`).

destination_dir="${1:-.}"
mode="$2"
md5sums_file="$(basename -- "$3")"


## Create the download directory.

mkdir -p "${destination_dir}"


## Download the test data.

for x in $(awk '{ print $2 }' "${md5sums_file}"); do
  start=$(current_time)

  ./move.sh "${mode}" get "${x}"

  end=$(current_time)
  bytes=$(stat -c "%s" "${x}")

  printf '%s\n' >>stats.csv "${x},put,${bytes},${start},${end}"
done


## Verify checksums.

md5sum -c "${md5sums_file}"
