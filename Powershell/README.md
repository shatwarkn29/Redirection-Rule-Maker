# Redirection Rule Maker (PowerShell Version)

## Overview

This project automates the creation of redirection rules in bulk using PowerShell. It extracts domain names and language codes from URLs listed in an Excel file and generates an XML configuration file containing redirection rules.

## Features

- Reads redirection URLs from an Excel file.
- Extracts domain names and language codes from the URLs.
- Saves extracted data into a structured Excel file.
- Generates XML redirection rules based on the extracted data.
- Supports processing of URLs with and without language codes.

## Requirements

- Windows OS with PowerShell.
- Microsoft Excel installed (for COM object interaction).
- `Import-Excel` PowerShell module (for exporting to Excel). Install it using:
  ```powershell
  Install-Module -Name ImportExcel -Scope CurrentUser
  ```

## Usage

1. Update the file path of the input Excel sheet (`Redirection_list.xls`) in the script.
2. Run the PowerShell script.
3. The processed data is saved in `domain_language_info.xlsx`.
4. The generated XML redirection rules are saved in `generated_rules_powershell.xml`.

## Output

- **Excel Output:** Contains extracted domain names, language codes, and destination URLs.
- **XML Output:** A formatted XML file containing redirection rules, ready for implementation.

## Notes

- Ensure that the input Excel file is correctly formatted, with redirection URLs listed in the first column and destination URLs in the second column.
- The script handles cases where language codes are absent by assigning `/` as the default.
