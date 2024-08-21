# screen_protector

Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/prongbang)

## Feature

### Import

```dart
import 'package:screen_protector/screen_protector.dart';
```

### iOS

#### Protect Data Leakage Background Screenshot

- Protect data leakage with image

```dart
await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
```

- Protect data leakage with color ON

```dart
await ScreenProtector.protectDataLeakageWithColor(Colors.white);
```

- Protect data leakage with color OFF

```dart
await ScreenProtector.protectDataLeakageWithColorOff();
```

- Protect data leakage with blur ON

```dart
await ScreenProtector.protectDataLeakageWithBlur();
```

- Protect data leakage with blur OFF

```dart
await ScreenProtector.protectDataLeakageWithBlurOff();
```

#### Prevent Screenshot

- ON

```dart
await ScreenProtector.preventScreenshotOn();
```

- OFF

```dart
await ScreenProtector.preventScreenshotOff();
```

#### Check Screen Recording

```dart
final isRecording = await ScreenProtector.isRecording();
```

### Android

#### Protect Data Leakage Background Screenshot and Prevent Screenshot 

- ON

```dart
await ScreenProtector.protectDataLeakageOn();
```

or

```dart
await ScreenProtector.preventScreenshotOn();
```

- OFF

```dart
await ScreenProtector.protectDataLeakageOff();
```

or

```dart
await ScreenProtector.preventScreenshotOff();
```

#### Protect Data Leakage for Android 12+ (Optional)

[https://github.com/prongbang/screen-protector](https://github.com/prongbang/screen-protector)

```kotlin
import com.prongbang.screenprotect.AndroidScreenProtector

class MainActivity : FlutterFragmentActivity() {

    private val screenProtector by lazy { AndroidScreenProtector.newInstance(this) }

    // For Android 12+
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        screenProtector.process(hasFocus.not())
    }
}
```

## Usage

### Android

- Protect Data Leakage Background Screenshot and Prevent Screenshot.

```dart
import 'package:screen_protector/screen_protector.dart';

class _PreventScreenshotPageState extends State<MyApp> {

  void _preventScreenshotOn() async => await ScreenProtector.protectDataLeakageOn();

  void _protectDataLeakageOff() async => await ScreenProtector.protectDataLeakageOff();

  @override
  void initState() {
    _preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() {
    _protectDataLeakageOff();
    super.dispose();
  }
  
}
```

### iOS

- Prevent Screenshot

```dart
import 'package:screen_protector/screen_protector.dart';

class _PreventScreenshotPageState extends State<MyApp> {

  void _preventScreenshotOn() async => await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async => await ScreenProtector.preventScreenshotOff();

  @override
  void initState() {
    _preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() {
    _preventScreenshotOff();
    super.dispose();
  }
  
}
```

- Protect data leakage with color

```dart
import 'package:screen_protector/screen_protector.dart';

class _ProtectDataLeakagePageState extends State<MyApp> {

  void _protectDataLeakageWithColor() async => await ScreenProtector.protectDataLeakageWithColor(Colors.white);

  @override
  void initState() {
    _protectDataLeakageWithColor();
    super.initState();
  }
  
}
```

- Protect data leakage with image

![image01.png](screenshot/image01.png)

```dart
import 'package:screen_protector/screen_protector.dart';

class _ProtectDataLeakagePageState extends State<MyApp> {

  void _protectDataLeakageWithImage() async => await ScreenProtector.protectDataLeakageWithImage('LaunchImage');

  @override
  void initState() {
    _protectDataLeakageWithImage();
    super.initState();
  }
  
}
```

- Protect data leakage with blur

```dart
import 'package:screen_protector/screen_protector.dart';

class _ProtectDataLeakagePageState extends State<MyApp> {

  void _protectDataLeakageWithBlur() async => await ScreenProtector.protectDataLeakageWithBlur();

  @override
  void initState() {
    _protectDataLeakageWithBlur();
    super.initState();
  }
  
}
```
