#!/usr/bin/env python3

import os
import subprocess
import sys
import time


def main() -> None:
    prefix = sys.argv[1]
    filename = sys.argv[2]
    cmd = sys.argv[3:]

    start = time.time()
    process = subprocess.run(cmd, capture_output=True)
    end = time.time()
    elapsed = end - start

    sys.stdout.write(process.stdout.decode("utf-8"))
    sys.stdout.flush()
    sys.stderr.write(process.stderr.decode("utf-8"))
    sys.stderr.flush()

    bytes = os.stat(filename).st_size
    rate = (bytes / 1024 / 1024) / elapsed

    with open("stats.csv", mode="a", encoding="utf-8") as fp:
        print(f"{prefix},{bytes},{start},{end},{elapsed},{rate}", file=fp)

    sys.exit(process.returncode)


if __name__ == "__main__":
    main()
