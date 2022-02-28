import 'package:flutter/material.dart';
import 'package:screen_protector/lifecycle/lifecycle_state.dart';
import 'package:screen_protector/screen_protector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends LifecycleState<MyApp> {
  @override
  void onPaused() {
    protectDataLeakageOn();
    super.onPaused();
  }

  @override
  void onResumed() {
    protectDataLeakageOff();
    super.onResumed();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Screen Proteector'),
        ),
      ),
    );
  }

  void protectDataLeakageOn() async {
    await ScreenProtector.protectDataLeakageOn();
  }

  void protectDataLeakageOff() async {
    await ScreenProtector.protectDataLeakageOff();
  }
}
