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
    ScreenProtector.protectDataLeakageWithColor(Colors.white);
    super.initState();
  }

  @override
  void onResumed() {
    protectDataLeakageOff();
    super.onResumed();
  }

  @override
  void onPaused() {
    protectDataLeakageOn();
    super.onPaused();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      routes: <String, WidgetBuilder>{
        '/prevent-screenshot': (_) => const PreventScreenshotPage(),
      },
    );
  }

  void protectDataLeakageOn() async {
    await ScreenProtector.protectDataLeakageOn();
  }

  void protectDataLeakageOff() async {
    await ScreenProtector.protectDataLeakageOff();
  }
}
