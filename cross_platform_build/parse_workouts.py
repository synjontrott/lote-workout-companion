import re

with open('lib/models/lote_models.dart', 'r') as f:
    content = f.read()

# Find all SuggestedWorkout entries
workouts = re.findall(r'SuggestedWorkout\((.*?)\),', content, re.DOTALL)
for w in workouts:
    if 'MuscleGroup.back' in w and 'Bodyweight Only' in w:
        name = re.search(r'name:\s*"([^"]+)"', w)
        print(name.group(1) if name else 'Unknown')
