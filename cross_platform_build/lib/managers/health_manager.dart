import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthManager extends ChangeNotifier {
  bool _isAuthorized = false;
  double _todaySteps = 0.0;
  double _todayCalories = 0.0;
  double _activeMinutes = 0.0;
  double _todayStandHours = 0.0;
  double? _latestWeight;

  bool get isAuthorized => _isAuthorized;
  double get todaySteps => _todaySteps;
  double get todayCalories => _todayCalories;
  double get activeMinutes => _activeMinutes;
  double get todayStandHours => _todayStandHours;
  double? get latestWeight => _latestWeight;

  HealthManager() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthorized = prefs.getBool('lote_health_authorized') ?? false;
    if (_isAuthorized) {
      await fetchTodayData();
    }
    notifyListeners();
  }

  Future<void> requestAuthorization() async {
    final health = Health();

    // Define data types
    final List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WORKOUT,
      HealthDataType.WEIGHT,
    ];

    if (!kIsWeb && Platform.isIOS) {
      types.add(HealthDataType.APPLE_STAND_TIME);
    }

    try {
      // Check permissions
      bool requested = await health.requestAuthorization(types);
      _isAuthorized = requested;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lote_health_authorized', requested);
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
      _activeMinutes = workoutMins;

      // Fetch/Estimate stand hours
      try {
        if (!kIsWeb && Platform.isIOS) {
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
          _todayStandHours = totalStand / 3600.0;
        } else {
          _todayStandHours = 0.0;
        }
      } catch (_) {
        _todayStandHours = 0.0;
      }

      // Fetch Latest Weight
      try {
        final List<HealthDataType> weightTypes = [HealthDataType.WEIGHT];
        List<HealthDataPoint> weightData = await health.getHealthDataFromTypes(
          types: weightTypes,
          startTime: now.subtract(const Duration(days: 30)),
          endTime: now,
        );
        if (weightData.isNotEmpty) {
          // Sort by latest
          weightData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
          final val = weightData.first.value;
          if (val is NumericHealthValue) {
            // Health plugin usually returns kg. If user wants lb, we convert it later or assume kg.
            // Wait, Health returns it in kg. We'll store the kg value or whatever it is, but Health plugin normalizes to kg.
            // Let's store the raw value and let the profile manager handle it if needed.
            _latestWeight = val.numericValue.toDouble();
          }
        }
      } catch (_) {}

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
