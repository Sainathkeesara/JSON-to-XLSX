#!/bin/bash

# Check if the required tool jq is installed
if ! command -v jq > /dev/null; then
  echo "jq is not installed. Please install it and try again."
  exit 1
fi

# Check if the input CSV file exists
if [ ! -f "$1" ]; then
  echo "Input CSV file not found."
  exit 1
fi

# Check if the output JSON file is specified
if [ -z "$2" ]; then
  echo "Usage: $0 <input_csv_file> <output_json_file>"
  exit 1
fi

# Convert CSV to JSON using Python
python3 -c "
import csv
import json
import sys

csv_file = '$1'
json_file = '$2'

data = []
with open(csv_file, 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        data.append(row)

with open(json_file, 'w') as json_file:
    json.dump(data, json_file, indent=2)
"

echo "CSV to JSON conversion complete. Output saved to $2."
