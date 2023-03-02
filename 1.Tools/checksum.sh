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

# Calculate SHA-256 hash of file
if command -v sha256sum >/dev/null 2>&1; then
  hash=$(sha256sum "$1" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
  hash=$(shasum -a 256 "$1" | awk '{print $1}')
else
  echo "Cannot calculate hash: sha256sum or shasum command not found"
  exit 1
fi

# Print hash string
echo "SHA-256 hash of $1: $hash"
