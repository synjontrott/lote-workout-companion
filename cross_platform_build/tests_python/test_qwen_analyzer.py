import qwen_analyzer


def test_import_has_no_side_effects():
    # Importing must not walk lib/ or make network calls.
    assert hasattr(qwen_analyzer, "build_prompt")
    assert qwen_analyzer.QWEN_URL == "http://192.168.1.17:11434/api/generate"


def test_build_prompt_embeds_filename_and_code():
    prompt = qwen_analyzer.build_prompt("lib/foo.dart", "class Foo {}")
    assert "lib/foo.dart" in prompt
    assert "class Foo {}" in prompt
    assert "senior Flutter/Dart developer" in prompt
