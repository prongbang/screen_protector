import 'dart:async';

import 'package:flutter/services.dart';

class ScreenProtector {
  static const MethodChannel _channel = MethodChannel('screen_protector');

  static Future<void> protectDataLeakageOn() async {
    return await _channel.invokeMethod("protectDataLeakageOn");
  }

  static Future<void> protectDataLeakageOff() async {
    return await _channel.invokeMethod("protectDataLeakageOff");
  }

  static Future<void> preventScreenshotOn() async {
    return await _channel.invokeMethod("preventScreenshotOn");
  }

  static Future<void> preventScreenshotOff() async {
    return await _channel.invokeMethod("preventScreenshotOff");
  }
}
