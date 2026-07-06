import os
import json
import urllib.request
import time

QWEN_URL = "http://192.168.1.17:11434/api/generate"

def analyze_with_qwen(filename, code):
    prompt = f"""You are a senior Flutter/Dart developer. Review the following code from '{filename}' for stability, bugs, memory leaks, performance issues, or architectural flaws. Keep your analysis concise and only report real issues or highly recommended improvements. If the code is perfectly fine, say 'No issues found.'

Code:
```dart
{code}
```"""

    payload = {
        "model": "qwen3.6:27b",
        "prompt": prompt,
        "stream": False,
        "think": False,
        "options": {"temperature": 0.2, "num_predict": 1024}
    }
    
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(QWEN_URL, data=data, headers={'Content-Type': 'application/json'})
    
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            result = json.loads(response.read().decode())
            return result.get('response', 'Empty response from Qwen.')
    except Exception as e:
        return f"Error connecting to Qwen: {e}"

def main():
    target_dirs = ["lib/models", "lib/managers"]
    results = []
    
    # Analyze only models and managers as they contain the core logic
    for d in target_dirs:
        for root, _, files in os.walk(d):
            for file in files:
                if file.endswith(".dart"):
                    path = os.path.join(root, file)
                    with open(path, 'r') as f:
                        code = f.read()
                    
                    # Skip extremely large files if they exceed token limits, but 4000 lines should fit in 32k context
                    print(f"Analyzing {path}...")
                    analysis = analyze_with_qwen(path, code)
                    results.append(f"## {path}\n{analysis}\n")
                    time.sleep(1) # Slight pause between requests
                    
    with open('qwen_analysis_report.md', 'w') as f:
        f.write("# Qwen 3.6:27b Code Analysis Report\n\n")
        f.write("\n".join(results))
    print("Done! Report saved to qwen_analysis_report.md")

if __name__ == "__main__":
    main()
