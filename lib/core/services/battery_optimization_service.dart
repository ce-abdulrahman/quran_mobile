import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles the Android battery-optimization exemption.
///
/// Even exact alarms get delayed or dropped entirely by the aggressive battery
/// managers on Xiaomi/MIUI, Huawei, Oppo/Realme and Samsung unless the app is
/// whitelisted. Since a late azan is a broken azan, the app asks for the
/// exemption instead of silently losing prayer notifications.
class BatteryOptimizationService {
  static final BatteryOptimizationService _instance =
      BatteryOptimizationService._internal();
  factory BatteryOptimizationService() => _instance;
  BatteryOptimizationService._internal();

  /// Whether the exemption is already granted. Non-Android platforms report
  /// `true` since the restriction doesn't exist there.
  Future<bool> isExempt() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      return await Permission.ignoreBatteryOptimizations.isGranted;
    } catch (e) {
      debugPrint('Battery optimization status check failed: $e');
      return true; // Don't nag the user if we can't tell.
    }
  }

  /// Shows the system exemption dialog. Returns whether it ended up granted.
  Future<bool> requestExemption() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final status = await Permission.ignoreBatteryOptimizations.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Battery optimization request failed: $e');
      return false;
    }
  }
}
