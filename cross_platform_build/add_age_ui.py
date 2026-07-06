import re


def transform_psych_evaluation(content: str) -> str:
    # Add _ageController
    content = re.sub(
        r'(TextEditingController _nameController = TextEditingController\(\);)',
        r'\1\n  TextEditingController _ageController = TextEditingController();',
        content
    )

    # Initialize _ageController in initState
    content = re.sub(
        r'(_nameController\.text = Provider\.of<UserProfileManager>\(context, listen: false\)\.characterName;)',
        r'\1\n    _ageController.text = Provider.of<UserProfileManager>(context, listen: false).age.toString();',
        content
    )

    # Add to _confirmProfile
    content = re.sub(
        r'(profile\.characterName = _nameController\.text;)',
        r'\1\n    profile.age = int.tryParse(_ageController.text) ?? 25;',
        content
    )

    # Add UI field
    content = re.sub(
        r'(_buildTextField\("CHARACTER NAME", _nameController, TextInputType\.name\),\n\s*const SizedBox\(height: 16\),)',
        r'\1\n        _buildTextField("AGE", _ageController, TextInputType.number),\n        const SizedBox(height: 16),',
        content
    )

    return content


def transform_settings(content: str) -> str:
    # Add to _buildConfigField list in Settings
    content = re.sub(
        r'(_buildConfigField\(\n\s*label: "WARRIOR NAME",\n\s*hint: "Enter Name",\n\s*initialValue: profile\.characterName,\n\s*onChanged: \(val\) => profile\.characterName = val,\n\s*\),\n\s*const SizedBox\(height: 12\),)',
        r'\1\n                          _buildConfigField(\n                            label: "AGE",\n                            hint: "Enter Age",\n                            initialValue: profile.age.toString(),\n                            onChanged: (val) {\n                              final a = int.tryParse(val);\n                              if (a != null) profile.age = a;\n                            },\n                          ),\n                          const SizedBox(height: 12),',
        content
    )

    return content


def main() -> None:
    psych_path = 'lib/views/psych_evaluation_view.dart'
    with open(psych_path, 'r') as f:
        content = f.read()
    content = transform_psych_evaluation(content)
    with open(psych_path, 'w') as f:
        f.write(content)

    settings_path = 'lib/views/settings_view.dart'
    with open(settings_path, 'r') as f:
        content = f.read()
    content = transform_settings(content)
    with open(settings_path, 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
