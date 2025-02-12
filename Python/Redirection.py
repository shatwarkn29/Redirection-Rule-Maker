import re
import pandas as pd

def extract_domain_and_language(url):
     # Defining a regular expression pattern to match the domain name and language code
    pattern = r'https?://([^/]+)(?:/([^/]+))?'

    # Use re.match to find the pattern in the URL
    match = re.match(pattern, url)

    if match:
        # Extract the domain name and language code
        domain_name = match.group(1)  # Extract domain
        language_code = match.group(2) if match.group(2) else 'N/A'  # Extract language if exists

        return domain_name, language_code
    else:
        return None, None

# Read the Excel file into a DataFrame
df = pd.read_excel('Redirection_list.xls')

Baselinks = df["Redirect Checker"].astype(str).tolist()
DestnLinks = df["Destination URL"].astype(str).tolist()

data = []

for url, destn in zip(Baselinks, DestnLinks):
    domain, language = extract_domain_and_language(url)
    data.append({'Domain Name': domain, 'Language': language, 'Destination': destn})

# Create a DataFrame from the extracted data
df_extracted = pd.DataFrame(data)

# Save the DataFrame to an Excel file
excel_file_path = 'domain_language_info.xlsx'
df_extracted.to_excel(excel_file_path, index=False)

print(f"Data saved to '{excel_file_path}'")

# Generate Redirect Rules XML
rules = "<rules>\n"

for index, row in df_extracted.iterrows():
    rule = f"\t<rule name=\"lwell-rule-lang-{row['Language']}\" stopProcessing=\"true\">\n"
    rule += f"\t\t<match url=\".*\" />\n"
    rule += "\t\t<conditions logicalGrouping=\"MatchAll\">\n"
    rule += f"\t\t\t<add input=\"{{HTTP_HOST}}\" pattern=\".*{row['Domain Name']}$\"/>\n"
    
    if row['Language'] != 'N/A':  # Skip adding REQUEST_URI for "N/A"
        rule += f"\t\t\t<add input=\"{{REQUEST_URI}}\" pattern=\"^{row['Language']}$\"/>\n"

    rule += "\t\t</conditions>\n"
    rule += f"\t\t<action type=\"Redirect\" url=\"{row['Destination']}\" redirectType=\"Permanent\" appendQueryString=\"false\"/>\n"
    rule += "\t</rule>\n"
    rules += rule

rules += "</rules>"

# Save the rules to a file
with open('generated_rules.xml', 'w') as file:
    file.write(rules)

print("XML rules saved to 'generated_rules.xml'")
