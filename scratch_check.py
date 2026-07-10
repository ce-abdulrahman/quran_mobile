import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('assets/data/hadiths.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

cat1 = data[0]['hadiths']
cat4 = data[3]['hadiths']

print("Category 1 vs Category 4:")
for i in range(10):
    h1 = cat1[i]
    h4 = cat4[i]
    print(f"Index {i}:")
    print(f"  Cat 1 text: {h1.get('arabic_text')[:40]}...")
    print(f"  Cat 4 text: {h4.get('arabic_text')[:40]}...")
    print(f"  Cat 1 trans: {h1.get('translation_ku')[:40]}...")
    print(f"  Cat 4 trans: {h4.get('translation_ku')[:40]}...")
    print()
