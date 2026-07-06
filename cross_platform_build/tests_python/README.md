# Python script tests

Pytest tests for the helper/codegen scripts in `cross_platform_build/` (the
`add_*.py`, `update_*.py`, `replace_*.py`, `parse_*.py`, and `*_analyzer*.py`
files). One `test_<script>.py` per script.

These scripts are one-shot Dart source transformers. To make them testable and
safe to import, each script exposes a pure transform function (e.g.
`transform(content: str) -> str`) and performs file I/O only under
`if __name__ == "__main__":`. The tests import the module (proving it has no
import-time side effects) and exercise the transform on a representative input.

Run from `cross_platform_build/`:

```sh
pytest              # tests
ruff check .        # lint
```
