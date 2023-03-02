#!/bin/bash

# Check if file path argument is provided
if [ $# -eq 0 ]; then
  echo "Please provide a file path as an argument"
  exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
  echo "File does not exist"
  exit 1
fi

# Get file size in bytes
size=$(stat -c%s "$1")

# Print file size in human-readable format
echo "File size is $(numfmt --to=iec-i --suffix=B $size)"