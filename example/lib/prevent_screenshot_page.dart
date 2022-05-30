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
    // For iOS only.
    _addListenerPreventScreenshot();
    _preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() {
    // For iOS only.
    _removeListenerPreventScreenshot();
    _preventScreenshotOff();
    super.dispose();
  }

  @override
  void onPaused() {
    _protectScreenOn();
    super.onPaused();
  }

  @override
  void onResumed() {
    _protectScreenOff();
    super.onResumed();
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

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _protectScreenOn() async => await ScreenProtector.protectDataLeakageOn();

  void _protectScreenOff() async =>
      await ScreenProtector.protectDataLeakageOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(() {
      // Screenshot
      print('Screenshot:');
    }, (isCaptured) {
      // Screen Record
      print('Screen Record:');
    });
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }
}
