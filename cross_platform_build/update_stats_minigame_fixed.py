# 2. Add the Trials section build method and trial logic
trials_logic = r"""
  Widget _buildTrialsSection(UserProfileManager profile, Color themeColor) {
    final trials = [
      {"name": "Lift the Fallen Debris", "stat": "Strength", "desc": "A collapsed structure traps survivors. Use your raw power.", "dc": 14},
      {"name": "Navigate the Asteroid Field", "stat": "Dexterity", "desc": "Pilot your craft through a dense field of space debris.", "dc": 16},
      {"name": "Endure the Toxic Fumes", "stat": "Constitution", "desc": "A biological leak tests your stamina and resilience.", "dc": 15},
      {"name": "Hack the Mainframe", "stat": "Intelligence", "desc": "Bypass the cyber security of a rogue drone.", "dc": 16},
      {"name": "Track the Invisible Beast", "stat": "Wisdom", "desc": "Use your intuition and senses to find the hidden threat.", "dc": 14},
      {"name": "Negotiate with Smugglers", "stat": "Charisma", "desc": "Convince the black market dealers to lower their prices.", "dc": 15},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "ORACLE STAT TRIALS (MINI-GAMES)",
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: trials.map((t) {
              final String statName = t["stat"] as String;
              final int dc = t["dc"] as int;

              int statValue = 10;
              switch (statName) {
                case "Strength": statValue = profile.stats.strength; break;
                case "Dexterity": statValue = profile.stats.dexterity; break;
                case "Constitution": statValue = profile.stats.constitution; break;
                case "Intelligence": statValue = profile.stats.intelligence; break;
                case "Wisdom": statValue = profile.stats.wisdom; break;
                case "Charisma": statValue = profile.stats.charisma; break;
              }
              final mod = ((statValue - 10) / 2).floor();
              final modStr = mod >= 0 ? "+$mod" : "$mod";

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            t["name"] as String,
                            style: GoogleFonts.exo2(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "DC $dc",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t["desc"] as String,
                      style: GoogleFonts.exo2(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _rollTrial(context, profile, t["name"] as String, statName, mod, dc, themeColor),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "ROLL $statName ($modStr)",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _rollTrial(BuildContext context, UserProfileManager profile, String trialName, String statName, int mod, int dc, Color themeColor) {
    import_math.Random rand = import_math.Random();
    int roll = rand.nextInt(20) + 1;
    int total = roll + mod;
    bool success = total >= dc;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F0F0F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: themeColor.withValues(alpha: 0.3)),
          ),
          title: Text(
            success ? "TRIAL SUCCESS" : "TRIAL FAILED",
            style: GoogleFonts.orbitron(
              color: success ? themeColor : Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Rolled a d20: $roll",
                style: GoogleFonts.exo2(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Modifier ($statName): $mod",
                style: GoogleFonts.exo2(color: Colors.white70, fontSize: 14),
              ),
              const Divider(color: Colors.white24, height: 24),
              Text(
                "Total: $total",
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Target DC: $dc",
                style: GoogleFonts.exo2(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              if (success)
                Text(
                  "You overcome the challenge with your $statName!\\n\\n+5 Crystals earned.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              else
                Text(
                  "Your $statName wasn't high enough this time. Train more and try again later.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (success) {
                  profile.addCrystals(5);
                }
              },
              child: Text(
                "CONTINUE",
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
"""


def transform(content: str) -> str:
    content = content.replace('["Stats", "Badges"]', '["Stats", "Badges", "Trials"]')
    content = content.replace('  Widget _buildBadgesSection(UserProfileManager profile, Color themeColor) {', trials_logic + '\n  Widget _buildBadgesSection(UserProfileManager profile, Color themeColor) {')
    content = "import 'dart:math' as import_math;\n" + content
    content = content.replace("""                  ] else if (_selectedTab == "Badges") ...[
                    _buildBadgesSection(profile, themeColor),
                  ],""", """                  ] else if (_selectedTab == "Badges") ...[
                    _buildBadgesSection(profile, themeColor),
                  ] else if (_selectedTab == "Trials") ...[
                    _buildTrialsSection(profile, themeColor),
                  ],""")
    return content


def main() -> None:
    path = "lib/views/character_stats_view.dart"
    with open(path) as f:
        content = f.read()
    content = transform(content)
    with open(path, "w") as f:
        f.write(content)


if __name__ == "__main__":
    main()
