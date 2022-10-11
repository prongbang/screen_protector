# screen_protector

Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.

## Feature

### iOS

#### Protect Data Leakage Background Screenshot

- Protect data leakage with image

```dart
await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
```

- Protect data leakage with color

```dart
await ScreenProtector.protectDataLeakageWithColor(Colors.white);
```

- Protect data leakage with blur

```dart
await ScreenProtector.protectDataLeakageWithBlur();
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