import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class PreventScreenshotPage extends StatefulWidget {
  const PreventScreenshotPage({Key? key}) : super(key: key);

  @override
  _PreventScreenshotPageState createState() => _PreventScreenshotPageState();
}

class _PreventScreenshotPageState extends State<PreventScreenshotPage> {
  @override
  void initState() {
    // For iOS only.
    _addListenerPreventScreenshot();

    // For iOS and Android
    _preventScreenshotOn();
    _checkScreenRecording();
    super.initState();
  }

  @override
  void dispose() {
    // For iOS only.
    _removeListenerPreventScreenshot();

    // For iOS and Android
    _preventScreenshotOff();
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

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screen Recording...'),
      ));
    }
  }

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(() {
      // Screenshot
      debugPrint('Screenshot:');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screenshot!'),
      ));
    }, (isCaptured) {
      // Screen Record
      debugPrint('Screen Record:');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screen Record!'),
      ));
    });
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }
}
