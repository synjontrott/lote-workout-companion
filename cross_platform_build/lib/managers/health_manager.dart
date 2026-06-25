import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthManager extends ChangeNotifier {
  bool _isAuthorized = false;
  double _todaySteps = 0.0;
  double _todayCalories = 0.0;
  double _activeMinutes = 0.0;
  double _todayStandHours = 0.0;

  bool get isAuthorized => _isAuthorized;
  double get todaySteps => _todaySteps;
  double get todayCalories => _todayCalories;
  double get activeMinutes => _activeMinutes;
  double get todayStandHours => _todayStandHours;

  HealthManager() {
    // Check if health data is available and request initial check
  }

  Future<void> requestAuthorization() async {
    final health = Health();

    // Define data types
    final List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    try {
      // Check permissions
      bool requested = await health.requestAuthorization(types);
      _isAuthorized = requested;
      if (_isAuthorized) {
        await fetchTodayData();
      }
    } catch (e) {
      debugPrint("Error requesting health authorization: $e");
      _isAuthorized = false;
    }
    notifyListeners();
  }

  Future<void> fetchTodayData() async {
    if (!_isAuthorized) return;

    final health = Health();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      // Fetch steps
      int? steps = await health.getTotalStepsInInterval(startOfDay, now);
      if (steps != null) {
        _todaySteps = steps.toDouble();
      }

      // Fetch calories
      final List<HealthDataType> calorieTypes = [HealthDataType.ACTIVE_ENERGY_BURNED];
      List<HealthDataPoint> dataPoints = await health.getHealthDataFromTypes(
        types: calorieTypes,
        startTime: startOfDay,
        endTime: now,
      );
      double totalCalories = 0.0;
      for (var p in dataPoints) {
        final val = p.value;
        if (val is NumericHealthValue) {
          totalCalories += val.numericValue.toDouble();
        }
      }
      _todayCalories = totalCalories;

      // Estimate active minutes from workouts or steps
      final List<HealthDataType> workoutTypes = [HealthDataType.WORKOUT];
      List<HealthDataPoint> workouts = await health.getHealthDataFromTypes(
        types: workoutTypes,
        startTime: startOfDay,
        endTime: now,
      );
      double workoutMins = 0.0;
      for (var w in workouts) {
        final duration = w.dateTo.difference(w.dateFrom);
        workoutMins += duration.inMinutes.toDouble();
      }
      _activeMinutes = workoutMins > 0 ? workoutMins : (_todaySteps / 100).clamp(0, 100);

      // Fetch/Estimate stand hours
      try {
        final List<HealthDataType> standTypes = [HealthDataType.APPLE_STAND_TIME];
        List<HealthDataPoint> standData = await health.getHealthDataFromTypes(
          types: standTypes,
          startTime: startOfDay,
          endTime: now,
        );
        double totalStand = 0.0;
        for (var p in standData) {
          final val = p.value;
          if (val is NumericHealthValue) {
            totalStand += val.numericValue.toDouble();
          }
        }
        _todayStandHours = totalStand > 0 ? totalStand : (_todaySteps / 1000).clamp(0.0, 24.0);
      } catch (_) {
        _todayStandHours = (_todaySteps / 1000).clamp(0.0, 24.0);
      }

    } catch (e) {
      debugPrint("Error fetching health data: $e");
    }
    notifyListeners();
  }

  void simulateActivity({required double steps, required double calories, required double minutes, double standHours = 0.0}) {
    _todaySteps += steps;
    _todayCalories += calories;
    _activeMinutes += minutes;
    _todayStandHours += standHours;
    notifyListeners();
  }
}
