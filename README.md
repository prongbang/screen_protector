# screen_protector

Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/prongbang)

## Feature

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
class _PreventScreenshotPageState extends State<MyApp> {
  
  @override
  void initState() async {
    await ScreenProtector.protectDataLeakageOn();
    super.initState();
  }

  @override
  void dispose() async {
    await ScreenProtector.protectDataLeakageOff();
    super.dispose();
  }
  
}
```

### iOS

- Prevent Screenshot

```dart
class _PreventScreenshotPageState extends State<MyApp> {
  
  @override
  void initState() async {
    await ScreenProtector.preventScreenshotOn();
    super.initState();
  }

  @override
  void dispose() async {
    await ScreenProtector.preventScreenshotOff();
    super.dispose();
  }
  
}
```

- Protect data leakage with color

```dart
class _ProtectDataLeakagePageState extends State<MyApp> {
  
  @override
  void initState() async {
    await ScreenProtector.protectDataLeakageWithColor(Colors.white);
    super.initState();
  }
  
}
```

- Protect data leakage with image

![image01.png](screenshot/image01.png)

```dart
class _ProtectDataLeakagePageState extends State<MyApp> {
  
  @override
  void initState() async {
    await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
    super.initState();
  }
  
}
```

- Protect data leakage with blur

```dart
class _ProtectDataLeakagePageState extends State<MyApp> {
  
  @override
  void initState() async {
    await ScreenProtector.protectDataLeakageWithBlur();
    super.initState();
  }
  
}
```
