import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

paths = [
    'assets/data/hadiths.json',
    'assets/data/packages/hadith/data.json'
]

for p in paths:
    with open(p, 'r', encoding='utf-8') as f:
        data = json.load(f)
    print(f"File: {p}")
    for i, cat in enumerate(data):
        cat_id = cat.get('id')
        hadiths = cat.get('hadiths', [])
        ids = [h.get('id') for h in hadiths]
        print(f"  Category {i} (id={cat_id}): ids={ids}")
