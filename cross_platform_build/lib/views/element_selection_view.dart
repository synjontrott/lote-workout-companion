import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class ElementSelectionView extends StatefulWidget {
  const ElementSelectionView({super.key});

  @override
  State<ElementSelectionView> createState() => _ElementSelectionViewState();
}

class _ElementSelectionViewState extends State<ElementSelectionView> {
  late int _localElementIndex;
  late ExpressionStyle _localExpression;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileManager>(context, listen: false);
    _localElementIndex = profile.selectedElementIndex;
    _localExpression = profile.expressionStyle;
  }

  LotEElement get _activeElement => UserProfileManager.availableElements[_localElementIndex];

  void _saveSelection(UserProfileManager profile) {
    profile.selectedElementIndex = _localElementIndex;
    profile.expressionStyle = _localExpression;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background ambient glow
          Positioned(
            left: -50,
            top: 20,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _activeElement.primaryColor.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Column(
                  children: [
                    Text(
                      "ELEMENT THEME SELECTION",
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose your elemental theme and stance",
                      style: GoogleFonts.exo2(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Horizontal Elements Scroll
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: UserProfileManager.availableElements.length,
                    itemBuilder: (context, idx) {
                      final elem = UserProfileManager.availableElements[idx];
                      final isSelected = _localElementIndex == idx;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _localElementIndex = idx;
                              if (elem.inherentDark) {
                                _localExpression = ExpressionStyle.corrupt;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? elem.primaryColor : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? elem.accentColor : Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: elem.primaryColor.withOpacity(0.4),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              elem.name.toUpperCase(),
                              style: GoogleFonts.orbitron(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Content scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expression stance select buttons
                        Text(
                          "ELEMENTAL EXPRESSION STANCE",
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: ExpressionStyle.values.map((style) {
                            final isSel = _localExpression == style;
                            final isDisabled = _activeElement.inherentDark && style != ExpressionStyle.corrupt;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: isDisabled
                                      ? null
                                      : () {
                                          setState(() {
                                            _localExpression = style;
                                          });
                                        },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? _activeElement.primaryColor
                                          : Colors.white.withOpacity(0.02),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSel
                                            ? _activeElement.accentColor
                                            : Colors.white.withOpacity(0.08),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      style.displayName,
                                      style: GoogleFonts.exo2(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isSel
                                            ? Colors.white
                                            : (isDisabled ? Colors.white.withOpacity(0.15) : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_activeElement.inherentDark) ...[
                          const SizedBox(height: 8),
                          Text(
                            "⚠️ Tenebrie elements are inherently corruptive. Standard Light alignment is locked by lore.",
                            style: GoogleFonts.exo2(
                              fontSize: 10,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ],
                        const SizedBox(height: 25),

                        // Element Lore Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _activeElement.primaryColor.withOpacity(0.3),
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
                                    _activeElement.displayName(_localExpression).toUpperCase(),
                                    style: GoogleFonts.orbitron(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _activeElement.primaryColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _activeElement.planetOfOrigin.toUpperCase(),
                                      style: GoogleFonts.orbitron(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                _activeElement.description,
                                style: GoogleFonts.exo2(
                                  fontSize: 13.5,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Divider(color: Colors.white10),
                              const SizedBox(height: 10),
                              Text(
                                "STANCE MANIFESTATION",
                                style: GoogleFonts.orbitron(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Builder(
                                builder: (context) {
                                  final stanceText = _localExpression == ExpressionStyle.standard
                                      ? _activeElement.standardDetails
                                      : _localExpression == ExpressionStyle.corrupt
                                          ? _activeElement.corruptDetails
                                          : _activeElement.balancedDetails;
                                  return Text(
                                    stanceText,
                                    style: GoogleFonts.exo2(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.5,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _saveSelection(profile),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _activeElement.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 6,
                              shadowColor: _activeElement.primaryColor.withOpacity(0.4),
                            ),
                            child: Text(
                              "CONFIRM ELEMENT THEME",
                              style: GoogleFonts.orbitron(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
