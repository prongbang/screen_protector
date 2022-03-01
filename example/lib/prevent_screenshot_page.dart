import 'package:flutter/material.dart';
import 'package:screen_protector/lifecycle/lifecycle_state.dart';
import 'package:screen_protector/screen_protector.dart';

class PreventScreenshotPage extends StatefulWidget {
  const PreventScreenshotPage({Key? key}) : super(key: key);

  @override
  _PreventScreenshotPageState createState() => _PreventScreenshotPageState();
}

class _PreventScreenshotPageState
    extends LifecycleState<PreventScreenshotPage> {
  @override
  void initState() {
    preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() {
    preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prevent Screenshot'),
      ),
      body: const Center(
        child: Text('Secure Screen'),
      ),
    );
  }

  void preventScreenshotOn() async {
    await ScreenProtector.preventScreenshotOn();
  }

  void preventScreenshotOff() async {
    await ScreenProtector.preventScreenshotOff();
  }
}
