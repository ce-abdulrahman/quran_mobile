import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('assets/data/achievements.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

for i, category in enumerate(data):
    cat_id = category.get('id')
    cat_name = category.get('translations', {}).get('ku', f"Cat {i}")
    achievements = category.get('achievements', [])
    print(f"Category {i}: id={cat_id}, name={cat_name}, count={len(achievements)}")
    for a in achievements:
        name = a.get('translations', {}).get('ku', {}).get('name')
        print(f"  Achievement: id={a.get('id')}, key={a.get('key')}, name={name}")
