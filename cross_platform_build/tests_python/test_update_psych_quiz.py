import update_psych_quiz as mod  # import must have no side effects

P1 = "  // Mindset states"
P2 = '        Text(\n          "CHOOSE MOTIVATIONAL MINDSET",\n          style: GoogleFonts.orbitron(\n            fontSize: 11,\n            fontWeight: FontWeight.bold,\n            color: Colors.grey,\n            letterSpacing: 2,\n          ),\n        ),\n        const SizedBox(height: 10),'
P3 = "              if (_showingQuiz)\n                Positioned.fill(child: _buildQuizOverlay(themeColor)),"
P4 = "  Widget _buildGoalsScreen(Color themeColor, UserProfileManager profile) {"
P5 = "  static final List<QuizQuestion> _quizQuestions = ["
BEFORE = "\n".join([P1, P2, P3, P4, P5]) + "\n"


def test_mindset_quiz_injected():
    out = mod.transform(BEFORE)
    assert "bool _showingMindsetQuiz = false;" in out                          # step 1
    assert "TAKE COGNITIVE ASSESSMENT QUIZ" in out                             # step 2
    assert "Positioned.fill(child: _buildMindsetQuizOverlay(themeColor))" in out  # step 3
    assert "void _calculateMindsetQuizResult() {" in out                       # step 4
    assert "static final List<QuizQuestion> _mindsetQuizQuestions = [" in out  # step 5


def test_noop_without_patterns():
    src = "// unrelated\n"
    assert mod.transform(src) == src
