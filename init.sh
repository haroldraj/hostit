#!/bin/sh

# Start Minio server with the correct parameters
minio server --console-address ":9001" http://minio{1...4}/data{1...2} &

# Wait for Minio to start
sleep 10

# Use Minio's client (mc) to create a bucket
mc alias set myminio http://localhost:9000 minioadmin minioadmin
mc mb myminio/hostit

# Keep the container running
tail -f /dev/null
