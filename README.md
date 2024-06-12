
# VCF to CSV Converter

This repository contains a bash script `vcf_to_csv.sh` which is designed to convert VCF (Variant Call Format) files into CSV (Comma-Separated Values) format with robust handling for encoded fields and proper encapsulation of output fields in quotes.

## Overview

The `vcf_to_csv.sh` script simplifies the conversion of genomic data from VCF files into a more universally accessible CSV format. It encapsulates each value within quotes to ensure compatibility with CSV parsers and provides functionality to decode specific encoded fields like comments and effects.

### Key Features:

- Converts VCF files to CSV format.
- Handles encoded fields by decoding them from Base64.
- Encapsulates all output fields in quotes to ensure CSV format integrity.
- Allows specifying delimiters for the output file (comma or tab).

## Usage

To use the script, you must provide the input VCF file and specify the output file name and delimiter. The script usage is as follows:

```bash
./vcf_converter.sh -i <input_file> -o <output_file> -d <delimiter>
```

### Parameters:

- `-i <input_file>`: The path to the input VCF file.
- `-o <output_file>`: The path to the output CSV file (default: `output.csv`).
- `-d <delimiter>`: Delimiter for the CSV output (',' for CSV, '\t' for TSV; default: ',').
- `-h`: Display help and exit.

### Example:

```bash
./vcf_to_csv.sh -i sample.vcf -o sample.csv -d ","
```

## Requirements

- GNU Awk (Gawk): Used for processing the VCF files.
- Bash: For scripting and control flow.

## Installation

No specific installation steps are required if you have Bash and Gawk already installed on your system. You can simply clone this repository and run the script.

```bash
git clone https://github.com/your-username/vcf-to-csv-converter.git
cd vcf-to-csv-converter
chmod +x vcf_to_csv.sh
./vcf_to_csv.sh -i your_input.vcf -o your_output.csv
```

## Configuration

The script includes adjustable settings for the fields that need to be decoded from Base64. Modify the `ENCODED_FIELDS` variable within the script to match the fields in your VCF that are encoded and need decoding:

```bash
ENCODED_FIELDS="JsiDbComment JsiDbEffect JsiDbSig"
```

## Output

The script generates a CSV file where each line corresponds to a VCF entry, and fields are separated by the specified delimiter. The first line contains headers derived from the VCF file's metadata.

## Troubleshooting

- Ensure that the input VCF file is properly formatted and contains the standard VCF headers.
- If output fields are not decoded properly, check the `ENCODED_FIELDS` setting and ensure that the field names match those in your VCF file.

## Contributing

Contributions to improve the script or address bugs are welcome. Please submit a pull request or an issue through GitHub.