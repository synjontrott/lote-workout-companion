import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class PsychQuestion {
  final String text;
  final List<PsychOption> options;
  const PsychQuestion({required this.text, required this.options});
}

class PsychOption {
  final String text;
  final int adhdWeight;
  final int autisticWeight;
  final int audhdWeight;
  final int ntWeight;

  const PsychOption({
    required this.text,
    required this.adhdWeight,
    required this.autisticWeight,
    required this.audhdWeight,
    required this.ntWeight,
  });
}

class PsychEvaluationView extends StatefulWidget {
  const PsychEvaluationView({super.key});

  @override
  State<PsychEvaluationView> createState() => _PsychEvaluationViewState();
}

class _PsychEvaluationViewState extends State<PsychEvaluationView> {
  int _currentQuestionIndex = 0;
  final List<int> _answers = []; // Selected indices

  int _adhdScore = 0;
  int _autisticScore = 0;
  int _audhdScore = 0;
  int _ntScore = 0;
  bool _evaluationComplete = false;
  CognitiveProfile _calculatedProfile = CognitiveProfile.neurotypical;

  // Onboarding wizard phases
  int _onboardingStep = 0;
  final Set<TrainingFocus> _tempSelectedFocuses = {
    TrainingFocus.calisthenics,
    TrainingFocus.cardio,
    TrainingFocus.cutting,
  };

  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _chestController;
  late final TextEditingController _armsController;
  late final TextEditingController _waistController;
  late final TextEditingController _hipsController;
  late final TextEditingController _legsController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: "70.0");
    _weightController = TextEditingController(text: "160.0");
    _chestController = TextEditingController(text: "38.0");
    _armsController = TextEditingController(text: "13.0");
    _waistController = TextEditingController(text: "32.0");
    _hipsController = TextEditingController(text: "40.0");
    _legsController = TextEditingController(text: "22.0");
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _legsController.dispose();
    super.dispose();
  }

  final List<PsychQuestion> _questions = const [
    PsychQuestion(
      text: "How do you feel about long-term workout routines?",
      options: [
        PsychOption(
            text: "I thrive when I have a fixed, structured schedule that repeats exactly every week.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "I need constant variety. Repeating the same workout twice makes me lose focus immediately.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
        PsychOption(
            text: "I like having a structured schedule, but I need flexible wildcard options within it to stay motivated.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
        PsychOption(
            text: "A standard, progressive routine works well for me to build healthy habits.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "When starting a workout, what is your biggest executive barrier?",
      options: [
        PsychOption(
            text: "Starting is incredibly hard unless there is immediate novelty or a high-energy reward.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "Any unexpected disruption in my day's timeline completely derails my training momentum.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 0),
        PsychOption(
            text: "I get overwhelmed by choices, but I also push back when I feel 'forced' to follow a rigid script.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "Just building the regular habit and pushing through the initial resistance.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "How do you prefer to review your fitness achievements?",
      options: [
        PsychOption(
            text: "Detailed graphs, precise calorie and step counts, and complete database logs.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "Gamified level-ups, crystal drops, virtual dice rolls, and custom pixel-art rewards.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
        PsychOption(
            text: "A hybrid: detailed analytics for security, but game-like drops to keep things exciting.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
        PsychOption(
            text: "Simple daily streaks and progressive, long-term milestones.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "How does the training environment's sensory layout affect you?",
      options: [
        PsychOption(
            text: "Loud music, bright lights, or crowds easily exhaust me. I need a controlled, quiet space.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "I get under-stimulated. I need high-energy music, podcasts, or screens to distract my mind.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "I need active stimulation (music) but easily get overloaded if the environment is chaotic.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "I can tune out gym noise and focus on my workout without much issue.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "What style of workout instruction works best for you?",
      options: [
        PsychOption(
            text: "Literal, direct, step-by-step guides with logical explanations of the biology/science.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "Story-driven roleplaying quests where my exercise represents patrolling or battling beasties.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "Clear options where I have autonomy to pick between 3 distinct paths.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
        PsychOption(
            text: "Practical guides that display correct form and progressive difficulty reps.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "What happens when you miss a planned training day?",
      options: [
        PsychOption(
            text: "I feel intense distress or guilt. The routine is broken, and it's very hard to restart.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "I completely lose track of the goal and get swept up in a new, hyper-focused interest.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
        PsychOption(
            text: "I experience rule-break anxiety but also struggle to re-engage due to executive burnout.",
            adhdWeight: 1, autisticWeight: 2, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "I view it as a minor setback and aim to stack the habit back up tomorrow.",
            adhdWeight: 0, autisticWeight: 0, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "How do you approach your daily dietary habits?",
      options: [
        PsychOption(
            text: "I eat the same comfortable, predictable meals regularly (comfortable safe foods).",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "I crave intense variety in flavors, textures, and spices. Repetitive food bores me.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "I have standard safe foods, but I occasionally need highly intense spice/sensory variety.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "I plan my meals based on balanced, standard nutritional guidelines.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "When exercising, how does your attention flow operate?",
      options: [
        PsychOption(
            text: "I hyper-focus on my movement, count, or metrics, completely zoning out external sounds.",
            adhdWeight: 1, autisticWeight: 3, audhdWeight: 2, ntWeight: 1),
        PsychOption(
            text: "My mind drifts constantly. I need to be playing mental games or listening to engaging podcasts.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
        PsychOption(
            text: "My focus shifts rapidly unless I am in a state of high interest or gamified pressure.",
            adhdWeight: 2, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "I maintain steady, standard focus on finishing my workout sets.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "How do you approach short and long-term goal setting?",
      options: [
        PsychOption(
            text: "I need a structured, long-term path clearly detailed with timelines and checklists.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "I need immediate micro-goals (what I'm doing in the next 5 minutes) or I lose interest.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "I need structured goals, but they must be modular so I can swap them based on my daily energy.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
        PsychOption(
            text: "I work best with classic monthly targets and simple habits.",
            adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3),
      ],
    ),
    PsychQuestion(
      text: "How do you react to sudden, unexpected changes in your environment?",
      options: [
        PsychOption(
            text: "I feel very stressed. I need preparation time, warnings, and direct routines.",
            adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
        PsychOption(
            text: "I welcome changes; they provide a stimulating sensory reboot.",
            adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
        PsychOption(
            text: "It triggers demand avoidance, but I can adapt if I am given autonomy over options.",
            adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
        PsychOption(
            text: "I adjust relatively easily without major cognitive stress.",
            adhdWeight: 0, autisticWeight: 0, audhdWeight: 0, ntWeight: 3),
      ],
    )
  ];
 
  void _selectOption(int index) {
    setState(() {
      _answers.add(index);
      final option = _questions[_currentQuestionIndex].options[index];
 
      _adhdScore += option.adhdWeight;
      _autisticScore += option.autisticWeight;
      _audhdScore += option.audhdWeight;
      _ntScore += option.ntWeight;
 
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex += 1;
      } else {
        _calculateProfileResult();
      }
    });
  }
 
  void _goBack() {
    if (_answers.isEmpty) return;
    setState(() {
      final lastAnswerIndex = _answers.removeLast();
      final option = _questions[_currentQuestionIndex - 1].options[lastAnswerIndex];
 
      _adhdScore -= option.adhdWeight;
      _autisticScore -= option.autisticWeight;
      _audhdScore -= option.audhdWeight;
      _ntScore -= option.ntWeight;
 
      _currentQuestionIndex -= 1;
    });
  }
 
  void _calculateProfileResult() {
    final maxWeight = [
      _adhdScore,
      _autisticScore,
      _audhdScore,
      _ntScore
    ].reduce((a, b) => a > b ? a : b);
 
    if (maxWeight == _adhdScore) {
      _calculatedProfile = CognitiveProfile.adhd;
    } else if (maxWeight == _autisticScore) {
      _calculatedProfile = CognitiveProfile.autistic;
    } else if (maxWeight == _audhdScore) {
      _calculatedProfile = CognitiveProfile.audhd;
    } else {
      _calculatedProfile = CognitiveProfile.neurotypical;
    }
 
    // Default to AuDHD if both are extremely high
    if (_adhdScore > 10 && _autisticScore > 10) {
      _calculatedProfile = CognitiveProfile.audhd;
    }
 
    _evaluationComplete = true;
  }
 
  void _confirmProfile(UserProfileManager manager) {
    manager.cognitiveProfile = _calculatedProfile;
    manager.selectedFocuses = _tempSelectedFocuses.toList();
    manager.height = double.tryParse(_heightController.text) ?? 70.0;
    manager.weight = double.tryParse(_weightController.text) ?? 160.0;
    manager.chest = double.tryParse(_chestController.text) ?? 38.0;
    manager.arms = double.tryParse(_armsController.text) ?? 13.0;
    manager.waist = double.tryParse(_waistController.text) ?? 32.0;
    manager.hips = double.tryParse(_hipsController.text) ?? 40.0;
    manager.legs = double.tryParse(_legsController.text) ?? 22.0;
    manager.hasCompletedInitialQuiz = true;
  }

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<UserProfileManager>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Ambient thematic glows
          Positioned(
            left: -50,
            top: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF1616).withOpacity(0.12),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1541701494587-cb58502866ab?q=80&w=1000',
                errorBuilder: (_, __, ___) => const SizedBox(),
                color: Colors.black.withOpacity(0.9),
                colorBlendMode: BlendMode.dstIn,
              ),
            ),
          ),
          Positioned(
            right: -50,
            bottom: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3F51B5).withOpacity(0.12),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: !_evaluationComplete
                      ? _buildQuizScreen()
                      : _buildResultScreen(profileManager),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = _currentQuestionIndex / _questions.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header
        Text(
          "SOVEREIGN ARCHETYPE TEST",
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Phase 1: Cognitive Fitness Evaluation",
          style: GoogleFonts.exo2(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: const Color(0xFFFF1616),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF1616)),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 30),
        // Question Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFFF1616).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "QUESTION ${_currentQuestionIndex + 1} OF ${_questions.length}",
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                currentQuestion.text,
                style: GoogleFonts.exo2(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              // Options
              Column(
                children: List.generate(currentQuestion.options.length, (idx) {
                  final option = currentQuestion.options[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _selectOption(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: GoogleFonts.exo2(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFFFF1616),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Go Back Button
        if (_currentQuestionIndex > 0)
          TextButton(
            onPressed: _goBack,
            child: Text(
              "Go Back",
              style: GoogleFonts.exo2(
                fontSize: 13,
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultScreen(UserProfileManager profileManager) {
    if (_onboardingStep == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 60,
            color: Color(0xFFFF1616),
          ),
          const SizedBox(height: 25),
          Text(
            "DESTINY AWAKENED",
            style: GoogleFonts.orbitron(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Your elemental mind type is calibrated.",
            style: GoogleFonts.exo2(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Destiny Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFFF1616).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _calculatedProfile.title,
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFFFF1616),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _calculatedProfile.description,
                  style: GoogleFonts.exo2(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _onboardingStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1616),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              shadowColor: const Color(0xFFFF1616).withOpacity(0.4),
            ),
            child: Text(
              "CONTINUE TO GOALS",
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else if (_onboardingStep == 1) {
      // Focuses Selection Screen
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "TRAINING FOCUSES",
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Select your primary training focus objectives.",
            style: GoogleFonts.exo2(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Column(
            children: TrainingFocus.values.map((focus) {
              final isSelected = _tempSelectedFocuses.contains(focus);
              final desc = _getTrainingFocusDesc(focus);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _tempSelectedFocuses.remove(focus);
                      } else {
                        _tempSelectedFocuses.add(focus);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFF1616).withOpacity(0.08)
                          : Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFF1616)
                            : Colors.white.withOpacity(0.1),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                focus.displayName,
                                style: GoogleFonts.exo2(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                desc,
                                style: GoogleFonts.exo2(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? const Color(0xFFFF1616) : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _tempSelectedFocuses.isEmpty
                ? null
                : () {
                    setState(() {
                      _onboardingStep = 2;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1616),
              disabledBackgroundColor: const Color(0xFFFF1616).withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              shadowColor: const Color(0xFFFF1616).withOpacity(0.4),
            ),
            child: Text(
              "CONTINUE TO METRICS",
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      // Body Metrics Input Screen
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "INITIAL BODY METRICS",
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Input your starting numbers to log precise progress.",
            style: GoogleFonts.exo2(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _buildMetricInputField("HEIGHT (INCHES)", _heightController)),
              const SizedBox(width: 15),
              Expanded(child: _buildMetricInputField("WEIGHT (LBS)", _weightController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricInputField("CHEST (INCHES)", _chestController)),
              const SizedBox(width: 15),
              Expanded(child: _buildMetricInputField("ARMS (INCHES)", _armsController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricInputField("WAIST (INCHES)", _waistController)),
              const SizedBox(width: 15),
              Expanded(child: _buildMetricInputField("HIPS (INCHES)", _hipsController)),
            ],
          ),
          const SizedBox(height: 16),
          _buildMetricInputField("LEGS (INCHES)", _legsController),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () => _confirmProfile(profileManager),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1616),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              shadowColor: const Color(0xFFFF1616).withOpacity(0.4),
            ),
            child: Text(
              "COMMENCE TRAINING",
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  String _getTrainingFocusDesc(TrainingFocus focus) {
    switch (focus) {
      case TrainingFocus.calisthenics:
        return "Gravity-defying pull-ups, push-ups, and dips.";
      case TrainingFocus.lifting:
        return "Forge raw muscle with squat, bench, and deadlifts.";
      case TrainingFocus.weightGain:
        return "Build structural mass and dense weight support.";
      case TrainingFocus.cutting:
        return "Deficit conditioning to burn off excess layers.";
      case TrainingFocus.flexibility:
        return "Flexible joint flow and muscle lengthening.";
      case TrainingFocus.cardio:
        return "Conditioning, endurance walks, and swift runs.";
    }
  }

  Widget _buildMetricInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.exo2(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.orbitron(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF1616)),
            ),
          ),
        ),
      ],
    );
  }
}
