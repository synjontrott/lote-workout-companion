import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class PsychEvaluationView extends StatefulWidget {
  const PsychEvaluationView({super.key});

  @override
  State<PsychEvaluationView> createState() => _PsychEvaluationViewState();
}

class _PsychEvaluationViewState extends State<PsychEvaluationView> {
  // Onboarding steps:
  // 0: Identity (Name, Planet, Element Theme)
  // 1: Mindset (Motivational Profile, Focuses)
  // 2: Vessel (Metrics)
  int _onboardingStep = 0;

  // Identity states
  late final TextEditingController _nameController;
  String _selectedPlanet = "Warrion";
  int _tempElementIdx = 0;

  // Element Quiz states
  bool _showingQuiz = false;
  int _currentQuizQuestionIdx = 0;
  final List<int> _quizAnswers = [];

  // Mindset states
  CognitiveProfile _selectedProfile = CognitiveProfile.neurotypical;
  final Set<TrainingFocus> _tempSelectedFocuses = {
    TrainingFocus.calisthenics,
    TrainingFocus.cardio,
    TrainingFocus.cutting,
  };

  // Metric controllers
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
    _nameController = TextEditingController(text: "Warrior");
    
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
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _legsController.dispose();
    super.dispose();
  }

  void _confirmProfile(UserProfileManager profile) {
    profile.characterName = _nameController.text;
    profile.homePlanet = _selectedPlanet;
    profile.selectedElementIndex = _tempElementIdx;
    profile.cognitiveProfile = _selectedProfile;
    profile.selectedFocuses = _tempSelectedFocuses.toList();
    profile.height = double.tryParse(_heightController.text) ?? 70.0;
    profile.weight = double.tryParse(_weightController.text) ?? 160.0;
    profile.chest = double.tryParse(_chestController.text) ?? 38.0;
    profile.arms = double.tryParse(_armsController.text) ?? 13.0;
    profile.waist = double.tryParse(_waistController.text) ?? 32.0;
    profile.hips = double.tryParse(_hipsController.text) ?? 40.0;
    profile.legs = double.tryParse(_legsController.text) ?? 22.0;
    
    profile.resetProgress();
    profile.hasCompletedInitialQuiz = true;
  }


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final themeColor = UserProfileManager.availableElements[_tempElementIdx].primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Wizard Progress Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final active = index <= _onboardingStep;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active ? themeColor : Colors.white10,
                          ),
                        );
                      }),
                    ),
                  ),

                  // Scrollable Screen Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStepContent(themeColor, profile),
                    ),
                  ),
                ],
              ),
              if (_showingQuiz)
                Positioned.fill(
                  child: _buildQuizOverlay(themeColor),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(Color themeColor, UserProfileManager profile) {
    if (_onboardingStep == 0) {
      return _buildIdentityScreen(themeColor);
    } else if (_onboardingStep == 1) {
      return _buildMindsetScreen(themeColor);
    } else {
      return _buildVesselScreen(themeColor, profile);
    }
  }

  // MARK: - Identity Screen (Step 0)
  Widget _buildIdentityScreen(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text(
          "WARRIOR ORIGINS",
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Phase 1: Define name, planet, and element alignment",
          textAlign: TextAlign.center,
          style: GoogleFonts.exo2(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 25),

        // Textfields
        _buildTextField("CHARACTER NAME", _nameController, TextInputType.name),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "HOME PLANET",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Theme(
              data: Theme.of(context).copyWith(canvasColor: const Color(0xFF0F0F0F)),
              child: DropdownButtonFormField<String>(
                value: _selectedPlanet,
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                ),
                items: ["Ninjonia", "Techno", "Warrion", "Battacaria"]
                    .map((planet) => DropdownMenuItem(
                          value: planet,
                          child: Text(planet.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPlanet = val;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),

        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _showingQuiz = true;
              _currentQuizQuestionIdx = 0;
              _quizAnswers.clear();
            });
          },
          icon: const Icon(Icons.psychology, color: Colors.black, size: 18),
          label: Text(
            "TAKE ELEMENTAL INITIATION QUIZ",
            style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 25),

        Text(
          "SELECT ELEMENTAL ALIGNMENT",
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),

        // Element aligning cards
        ...List.generate(UserProfileManager.availableElements.length, (idx) {
          final el = UserProfileManager.availableElements[idx];
          final isSelected = _tempElementIdx == idx;

          return InkWell(
            onTap: () {
              setState(() {
                _tempElementIdx = idx;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? el.primaryColor.withOpacity(0.5) : Colors.white.withOpacity(0.05),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                   Text(
                     el.name == "Fire" ? "🔥" : el.name == "Water" ? "💧" : el.name == "Earth" ? "🪨" : "💨",
                     style: const TextStyle(fontSize: 20),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           el.name.toUpperCase(),
                           style: GoogleFonts.orbitron(
                             fontSize: 13,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                         Text(
                           el.description,
                           style: GoogleFonts.exo2(
                             fontSize: 10,
                             color: Colors.grey,
                           ),
                         ),
                       ],
                     ),
                   ),
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? el.primaryColor : Colors.grey,
                    size: 18,
                  )
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _onboardingStep = 1;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            "NEXT PHASE",
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // MARK: - Mindset Screen (Step 1)
  Widget _buildMindsetScreen(Color themeColor) {
    final profiles = [
      CognitiveProfile.neurotypical,
      CognitiveProfile.adhd,
      CognitiveProfile.autistic,
      CognitiveProfile.audhd,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text(
          "COGNITIVE ARCHETYPE",
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Phase 2: Select mindset profile & workout focuses",
          textAlign: TextAlign.center,
          style: GoogleFonts.exo2(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 25),

        Text(
          "CHOOSE MOTIVATIONAL MINDSET",
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),

        // Direct profile picker
        ...profiles.map((cp) {
          final isSelected = _selectedProfile == cp;
          String displayName = cp == CognitiveProfile.neurotypical
              ? "Neurotypical"
              : (cp == CognitiveProfile.adhd ? "ADHD" : (cp == CognitiveProfile.autistic ? "Autism" : "AuDHD"));

          return InkWell(
            onTap: () {
              setState(() {
                _selectedProfile = cp;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? themeColor.withOpacity(0.5) : Colors.white.withOpacity(0.05),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.orbitron(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cp.title,
                          style: GoogleFonts.orbitron(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cp.description,
                    style: GoogleFonts.exo2(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),

        Text(
          "SELECT TRAINING OBJECTIVES",
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),

        // Focuses Choices
        ...TrainingFocus.values.map((focus) {
          final isSelected = _tempSelectedFocuses.contains(focus);
          return CheckboxListTile(
            title: Text(
              focus.name[0].toUpperCase() + focus.name.substring(1),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            value: isSelected,
            activeColor: themeColor,
            checkColor: Colors.black,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _tempSelectedFocuses.add(focus);
                } else {
                  _tempSelectedFocuses.remove(focus);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),

        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _onboardingStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "BACK",
                  style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _onboardingStep = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "NEXT PHASE",
                  style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // MARK: - Vessel Screen (Step 2)
  Widget _buildVesselScreen(Color themeColor, UserProfileManager profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text(
          "THE PHYSICAL VESSEL",
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Phase 3: Input initial body metrics to track progress",
          textAlign: TextAlign.center,
          style: GoogleFonts.exo2(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(child: _buildTextField("HEIGHT (INCHES)", _heightController, TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField("WEIGHT (LBS)", _weightController, TextInputType.number)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField("CHEST (INCHES)", _chestController, TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField("ARMS (INCHES)", _armsController, TextInputType.number)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField("WAIST (INCHES)", _waistController, TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField("HIPS (INCHES)", _hipsController, TextInputType.number)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField("LEGS (INCHES)", _legsController, TextInputType.number),

        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _onboardingStep = 1;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "BACK",
                  style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _confirmProfile(profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "COMMENCE",
                  style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check, color: Colors.green, size: 16),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizOverlay(Color themeColor) {
    final q = _quizQuestions[_currentQuizQuestionIdx];
    return Container(
      color: const Color(0xFF090D16),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "ELEMENTAL INITIATION QUIZ",
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
            "Question ${_currentQuizQuestionIdx + 1} of ${_quizQuestions.length}",
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                    _quizAnswers.add(opt.elementIndex);
                    if (_currentQuizQuestionIdx < _quizQuestions.length - 1) {
                      _currentQuizQuestionIdx++;
                    } else {
                      _calculateQuizResult();
                      _showQuizCompleteDialog();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.04),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.08)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  opt.text,
                  style: GoogleFonts.exo2(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _showingQuiz = false;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              "CANCEL QUIZ",
              style: GoogleFonts.orbitron(fontSize: 11, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _calculateQuizResult() {
    final Map<int, int> counts = {0: 0, 1: 0, 2: 0, 3: 0};
    for (final index in _quizAnswers) {
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
      _tempElementIdx = bestIndex;
      _showingQuiz = false;
    });
  }

  void _showQuizCompleteDialog() {
    final elName = UserProfileManager.availableElements[_tempElementIdx].name;
    final emoji = elName == "Fire" ? "🔥" : elName == "Water" ? "💧" : elName == "Earth" ? "🪨" : "💨";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        title: Text("QUIZ COMPLETE", style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          "The Elsaither energy in your responses aligns with the element of $elName $emoji!\n\nThis element has been automatically selected for you.",
          style: GoogleFonts.exo2(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("COMMENCE", style: GoogleFonts.orbitron(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  static final List<QuizQuestion> _quizQuestions = [
    QuizQuestion(
      questionText: "What color spectrum calls to your inner energy?",
      options: [
        QuizOption(text: "Crimson Red & Flame Orange (Fire)", elementIndex: 0),
        QuizOption(text: "Deep Blue & Aquamarine (Water)", elementIndex: 1),
        QuizOption(text: "Earthy Brown & Emerald Green (Earth)", elementIndex: 2),
        QuizOption(text: "Sky Blue & Cloud White (Air)", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "How do you naturally respond to direct adversity?",
      options: [
        QuizOption(text: "Confront it with intense, direct passion.", elementIndex: 0),
        QuizOption(text: "Adapt and flow around the obstacle.", elementIndex: 1),
        QuizOption(text: "Stand firm and absorb the impact with resilience.", elementIndex: 2),
        QuizOption(text: "Rise above it to find a clever alternative route.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "Where do you feel most at peace and energized?",
      options: [
        QuizOption(text: "Near a roaring bonfire or under the baking sun.", elementIndex: 0),
        QuizOption(text: "Beside a rushing river, lake, or in a rainstorm.", elementIndex: 1),
        QuizOption(text: "Walking in a dense forest or on solid mountain soil.", elementIndex: 2),
        QuizOption(text: "Standing on a breezy cliff looking at open skies.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "What is your primary training style or preference?",
      options: [
        QuizOption(text: "High-intensity bursts that test speed and determination.", elementIndex: 0),
        QuizOption(text: "Smooth, flowing workouts like swimming or cycling.", elementIndex: 1),
        QuizOption(text: "Heavy strength training and solid ground lifts.", elementIndex: 2),
        QuizOption(text: "Calisthenics, mobility drills, and agile movement.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "Which character trait is your greatest asset?",
      options: [
        QuizOption(text: "Burning passion and drive.", elementIndex: 0),
        QuizOption(text: "Calm, intuitive adaptability.", elementIndex: 1),
        QuizOption(text: "Steadfast patience and strength.", elementIndex: 2),
        QuizOption(text: "Quick-witted curiosity and agility.", elementIndex: 3),
      ],
    ),
    QuizQuestion(
      questionText: "In a team battle, what role do you naturally choose?",
      options: [
        QuizOption(text: "Vanguard - leading the charge with power.", elementIndex: 0),
        QuizOption(text: "Tactical support - healing and maintaining flow.", elementIndex: 1),
        QuizOption(text: "Defender - protecting allies from attacks.", elementIndex: 2),
        QuizOption(text: "Scout - moving swiftly to disrupt the enemy.", elementIndex: 3),
      ],
    ),
  ];
}

class QuizQuestion {
  final String questionText;
  final List<QuizOption> options;
  QuizQuestion({required this.questionText, required this.options});
}

class QuizOption {
  final String text;
  final int elementIndex;
  QuizOption({required this.text, required this.elementIndex});
}

