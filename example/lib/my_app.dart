import 'package:flutter/material.dart';
import 'package:screen_protector/lifecycle/lifecycle_state.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:screen_protector_example/main_page.dart';
import 'package:screen_protector_example/prevent_screenshot_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends LifecycleState<MyApp> {
  @override
  void initState() {
    // For iOS only.
    _protectDataLeakageWithColor();
    super.initState();
  }

  @override
  void onResumed() {
    // For Android only.
    _protectDataLeakageAndPreventScreenshotOff();
    super.onResumed();
  }

  @override
  void onPaused() {
    // For Android only.
    _protectDataLeakagePreventScreenshotOn();
    super.onPaused();
  }

  void _protectDataLeakageWithColor() async =>
      await ScreenProtector.protectDataLeakageWithColor(Colors.white);

  void _protectDataLeakageAndPreventScreenshotOff() async =>
      await ScreenProtector.protectDataLeakageOff();

  void _protectDataLeakagePreventScreenshotOn() async =>
      await ScreenProtector.protectDataLeakageOn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      routes: <String, WidgetBuilder>{
        '/prevent-screenshot': (_) => const PreventScreenshotPage(),
      },
    );
  }
}
