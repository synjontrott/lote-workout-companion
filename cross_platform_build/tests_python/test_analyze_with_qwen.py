import analyze_with_qwen


def test_import_has_no_side_effects():
    # Importing must not read files or make network calls.
    assert hasattr(analyze_with_qwen, "build_prompt")
    assert hasattr(analyze_with_qwen, "FILES_TO_READ")


def test_build_prompt_embeds_code_and_focus_areas():
    prompt = analyze_with_qwen.build_prompt("SOME_CODE_MARKER")
    assert "SOME_CODE_MARKER" in prompt
    assert "LotE Workout Companion" in prompt
    assert "HealthKit sync logic" in prompt
