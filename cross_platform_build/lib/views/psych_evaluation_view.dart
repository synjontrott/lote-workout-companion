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
  late final TextEditingController _planetController;
  int _tempElementIdx = 0;

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
    _planetController = TextEditingController(text: "Warrion");
    
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
    _planetController.dispose();
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
    profile.homePlanet = _planetController.text;
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
          child: Column(
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
        _buildTextField("HOME PLANET", _planetController, TextInputType.name),
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
}
