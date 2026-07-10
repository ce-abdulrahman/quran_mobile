import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

# hadiths.json has categories with nested hadiths
# The 12 duplicate IDs (1-12) in hadiths.json are the CATEGORY IDs - let's check if those collide with hadith item IDs
# Let's separate category IDs from hadith item IDs

path = 'assets/data/hadiths.json'
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

cat_ids = []
hadith_ids = []

for cat in data:
    cat_ids.append(cat.get('id'))
    for h in cat.get('hadiths', []):
        hadith_ids.append(h.get('id'))

def find_dups(lst):
    seen = set()
    dups = []
    for x in lst:
        if x in seen:
            dups.append(x)
        else:
            seen.add(x)
    return list(set(dups))

print("Category IDs duplicates:", find_dups(cat_ids))
print("Hadith IDs duplicates:", find_dups(hadith_ids))
print(f"Category IDs (12 total): {cat_ids}")
print(f"Hadith IDs (120 total), unique: {len(set(hadith_ids))}")
