import os
import re

lib_dir = r"c:\Users\kurdn\Desktop\my-quran\quran_mobile\lib"
package_name = "quran_mobile"

def get_relative_path(from_file, import_str):
    # If package import
    if import_str.startswith(f"package:{package_name}/"):
        rel_part = import_str[len(f"package:{package_name}/"):]
        return os.path.normpath(os.path.join(lib_dir, rel_part))
    
    # If other package import (like flutter, path, etc.), ignore
    if import_str.startswith("package:") or import_str.startswith("dart:"):
        return None
    
    # Relative import
    dir_name = os.path.dirname(from_file)
    target = os.path.normpath(os.path.join(dir_name, import_str))
    return target

# 1. Find all dart files
all_dart_files = []
for root, dirs, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            all_dart_files.append(os.path.normpath(os.path.join(root, f)))

# 2. Extract imports from each file
graph = {}
import_pattern = re.compile(r"^\s*import\s+['\"]([^'\"]+)['\"]", re.MULTILINE)

for filepath in all_dart_files:
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    imports = import_pattern.findall(content)
    targets = []
    for imp in imports:
        resolved = get_relative_path(filepath, imp)
        if resolved and resolved in all_dart_files:
            targets.append(resolved)
    
    graph[filepath] = targets

# 3. BFS from main.dart
main_file = os.path.normpath(os.path.join(lib_dir, "main.dart"))
visited = set()
queue = [main_file]

while queue:
    curr = queue.pop(0)
    if curr not in visited:
        visited.add(curr)
        for neighbor in graph.get(curr, []):
            if neighbor not in visited:
                queue.append(neighbor)

# 4. Report unreachable files
unreachable = [f for f in all_dart_files if f not in visited]
print(f"Total Dart files: {len(all_dart_files)}")
print(f"Reachable files: {len(visited)}")
print(f"Unreachable files ({len(unreachable)}):")
for f in sorted(unreachable):
    print(f.replace(lib_dir + os.sep, "lib/"))
