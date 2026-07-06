import re

with open('lib/models/lote_models.dart', 'r') as f:
    content = f.read()

replacements = {
    "bodyweight_inverted_rows": {
        "name": "Superman Holds",
        "description": "Engage the entire posterior chain with isometric holds.",
        "instructions": [
            "Lie face down with arms extended forward.",
            "Squeeze glutes and lift arms and legs off the floor.",
            "Hold the top position, feeling the contraction in your lower and mid back.",
            "Slowly lower back down to the starting position."
        ]
    },
    "door_frame_pull_ins": {
        "name": "Reverse Snow Angels",
        "description": "Target the lats, rhomboids, and lower back with sweeping motions.",
        "instructions": [
            "Lie face down, arms straight down by your sides.",
            "Lift arms and chest slightly off the floor.",
            "Sweep arms overhead in a wide arc without touching the floor.",
            "Sweep back down to your sides, squeezing your lats."
        ]
    },
    "towel_grip_pull_up_prep": {
        "name": "Prone Y-T-W Raises",
        "description": "Isolate the upper back and shoulders through targeted angle raises.",
        "instructions": [
            "Lie face down with arms extended in a Y shape.",
            "Lift arms up, squeeze shoulder blades, then lower.",
            "Move arms to a T shape, lift, squeeze, and lower.",
            "Bend elbows to a W shape, lift, squeeze, and lower."
        ]
    },
    "l_sit_pullups_back_control": {
        "name": "Bird Dog Back Extension",
        "description": "Unilateral spinal erector and core stability challenge.",
        "instructions": [
            "Start on hands and knees with a neutral spine.",
            "Extend right arm forward and left leg backward simultaneously.",
            "Squeeze your back and glute, keeping your hips square.",
            "Return to center and repeat on the opposite side."
        ]
    }
}

for w_id, data in replacements.items():
    pattern = r'(SuggestedWorkout\(\s*id:\s*"' + w_id + r'".*?instructions:\s*\[)(.*?)(\],\s*sets:.*?\),)'
    
    def replacer(match):
        prefix = match.group(1)
        suffix = match.group(3)
        
        prefix = re.sub(r'name:\s*"[^"]+"', f'name: "{data["name"]}"', prefix)
        prefix = re.sub(r'description:[\s\S]*?(?=\s*instructions:)', f'description:\n          "{data["description"]}",\n      ', prefix)
        
        new_instructions = "\n".join([f'        "{inst}",' for inst in data["instructions"]]) + "\n      "
        
        return prefix + "\n" + new_instructions + suffix
        
    content = re.sub(pattern, replacer, content, flags=re.DOTALL)

with open('lib/models/lote_models.dart', 'w') as f:
    f.write(content)
