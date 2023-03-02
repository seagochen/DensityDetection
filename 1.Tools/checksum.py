import hashlib
import sys

# Check if file path argument is provided
if len(sys.argv) < 2:
    print("Please provide a file path as an argument")
    sys.exit(1)

# Check if file exists
file_path = sys.argv[1]
try:
    with open(file_path, 'rb') as f:
        pass
except FileNotFoundError:
    print("File does not exist")
    sys.exit(1)

# Calculate MD5 hash string
md5 = hashlib.md5()
with open(file_path, 'rb') as f:
    for chunk in iter(lambda: f.read(4096), b""):
        md5.update(chunk)
print(f"MD5 hash: {md5.hexdigest()}")

# Calculate SHA1 hash string
sha1 = hashlib.sha1()
with open(file_path, 'rb') as f:
    for chunk in iter(lambda: f.read(4096), b""):
        sha1.update(chunk)
print(f"SHA1 hash: {sha1.hexdigest()}")

# Calculate SHA256 hash string
sha256 = hashlib.sha256()
with open(file_path, 'rb') as f:
    for chunk in iter(lambda: f.read(4096), b""):
        sha256.update(chunk)
print(f"SHA256 hash: {sha256.hexdigest()}")
