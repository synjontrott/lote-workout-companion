import re

with open('lib/views/psych_evaluation_view.dart', 'r') as f:
    content = f.read()

# 1. State variables
state_vars = """
  // Mindset Quiz states
  bool _showingMindsetQuiz = false;
  int _currentMindsetQuizQuestionIdx = 0;
  final List<int> _mindsetQuizAnswers = [];
"""
content = content.replace('  // Mindset states', state_vars + '\n  // Mindset states')

# 2. Add button in _buildMindsetScreen
button_code = """
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _showingMindsetQuiz = true;
              _currentMindsetQuizQuestionIdx = 0;
              _mindsetQuizAnswers.clear();
            });
          },
          icon: const Icon(Icons.psychology_alt, color: Colors.black, size: 18),
          label: Text(
            "TAKE COGNITIVE ASSESSMENT QUIZ",
            style: GoogleFonts.orbitron(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25),

        Text(
          "OR MANUALLY SELECT MINDSET",
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
"""
content = content.replace("""        Text(
          "CHOOSE MOTIVATIONAL MINDSET",
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),""", button_code)


# 3. Add overlay to build
overlay_code = """              if (_showingQuiz)
                Positioned.fill(child: _buildQuizOverlay(themeColor)),
              if (_showingMindsetQuiz)
                Positioned.fill(child: _buildMindsetQuizOverlay(themeColor)),"""
content = content.replace("""              if (_showingQuiz)
                Positioned.fill(child: _buildQuizOverlay(themeColor)),""", overlay_code)

# 4. Add Mindset quiz overlay and logic
mindset_logic = r"""
  Widget _buildMindsetQuizOverlay(Color themeColor) {
    final q = _mindsetQuizQuestions[_currentMindsetQuizQuestionIdx];
    return Container(
      color: const Color(0xFF090D16),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "COGNITIVE ASSESSMENT",
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Question ${_currentMindsetQuizQuestionIdx + 1} of ${_mindsetQuizQuestions.length}",
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              q.questionText,
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate(q.options.length, (idx) {
            final opt = q.options[idx];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mindsetQuizAnswers.add(opt.elementIndex);
                    if (_currentMindsetQuizQuestionIdx < _mindsetQuizQuestions.length - 1) {
                      _currentMindsetQuizQuestionIdx++;
                    } else {
                      _calculateMindsetQuizResult();
                      _showMindsetQuizCompleteDialog();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  opt.text,
                  style: GoogleFonts.exo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _showingMindsetQuiz = false;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "CANCEL QUIZ",
              style: GoogleFonts.orbitron(
                fontSize: 11,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calculateMindsetQuizResult() {
    final Map<int, int> counts = {0: 0, 1: 0, 2: 0, 3: 0};
    for (final index in _mindsetQuizAnswers) {
      counts[index] = (counts[index] ?? 0) + 1;
    }
    int bestIndex = 0;
    int maxCount = -1;
    counts.forEach((key, val) {
      if (val > maxCount) {
        maxCount = val;
        bestIndex = key;
      }
    });
    setState(() {
      if (bestIndex == 0) _selectedProfile = CognitiveProfile.adhd;
      else if (bestIndex == 1) _selectedProfile = CognitiveProfile.autistic;
      else if (bestIndex == 2) _selectedProfile = CognitiveProfile.audhd;
      else _selectedProfile = CognitiveProfile.neurotypical;
      _showingMindsetQuiz = false;
    });
  }

  void _showMindsetQuizCompleteDialog() {
    String profileName = "";
    if (_selectedProfile == CognitiveProfile.adhd) profileName = "Hunter (ADHD)";
    else if (_selectedProfile == CognitiveProfile.autistic) profileName = "Vanguard (Autistic)";
    else if (_selectedProfile == CognitiveProfile.audhd) profileName = "Revenant (AuDHD)";
    else profileName = "Warrior (Neurotypical)";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(
          "ASSESSMENT COMPLETE",
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Your responses suggest you belong to the $profileName cognitive archetype!\n\nThis profile has been automatically selected for you.",
          style: GoogleFonts.exo2(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "ACCEPT",
              style: GoogleFonts.orbitron(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }
"""

content = content.replace('  Widget _buildGoalsScreen(Color themeColor, UserProfileManager profile) {', mindset_logic + '\n  Widget _buildGoalsScreen(Color themeColor, UserProfileManager profile) {')

# 5. Add Questions to bottom
questions_code = """
  static final List<QuizQuestion> _mindsetQuizQuestions = [
    QuizQuestion(
      questionText: "How do you prefer to handle your daily routine?",
      options: [
        QuizOption(text: "I crave novelty and get bored easily without variety.", elementIndex: 0),
        QuizOption(text: "I need strict structure, clear rules, and predictability.", elementIndex: 1),
        QuizOption(text: "I need structure to function, but resent being forced into it.", elementIndex: 2),
        QuizOption(text: "I like building habits step-by-step and sticking to them.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "What motivates you most to exercise?",
      options: [
        QuizOption(text: "Instant gratification, quick challenges, and gamified loot.", elementIndex: 0),
        QuizOption(text: "Seeing detailed analytics, charts, and checking off boxes.", elementIndex: 1),
        QuizOption(text: "Having a solid plan, but with flexible choices so I don't feel trapped.", elementIndex: 2),
        QuizOption(text: "Seeing a long streak build up and hitting long-term milestones.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "When faced with a workout you don't want to do, you...",
      options: [
        QuizOption(text: "Get distracted and skip it unless it sounds exciting right now.", elementIndex: 0),
        QuizOption(text: "Do it anyway because it's on the schedule, even if I hate it.", elementIndex: 1),
        QuizOption(text: "Experience intense demand avoidance and need an alternative option.", elementIndex: 2),
        QuizOption(text: "Rely on my discipline and habit loops to get through it.", elementIndex: 3),
      ],
    ),
  ];
"""
content = content.replace('  static final List<QuizQuestion> _quizQuestions = [', questions_code + '\n  static final List<QuizQuestion> _quizQuestions = [')

with open('lib/views/psych_evaluation_view.dart', 'w') as f:
    f.write(content)
