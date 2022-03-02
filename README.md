# screen_protector

Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.

## Feature

### iOS

- Protect Data Leakage Background Screenshot

```dart
await ScreenProtector.protectDataLeakageWithColor(Colors.white);
await ScreenProtector.protectDataLeakageWithBlur();
await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
```

- Prevent Screenshot

```dart
await ScreenProtector.preventScreenshotOn();
await ScreenProtector.preventScreenshotOff();
```

### Android

- Protect Data Leakage Background Screenshot and Prevent Screenshot 

```dart
await ScreenProtector.protectDataLeakageOn();
await ScreenProtector.preventScreenshotOn();
```

## Usage

- Protect Data Leakage Background Screenshot and Prevent Screenshot for Android.

```dart
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
    _protectDataLeakageOff();
    super.onResumed();
  }

  @override
  void onPaused() {
    // For Android only.
    _protectDataLeakageOn();
    super.onPaused();
  }

  void _protectDataLeakageWithColor() async =>
      await ScreenProtector.protectDataLeakageWithColor(Colors.white);

  void _protectDataLeakageOff() async =>
      await ScreenProtector.protectDataLeakageOff();

  void _protectDataLeakageOn() async =>
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
```

- Prevent Screenshot for iOS

```dart
class _PreventScreenshotPageState extends State<PreventScreenshotPage> {
  @override
  void initState() {
    // For iOS only.
    _preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() {
    // For iOS only.
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

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();
}
```