#!/bin/sh
if [ $# -ne 1 ]; then
  echo "Usage: $0 N"
  exit 1
fi

minor_bound=$1

for minor in $(seq $minor_bound -1 7); do
    version="3.$minor"
    python_exe="python$version"
    if "$python_exe" test.py; then
        echo "python3: \"$python_exe\"" >> conf-python-3-7.config
        exit 0
    fi
done
exit 1
