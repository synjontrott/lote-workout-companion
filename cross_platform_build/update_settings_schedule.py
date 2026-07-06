schedule_ui = """
                          const SizedBox(height: 16),
                          // Flow/Time Scheduling
                          if (profile.cognitiveProfile == CognitiveProfile.adhd || profile.cognitiveProfile == CognitiveProfile.audhd)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ROUTINE FLOW TIME (ADHD/AuDHD)",
                                  style: GoogleFonts.exo2(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.02),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Row(
                                    children: ["Morning", "Afternoon", "Evening"].map((time) {
                                      final isSelected = profile.schedule.flowTime == time;
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              final newSchedule = profile.schedule.copyWith(flowTime: time);
                                              profile.updateSchedule(newSchedule);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isSelected ? themeColor : Colors.transparent,
                                              foregroundColor: isSelected ? Colors.black : Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                            ),
                                            child: Text(time, style: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CONSISTENT WORKOUT TIME",
                                  style: GoogleFonts.exo2(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildAdjustButton(
                                  icon: Icons.access_time,
                                  label: profile.schedule.consistentTime ?? "Set Workout Time",
                                  color: themeColor,
                                  onTap: () async {
                                    final initialTime = TimeOfDay.now();
                                    final TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: initialTime,
                                    );
                                    if (newTime != null) {
                                      final timeStr = newTime.format(context);
                                      final newSchedule = profile.schedule.copyWith(consistentTime: timeStr);
                                      profile.updateSchedule(newSchedule);
                                    }
                                  },
                                ),
                              ],
                            ),

                          const SizedBox(height: 16),
                          // Week Tracker
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WEEK TRACKER (REST DAYS)",
                                style: GoogleFonts.exo2(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.02),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [1, 2, 3, 4, 5, 6, 7].map((day) {
                                    final dayName = ["M", "T", "W", "T", "F", "S", "S"][day - 1];
                                    final isRest = profile.schedule.restDays[day] ?? false;
                                    return GestureDetector(
                                      onTap: () {
                                        final newRestDays = Map<int, bool>.from(profile.schedule.restDays);
                                        newRestDays[day] = !isRest;
                                        final newSchedule = profile.schedule.copyWith(restDays: newRestDays);
                                        profile.updateSchedule(newSchedule);
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isRest ? Colors.transparent : themeColor.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isRest ? Colors.white24 : themeColor,
                                          ),
                                        ),
                                        child: Text(
                                          dayName,
                                          style: GoogleFonts.orbitron(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isRest ? Colors.grey : themeColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
"""


def transform(content: str) -> str:
    content = content.replace(
        "                          // Re-Forge Character Sprite Button",
        schedule_ui + "\n                          // Re-Forge Character Sprite Button",
    )
    return content


def main() -> None:
    path = "lib/views/settings_view.dart"
    with open(path) as f:
        content = f.read()
    content = transform(content)
    with open(path, "w") as f:
        f.write(content)


if __name__ == "__main__":
    main()
