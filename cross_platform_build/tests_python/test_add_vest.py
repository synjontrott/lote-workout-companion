import add_vest

I28 = " " * 28
I30 = " " * 30
I32 = " " * 32


def test_import_has_no_side_effects():
    assert hasattr(add_vest, "transform")


def test_transform_adds_weight_vest_controller():
    src = (
        "  final TextEditingController _customWorkoutDurationController =\n"
        "      TextEditingController();"
    )
    out = add_vest.transform(src)
    assert "final TextEditingController _customWorkoutWeightVestController =" in out


def test_transform_applies_vest_xp_multiplier():
    src = (
        f"{I28}int xp = 25;\n"
        f"{I28}int crystals = 10;\n"
        f"{I28}switch (diff) {{\n"
        f"{I30}case 'easy':\n"
        f"{I32}xp = 15;\n"
        f"{I32}crystals = 5;\n"
        f"{I32}break;\n"
        f"{I28}}}\n"
    )
    out = add_vest.transform(src)
    assert (
        "final vestWeightLbs = double.tryParse(_customWorkoutWeightVestController.text) ?? 0.0;"
    ) in out
    assert "double multiplier = 1.0 + (vestWeightLbs / 50.0);" in out


def test_transform_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_vest.transform(src) == src
