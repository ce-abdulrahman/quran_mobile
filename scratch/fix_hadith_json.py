import re

with open('assets/data/packages/hadith/data.json', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace any "} \n    {" or similar with "},\n    {"
# Let's use regex to find where a closing brace and opening brace are separated by whitespace/newlines but no comma
fixed_content = re.sub(r'\}\s*\{', '},\n{', content)

with open('assets/data/packages/hadith/data.json', 'w', encoding='utf-8') as f:
    f.write(fixed_content)

print("Rewrote file with regex replacement. Let's try loading it now.")
import json
try:
    with open('assets/data/packages/hadith/data.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    print("Successfully parsed data.json!")
except Exception as e:
    print(f"Error parsing data.json: {e}")
