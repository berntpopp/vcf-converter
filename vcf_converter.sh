#!/bin/bash

# Script Metadata
SCRIPT_NAME=$(basename "$0")
SCRIPT_VERSION="0.1.0"
SCRIPT_DATE="2024-05-10"

# Default settings
INPUT_FILE=""
OUTPUT_FILE="output.csv"
DELIMITER=","  # Use ',' for CSV, '\t' for TSV
ENCODED_FIELDS="JsiDbComment JsiDbEffect JsiDbSigStr JsiDbSig"

# Help function
print_help() {
    echo "Usage: $SCRIPT_NAME -i <input_file> -o <output_file> -d <delimiter>"
    echo "Options:"
    echo "  -i  Input VCF file"
    echo "  -o  Output file (default: output.csv)"
    echo "  -d  Delimiter (',' for CSV, '\t' for TSV, default: CSV)"
    echo "  -h  Display this help and exit"
}

# Parse command-line options
while getopts "i:o:d:h" opt; do
    case $opt in
        i) INPUT_FILE="$OPTARG" ;;
        o) OUTPUT_FILE="$OPTARG" ;;
        d) DELIMITER="$OPTARG" ;;
        h) print_help
           exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2
            exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2
            exit 1 ;;
    esac
done

# Validate input file
if [ -z "$INPUT_FILE" ]; then
    echo "Input file is required."
    print_help
    exit 1
fi

# Main conversion logic
awk -v delim="$DELIMITER" -v encoded_fields="$ENCODED_FIELDS" -v OFS="$DELIMITER" '
BEGIN { FS="\t"; header_printed = 0; }
/^##/ { next; }  # Skip meta-information lines
/^#CHROM/ {
    sub(/^#/, "");  # Remove leading '#'
    printf "\"%s\"", $1;
    for (i=2; i<=NF; i++) {
        printf "%s\"%s\"", delim, $i;  # Encapsulate fields in quotes
    }
    header_needed = 1;
    next;
}
{
    n = split($8, info_array, ";");
    delete info_items;
    for (i=1; i<=n; i++) {
        split(info_array[i], kv, "=");
        info_items[kv[1]] = kv[2];
    }
    $8 = "";  # Clear the INFO column
    if(header_needed) {
        for (key in info_items) {
            info_header = info_header (info_header ? delim : "") "\"" key "\"";
        }
        print delim info_header;  # Append the header for INFO fields once
        header_needed = 0;
    }
    printf "\"%s\"", $1;
    for (i=2; i<=NF; i++) {
        printf "%s\"%s\"", delim, $i;
    }
    for (key in info_items) {
        if (index(encoded_fields, key) != 0) {
            cmd = "echo " info_items[key] " | base64 --decode 2>/dev/null";
            cmd | getline decoded;
            close(cmd);
            if (decoded != "") {
                info_items[key] = "\"" decoded "\"";
            } else {
                info_items[key] = "\"\"";
            }
        } else {
            info_items[key] = "\"" info_items[key] "\"";
        }
    }
    for (key in info_items) {
        printf "%s%s", delim, info_items[key];
    }
    print "";  # Finish the line
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "File converted and saved to $OUTPUT_FILE"
