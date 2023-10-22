#!/bin/bash

echo "Options are Orders and Orderlines"
read -p "Please enter the API: " api

case "$api" in
  Orders|Orderlines)
    ;;
  *)
    echo "Invalid API option. Choose 'orders' or 'orderlines'."
    exit 1
    ;;
esac

echo "Choose No_Origin, V1, V2 only"
read -p "Please enter your origin: " origin

case "$origin" in
  No_Origin|V1|V2)
    ;;
  *)
    echo "Invalid origin option. Choose 'no_origin', 'v1', or 'v2'."
    exit 1
    ;;
esac

# Define the directory where your CSV files are located
directory="./Json-input-backups"

# Initialize a variable to store the highest number
highest_number=0

# Loop through the files in the directory
for file in "$directory"/data_*.csv; do
    # Extract the number from the file name
    number=$(basename "$file" | sed 's/data_//;s/\.csv//')
    echo $file
    # Check if the extracted number is greater than the current highest number
    if [ "$number" -gt "$highest_number" ]; then
        highest_number="$number"
    fi
done

# Run a loop according to the highest number
for ((i=1; i<=highest_number; i++)); do
    rm -f input.csv
    cp ./Json-input-backups/data_${i}.csv input.csv

    mv ./Json-input-backups/data_${i}.csv ./Json-input-backups/${api}_${origin}_$(date "+%d-%m-%Y")_${i}.csv
    rm -f input.json
    touch input.json
    bash ./script.sh input.csv input.json
    rm -f ./code/input.json
    cp ./input.json ./code/input.json
    bash ./code/script.sh
    mv ./output.xlsx ./Excel-output-backups/${api}_${origin}_$(date "+%d-%m-%Y")_${i}.xlsx
    echo "${api}_${origin}_$(date "+%d-%m-%Y")_${i}.xlsx is created"
done
