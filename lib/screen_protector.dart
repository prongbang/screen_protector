import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/extension/color_extension.dart';

class ScreenProtector {
  static const MethodChannel _channel = MethodChannel('screen_protector');

  /// Supported for Anddroid only, donothing when run on iOS.
  static Future<void> protectDataLeakageOn() async {
    return await _channel.invokeMethod('protectDataLeakageOn');
  }

  /// Supported for Anddroid only, donothing when run on iOS.
  static Future<void> protectDataLeakageOff() async {
    return await _channel.invokeMethod('protectDataLeakageOff');
  }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithBlur() async {
    return await _channel.invokeMethod('protectDataLeakageWithBlur');
  }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithImage(String imageName) async {
    return await _channel.invokeMethod('protectDataLeakageWithImage', {
      'name': imageName,
    });
  }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithColor(Color color) async {
    return await _channel.invokeMethod('protectDataLeakageWithColor', {
      'hexColor': color.toHex(),
    });
  }

  /// Supported for Anddroid and iOS.
  static Future<void> preventScreenshotOn() async {
    return await _channel.invokeMethod('preventScreenshotOn');
  }

  /// Supported for Anddroid and iOS.
  static Future<void> preventScreenshotOff() async {
    return await _channel.invokeMethod('preventScreenshotOff');
  }
}
