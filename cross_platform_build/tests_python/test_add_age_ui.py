import add_age_ui


def test_import_has_no_side_effects():
    assert hasattr(add_age_ui, "transform_psych_evaluation")
    assert hasattr(add_age_ui, "transform_settings")


def test_transform_psych_evaluation_adds_age_controller_and_field():
    src = (
        "  TextEditingController _nameController = TextEditingController();\n"
        "    _nameController.text = Provider.of<UserProfileManager>"
        "(context, listen: false).characterName;\n"
        "    profile.characterName = _nameController.text;\n"
        '        _buildTextField("CHARACTER NAME", _nameController, TextInputType.name),\n'
        "        const SizedBox(height: 16),\n"
    )
    out = add_age_ui.transform_psych_evaluation(src)
    assert "TextEditingController _ageController = TextEditingController();" in out
    assert (
        "_ageController.text = Provider.of<UserProfileManager>"
        "(context, listen: false).age.toString();"
    ) in out
    assert "profile.age = int.tryParse(_ageController.text) ?? 25;" in out
    assert '_buildTextField("AGE", _ageController, TextInputType.number),' in out


def test_transform_settings_adds_age_config_field():
    src = (
        "                          _buildConfigField(\n"
        '                            label: "WARRIOR NAME",\n'
        '                            hint: "Enter Name",\n'
        "                            initialValue: profile.characterName,\n"
        "                            onChanged: (val) => profile.characterName = val,\n"
        "                          ),\n"
        "                          const SizedBox(height: 12),\n"
    )
    out = add_age_ui.transform_settings(src)
    assert 'label: "AGE",' in out
    assert 'hint: "Enter Age",' in out
    assert "initialValue: profile.age.toString()," in out


def test_transforms_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_age_ui.transform_psych_evaluation(src) == src
    assert add_age_ui.transform_settings(src) == src
