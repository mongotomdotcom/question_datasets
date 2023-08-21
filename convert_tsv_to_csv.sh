#!/bin/bash
set -oeE pipefail

################################## README ######################################
# Converts a .tsv (tab separated) file to .csv (comma separated) and will save 
# the new file as "oldname.csv" in the same location as the input file, run:
#   chmod +x convert_tsv_to_csv.sh
#   ./convert_tsv_to_csv.sh your_tab_separated_value_file.tsv
#
# WARNING: This script will delete all commas within the dataset to avoid errors
################################################################################

# TODO: Fix the deletion of commas within the fields/escape the commas

# Error return function to exit with error message, pass message string as an arg
exit_error() {
  echo "
--------------------------------------------------------------------------------"
  if [ -z "$1" ]; then
    echo "Error, no error message passed to exit_error(), exiting anyway..."
  else
    echo "$1"
  fi
  exit 1
}

# Check input file for validity
if [ -z "$1" ]; then
  exit_error "Error, no .tsv file passed to the script as an arg, exiting..."
elif [ -s "$1" ]; then
  tsv_file="$1"
else
  exit_error "Error, supplied .tsv file appears to be empty, exiting..."
fi

# Make sure output file doesn't alread exist
csv_file="$(echo "$tsv_file" | rev | cut -d"." -f2- | rev).csv"
if [ -f "$csv_file" ]; then
  exit_error "Error, csv output file already exists in the input directory, exiting.
  Try again after deleting: $csv_file"
fi
line_count=$(wc -l < "$tsv_file")
start_time=$(date +%s)

# Loop through file, delete commas, and convert tabs to commas
tr -d "," < "$tsv_file" | tr "\t" "," > "$csv_file" # TODO: Add a step to remove whitespace?

# Notify user of success and stats
echo "
Converted $line_count lines in $(( $(date +%s) - start_time )) seconds. CSV has been saved to:
  $csv_file"
