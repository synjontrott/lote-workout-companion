import update_energy_core


def test_import_has_no_side_effects():
    # Importing must not touch dashboard_view.dart; the transform must be exposed.
    assert hasattr(update_energy_core, "transform")


def test_transform_applies_replacement():
    content = "BEFORE\n" + update_energy_core.target + "\nAFTER"
    result = update_energy_core.transform(content)
    assert update_energy_core.replacement in result
    assert update_energy_core.target not in result
    assert result.startswith("BEFORE")
    assert result.endswith("AFTER")


def test_transform_noop_when_target_absent():
    content = "no energy core block present here"
    assert update_energy_core.transform(content) == content
