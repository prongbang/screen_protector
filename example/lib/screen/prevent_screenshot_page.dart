import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screen_protector/screen_protector.dart';

class PreventScreenshotPage extends StatefulWidget {
  const PreventScreenshotPage({Key? key}) : super(key: key);

  @override
  State<PreventScreenshotPage> createState() => _PreventScreenshotPageState();
}

class _PreventScreenshotPageState extends State<PreventScreenshotPage>
    with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initialize();
    super.initState();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);

    // For iOS only.
    _removeListenerPreventScreenshot();

    // For iOS and Android
    _preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Lifecycle: $state');
    super.didChangeAppLifecycleState(state);
  }

  void _initialize() async {
    _addListenerPreventScreenshot();
    _checkScreenRecording();
    _preventScreenshotOn();
    _setLandscapeRight();
    await ScreenProtector.protectDataLeakageWithColor(Colors.lightBlueAccent);
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
          mainAxisSize: MainAxisSize.min,
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
            ElevatedButton(
              onPressed: _pickAndCrop,
              child: const Text('Pick + Crop (repro)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndCrop() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    await ImageCropper().cropImage(sourcePath: picked.path);
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
