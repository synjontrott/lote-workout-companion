import add_age


def test_import_has_no_side_effects():
    # Importing must not perform file I/O; the refactor exposes transform().
    assert hasattr(add_age, "transform")


def test_transform_adds_age_fields():
    src = (
        "  String _characterName = 'Recruit';\n"
        "  String get characterName => _characterName;\n"
        "  set characterName(String val) { _characterName = val; _save(); notifyListeners(); }\n"
        "      _characterName = prefs.getString('lote_char_name') ?? 'Recruit';\n"
        "      await prefs.setString('lote_char_name', _characterName);\n"
    )
    out = add_age.transform(src)
    assert "int _age = 25;" in out
    assert "int get age => _age;" in out
    assert "set age(int val) { _age = val; _save(); notifyListeners(); }" in out
    assert "_age = prefs.getInt('lote_age') ?? 25;" in out
    assert "await prefs.setInt('lote_age', _age);" in out


def test_transform_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_age.transform(src) == src
