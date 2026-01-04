import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Su verileri
  int _dailyWaterGoal = 8;
  int _currentWaterCount = 0;

  // Adım verileri
  int _steps = 0;

  // Uyku verileri
  TimeOfDay? _sleepTime;
  TimeOfDay? _wakeTime;

  // Getters
  int get dailyWaterGoal => _dailyWaterGoal;
  int get currentWaterCount => _currentWaterCount;
  int get steps => _steps;
  TimeOfDay? get sleepTime => _sleepTime;
  TimeOfDay? get wakeTime => _wakeTime;

  // Uyku süresi hesaplama (saat cinsinden)
  double get sleepHours {
    if (_sleepTime == null || _wakeTime == null) return 0.0;
    
    final now = DateTime.now();
    final sleepDateTime = DateTime(now.year, now.month, now.day, _sleepTime!.hour, _sleepTime!.minute);
    DateTime wakeDateTime = DateTime(now.year, now.month, now.day, _wakeTime!.hour, _wakeTime!.minute);
    
    if (wakeDateTime.isBefore(sleepDateTime)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }
    
    final diff = wakeDateTime.difference(sleepDateTime);
    return diff.inMinutes / 60.0;
  }

  // Su metodları
  void incrementWater() {
    if (_currentWaterCount < _dailyWaterGoal) {
      _currentWaterCount++;
      notifyListeners();
    }
  }

  void decrementWater() {
    if (_currentWaterCount > 0) {
      _currentWaterCount--;
      notifyListeners();
    }
  }

  void resetWater() {
    _currentWaterCount = 0;
    notifyListeners();
  }

  void setDailyWaterGoal(int value) {
    _dailyWaterGoal = value;
    notifyListeners();
  }

  // Adım metodları
  void incrementSteps() {
    _steps += 100;
    notifyListeners();
  }

  void setSteps(int value) {
    _steps = value;
    notifyListeners();
  }

  // Uyku metodları
  void setSleepTime(TimeOfDay? time) {
    _sleepTime = time;
    notifyListeners();
  }

  void setWakeTime(TimeOfDay? time) {
    _wakeTime = time;
    notifyListeners();
  }

  void setSleepData(TimeOfDay? sleep, TimeOfDay? wake) {
    _sleepTime = sleep;
    _wakeTime = wake;
    notifyListeners();
  }
}
