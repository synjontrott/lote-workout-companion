import qwen_analyzer_local


def test_import_has_no_side_effects():
    # Importing must not walk lib/ or make network calls.
    assert hasattr(qwen_analyzer_local, "build_prompt")
    assert qwen_analyzer_local.QWEN_URL == "http://localhost:11434/api/generate"


def test_build_prompt_embeds_filename_and_code():
    prompt = qwen_analyzer_local.build_prompt("lib/bar.dart", "class Bar {}")
    assert "lib/bar.dart" in prompt
    assert "class Bar {}" in prompt
    assert "senior Flutter/Dart developer" in prompt
