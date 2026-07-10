import re

def fix_literal(match):
    num_str = match.group(1)
    val = int(num_str)
    if val > 9007199254740991 or val < -9007199254740991:
        # Convert to 64-bit unsigned representation
        unsigned_val = val & 0xffffffffffffffff
        high_32 = unsigned_val >> 32
        low_32 = unsigned_val & 0xffffffff
        return f" kIsWeb ? 0 : ({high_32} << 32) | {low_32}"
    return match.group(0)

with open('lib/core/local_db/isar_collections.g.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Match spaces or colons followed by a positive/negative integer literal
# We use a capture group to extract the integer itself
pattern = r'[:\s](-?\b\d+\b)'

fixed_content = re.sub(pattern, fix_literal, content)

with open('lib/core/local_db/isar_collections.g.dart', 'w', encoding='utf-8') as f:
    f.write(fixed_content)

print("Finished converting isar_collections.g.dart!")
