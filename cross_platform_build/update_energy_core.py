target = """                      // MARK: - Energy Activity Gauges
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "ELSAITHER ENERGY CORE",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildMetricGauge(
                              title: "Steps Taken",
                              current: health.todaySteps,
                              target: profile.stepsGoal,
                              unit: "steps",
                              icon: Icons.directions_walk,
                              element: profile.currentElement,
                            ),
                            const SizedBox(height: 12),
                            _buildMetricGauge(
                              title: "Active Energy",
                              current: health.todayCalories,
                              target: profile.caloriesGoal,
                              unit: "kcal",
                              icon: Icons.local_fire_department,
                              element: profile.currentElement,
                            ),
                            const SizedBox(height: 12),
                            _buildMetricGauge(
                              title: "Training Time",
                              current: health.activeMinutes,
                              target: profile.activeMinutesGoal,
                              unit: "mins",
                              icon: Icons.timer,
                              element: profile.currentElement,
                            ),
                            const SizedBox(height: 12),
                            _buildMetricGauge(
                              title: "Stand Hours",
                              current: health.todayStandHours,
                              target: profile.standHoursGoal,
                              unit: "hours",
                              icon: Icons.accessibility_new,
                              element: profile.currentElement,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),"""

replacement = """                      // MARK: - Energy Activity Gauges
                      if (health.isAuthorized) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "ELSAITHER ENERGY CORE",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              if (profile.stepsGoal > 0) ...[
                                _buildMetricGauge(
                                  title: "Steps Taken",
                                  current: health.todaySteps,
                                  target: profile.stepsGoal,
                                  unit: "steps",
                                  icon: Icons.directions_walk,
                                  element: profile.currentElement,
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (profile.caloriesGoal > 0) ...[
                                _buildMetricGauge(
                                  title: "Active Energy",
                                  current: health.todayCalories,
                                  target: profile.caloriesGoal,
                                  unit: "kcal",
                                  icon: Icons.local_fire_department,
                                  element: profile.currentElement,
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (profile.activeMinutesGoal > 0) ...[
                                _buildMetricGauge(
                                  title: "Training Time",
                                  current: health.activeMinutes,
                                  target: profile.activeMinutesGoal,
                                  unit: "mins",
                                  icon: Icons.timer,
                                  element: profile.currentElement,
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (profile.standHoursGoal > 0) ...[
                                _buildMetricGauge(
                                  title: "Stand Hours",
                                  current: health.todayStandHours,
                                  target: profile.standHoursGoal,
                                  unit: "hours",
                                  icon: Icons.accessibility_new,
                                  element: profile.currentElement,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],"""

def transform(content: str) -> str:
    return content.replace(target, replacement)


def main() -> None:
    with open('lib/views/dashboard_view.dart', 'r') as f:
        content = f.read()

    if target not in content:
        print("TARGET NOT FOUND!")

    content = transform(content)

    with open('lib/views/dashboard_view.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
