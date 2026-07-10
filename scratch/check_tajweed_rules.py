import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

paths = [
    'assets/data/tajweed_rules.json',
    'assets/data/packages/tajweed/tajweed_rules.json'
]

for p in paths:
    try:
        with open(p, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Let's inspect rule IDs
        rule_ids = []
        cat_ids = []
        for cat in data:
            cat_ids.append(cat.get('id'))
            rules = cat.get('rules', [])
            for r in rules:
                rule_ids.append(r.get('id'))
        
        print(f"File {p}:")
        print(f"  Categories IDs: {cat_ids}")
        # Find duplicate rule_ids
        seen = set()
        dups = []
        for x in rule_ids:
            if x in seen:
                dups.append(x)
            else:
                seen.add(x)
        print(f"  Rule IDs count: {len(rule_ids)}, Unique: {len(seen)}, Duplicates: {list(set(dups))}")
    except Exception as e:
        print(f"Error reading {p}: {e}")
