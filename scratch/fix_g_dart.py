import re

def fix_line(match):
    num_str = match.group(0)
    # Remove any trailing suffixes if any, but in Dart it's just digits
    val = int(num_str)
    if val > 9007199254740991 or val < -9007199254740991:
        js_safe = int(float(val))
        print(f"Replacing {val} with {js_safe}")
        return str(js_safe)
    return num_str

with open('lib/core/local_db/isar_collections.g.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Match positive and negative integers
# We should avoid matching floating point numbers, and only match large integers
# E.g. id: 7167559995064913286 or id: -2393680415312519979
# We match sequences of digits optionally preceded by a minus sign
pattern = r'-?\b\d+\b'

fixed_content = re.sub(pattern, fix_line, content)

with open('lib/core/local_db/isar_collections.g.dart', 'w', encoding='utf-8') as f:
    f.write(fixed_content)

print("Done fixing isar_collections.g.dart!")
