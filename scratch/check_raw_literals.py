import re

with open('lib/core/local_db/isar_collections.g.dart', 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r'\b\d{16,}\b'
matches = re.findall(pattern, content)
print(f"Found {len(matches)} raw integer literals with 16+ digits:")
for m in matches[:10]:
    print(m)
