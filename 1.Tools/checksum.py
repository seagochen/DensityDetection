import hashlib
import sys

# Check if file path argument is provided
if len(sys.argv) < 2:
    print("Please provide a file path as an argument")
    sys.exit(1)

# Check if file exists
filepath = sys.argv[1]
try:
    with open(filepath, 'rb') as f:
        data = f.read()
except IOError:
    print("File does not exist")
    sys.exit(1)

# Calculate hash string using SHA-256 algorithm
hash_object = hashlib.sha256(data)
hash_string = hash_object.hexdigest()

print("SHA-256 hash string for file", filepath, "is", hash_string)
