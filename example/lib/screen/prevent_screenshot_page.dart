import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

class PreventScreenshotPage extends StatefulWidget {
  const PreventScreenshotPage({Key? key}) : super(key: key);

  @override
  State<PreventScreenshotPage> createState() => _PreventScreenshotPageState();
}

class _PreventScreenshotPageState extends State<PreventScreenshotPage> {
  @override
  void initState() {
    _initialize();
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

  void _initialize() async {
    _addListenerPreventScreenshot();
    _checkScreenRecording();
    _preventScreenshotOn();
    _setLandscapeRight();
  }

  Future<void> _setPortraitUp() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _setLandscapeRight() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _setLandscapeLeft() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prevent Screenshot'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Secure Screen'),
            ElevatedButton(
              onPressed: _setPortraitUp,
              child: const Text('Portrait Up'),
            ),
            ElevatedButton(
              onPressed: _setLandscapeRight,
              child: const Text('Landscape Right'),
            ),
            ElevatedButton(
              onPressed: _setLandscapeLeft,
              child: const Text('Landscape Left'),
            ),
          ],
        ),
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
