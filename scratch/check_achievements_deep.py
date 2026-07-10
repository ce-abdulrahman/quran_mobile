import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

# achievements.json: list of categories (ids 1-7), each with nested achievements
with open('assets/data/achievements.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

cat_ids = []
ach_ids = []

for cat in data:
    cat_ids.append(cat.get('id'))
    for ach in cat.get('achievements', []):
        ach_ids.append(ach.get('id'))

def find_dups(lst):
    seen = set()
    dups = []
    for x in lst:
        if x in seen:
            dups.append(x)
        else:
            seen.add(x)
    return list(set(dups))

print("Category IDs:", cat_ids)
print("Achievement IDs:", sorted(ach_ids))
print("Achievement duplicates:", find_dups(ach_ids))

# tajweed_rules.json
with open('assets/data/tajweed_rules.json', 'r', encoding='utf-8') as f:
    data2 = json.load(f)

print(f"\ntajweed_rules.json type: {type(data2)}")
if isinstance(data2, list):
    print(f"Length: {len(data2)}")
    if data2:
        print(f"First item keys: {list(data2[0].keys())}")
    
    # Check if there's a nested structure
    rule_ids = []
    sub_ids = []
    for item in data2:
        rule_ids.append(item.get('id'))
        if 'rules' in item:
            for sub in item.get('rules', []):
                sub_ids.append(sub.get('id'))

    print(f"Rule IDs: {rule_ids}")
    print(f"Rule IDs duplicates: {find_dups(rule_ids)}")
    if sub_ids:
        print(f"Sub IDs: {sorted(sub_ids)}")
        print(f"Sub IDs duplicates: {find_dups(sub_ids)}")
