#!/bin/bash

# Input JSON file name
input_json="input.json"

# Output Excel file name
output_excel="output.xlsx"

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq is not installed. Please install jq to continue."
  exit 1
fi

# Check if xlsxwriter is installed
if ! pip3 show xlsxwriter &>/dev/null; then
  echo "xlsxwriter is not installed. Please install xlsxwriter using pip3."
  exit 1
fi

# Extract data from JSON and save it to a CSV file
jq -r '[.[] | {path: .message | fromjson | .servlet.path, method: .message | fromjson | .http.method, duration: .message | fromjson | .duration}]' "$input_json" | jq -r '.[] | [.method, .path, .duration] | @csv' > temp.csv

# Create an Excel file and write data to it
python3 <<END_PYTHON
import xlsxwriter

input_csv = "temp.csv"
output_xlsx = "$output_excel"

workbook = xlsxwriter.Workbook(output_xlsx)
worksheet = workbook.add_worksheet()

# Read data from the CSV file and write it to the Excel file
with open(input_csv, 'r') as csv_file:
    row = 0
    for line in csv_file:
        data = line.strip().split(',')
        for col, value in enumerate(data):
            worksheet.write(row, col, value)
        row += 1

workbook.close()
END_PYTHON

# Clean up the temporary CSV file
rm temp.csv

echo "Conversion complete. Output saved to $output_excel"
