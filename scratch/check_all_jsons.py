import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

data_dir = 'assets/data'
json_files = [f for f in os.listdir(data_dir) if f.endswith('.json')]

for jf in json_files:
    path = os.path.join(data_dir, jf)
    with open(path, 'r', encoding='utf-8') as f:
        try:
            content = json.load(f)
        except Exception as e:
            print(f"Error parsing {jf}: {e}")
            continue
    
    # Let's find all IDs in this file recursively or depending on structure
    # Usually structure is either a list of items with 'id', or list of categories with list of items.
    ids = []
    
    def collect_ids(obj):
        if isinstance(obj, dict):
            if 'id' in obj:
                ids.append(obj['id'])
            for v in obj.values():
                collect_ids(v)
        elif isinstance(obj, list):
            for item in obj:
                collect_ids(item)

    collect_ids(content)
    
    # Check duplicates
    if ids:
        seen = set()
        dups = []
        for x in ids:
            if x in seen:
                dups.append(x)
            else:
                seen.add(x)
        if dups:
            print(f"File {jf}: Total IDs = {len(ids)}, Unique IDs = {len(seen)}, Duplicates = {list(set(dups))}")
        else:
            print(f"File {jf}: Total IDs = {len(ids)} (All unique)")
    else:
        print(f"File {jf}: No IDs found")
