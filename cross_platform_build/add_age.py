import re

with open('lib/managers/user_profile_manager.dart', 'r') as f:
    content = f.read()

# Add _age declaration
content = re.sub(r'(String _characterName = \'Recruit\';)', r'\1\n  int _age = 25;', content)

# Add age getter
content = re.sub(r'(String get characterName => _characterName;)', r'\1\n  int get age => _age;', content)

# Add age setter
content = re.sub(r'(set characterName\(String val\) \{ _characterName = val; _save\(\); notifyListeners\(\); \})', r'\1\n  set age(int val) { _age = val; _save(); notifyListeners(); }', content)

# Add to _load
content = re.sub(r"(_characterName = prefs\.getString\('lote_char_name'\) \?\? 'Recruit';)", r"\1\n      _age = prefs.getInt('lote_age') ?? 25;", content)

# Add to _save
content = re.sub(r"(await prefs\.setString\('lote_char_name', _characterName\);)", r"\1\n      await prefs.setInt('lote_age', _age);", content)

with open('lib/managers/user_profile_manager.dart', 'w') as f:
    f.write(content)
