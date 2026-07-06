import os
import json
import urllib.request

def analyze_code():
    code_content = ""
    # Only get the core files to avoid massive context size if possible,
    # or just read all if under 100k tokens. 17k lines is ~150k chars, ~30-40k tokens.
    files_to_read = [
        "lib/managers/user_profile_manager.dart",
        "lib/models/lote_models.dart",
        "lib/views/dashboard_view.dart",
        "lib/views/quest_board_view.dart",
    ]
    
    for filepath in files_to_read:
        with open(filepath, 'r', encoding='utf-8') as f:
            code_content += f"\n--- {filepath} ---\n"
            code_content += f.read()

    prompt = f"""
Analyze the following core files of the LotE Workout Companion Flutter application. 
Look for bugs, logical flaws, architectural issues, missing requirements, or areas of improvement.
Particularly focus on:
- Psych profile mechanics (ADHD, AuDHD, Autistic, Neurotypical)
- Notifications and scheduling mechanics
- RPG progression and D&D stats curve
- HealthKit sync logic

Output a list of actionable tickets/issues you find.

{code_content}
"""

    url = "http://192.168.1.17:11434/api/generate"
    data = {
        "model": "qwen3.6:27b",
        "prompt": prompt,
        "stream": False,
        "think": False,
        "options": {"temperature": 0.3, "num_predict": 4096}
    }
    
    req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers={'Content-Type': 'application/json'})
    
    print("Sending request to Qwen...")
    try:
        with urllib.request.urlopen(req, timeout=300) as response:
            result = json.loads(response.read().decode('utf-8'))
            print("Response from Qwen:")
            print(result.get('response', 'EMPTY'))
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    analyze_code()
