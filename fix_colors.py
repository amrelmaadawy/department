import os
import glob
import re

files = glob.glob('lib/**/*.dart', recursive=True)
count = 0

replacements = {
    r'Colors\.transparent': 'AppColors.transparent',
    r'Colors\.white': 'AppColors.white',
    r'Colors\.black': 'AppColors.black',
    r'Colors\.grey': 'AppColors.grey',
    r'Colors\.amber': 'AppColors.warning',
    r'Colors\.red': 'AppColors.error',
    r'Colors\.green': 'AppColors.success',
    r'Colors\.blue': 'AppColors.primary',
}

for target in files:
    if 'app_colors' in target or 'app_theme' in target or 'theme_extension' in target:
        continue
    
    with open(target, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = content
    for k, v in replacements.items():
        new_content = re.sub(k, v, new_content)
    
    # Also fix Colors.grey[xyz] -> AppColors.grey[xyz] which doesn't exist, we should use specific shades if needed, 
    # but Colors.grey[xyz] is not valid since AppColors.grey is a Color, not a MaterialColor.
    # So we need to replace Colors.grey\[.*?\] with AppColors.grey. Wait, we added grey300, grey700, etc.
    new_content = re.sub(r'Colors\.grey\[300\]', 'AppColors.grey300', new_content)
    new_content = re.sub(r'Colors\.grey\[700\]', 'AppColors.grey700', new_content)
    new_content = re.sub(r'Colors\.grey\[800\]', 'AppColors.grey800', new_content)
    new_content = re.sub(r'Colors\.grey\[100\]', 'AppColors.grey100', new_content)
    new_content = re.sub(r'Colors\.grey\.shade300', 'AppColors.grey300', new_content)
    new_content = re.sub(r'Colors\.grey\.shade700', 'AppColors.grey700', new_content)
    new_content = re.sub(r'Colors\.grey\.shade600', 'AppColors.grey700', new_content) # map 600 to 700
    
    if new_content != content:
        if 'package:apartment/core/theme/app_colors.dart' not in new_content:
            new_content = "import 'package:apartment/core/theme/app_colors.dart';\n" + new_content
        with open(target, 'w', encoding='utf-8') as f:
            f.write(new_content)
        count += 1

print(f"Updated {count} files.")
