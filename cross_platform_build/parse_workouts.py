import re


def find_bodyweight_back_workouts(content: str) -> list[str]:
    """Return the names of Bodyweight-Only back SuggestedWorkout entries."""
    names = []
    workouts = re.findall(r'SuggestedWorkout\((.*?)\),', content, re.DOTALL)
    for w in workouts:
        if 'MuscleGroup.back' in w and 'Bodyweight Only' in w:
            name = re.search(r'name:\s*"([^"]+)"', w)
            names.append(name.group(1) if name else 'Unknown')
    return names


def main() -> None:
    with open('lib/models/lote_models.dart', 'r') as f:
        content = f.read()

    for name in find_bodyweight_back_workouts(content):
        print(name)


if __name__ == "__main__":
    main()
