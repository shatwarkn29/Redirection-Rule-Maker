# Redirection Rule Maker

## Overview
Redirection Rule Maker is a Python-based tool designed to generate bulk redirection rules from an Excel file containing base URLs and destination links. The script processes the data to extract domain names and language codes, then creates structured XML rules for URL redirection.

## Features
- **Bulk Processing**: Reads multiple redirection entries from an Excel file.
- **Domain & Language Extraction**: Identifies domain names and language codes from URLs.
- **Automated Rule Generation**: Produces structured XML redirection rules.
- **Excel Export**: Saves processed data into a structured Excel file.

## Usage
1. Prepare an Excel file (`Redirection_list.xls`) with columns for base links and destination URLs.
2. Run the Python script to process the data.
3. Extracted domain and language details are saved in `domain_language_info.xlsx`.
4. XML redirection rules are generated and stored in `generated_rules.xml`.

## Requirements
- Python 3.x
- Required libraries: `pandas`, `openpyxl`

## Output Files
- **`domain_language_info.xlsx`**: Processed data with domain names and language codes.
- **`generated_rules.xml`**: XML file containing structured redirection rules.
