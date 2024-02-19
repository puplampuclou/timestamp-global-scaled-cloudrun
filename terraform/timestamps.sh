#!/bin/bash

# Run the date command and store its output in a variable
current_date=$(date)
bucket=$(gsutil)

# Overwrite the content of timestamps.html with the current date
echo "$current_date" > timestamps.html

# Copy the updated timestamps.html file to /var/www/html/
cp timestamps.html /var/www/html/

echo "Updated timestamps.html copied to /var/www/html/"

echo "@bucket" cp timestamps.html gs://http-timestamp-rp-2024/custom-time.txt