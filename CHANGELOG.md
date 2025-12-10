## 1.4.11

- Fix: Change UIScene.willEnterForegroundNotification to UIScene.didActivateNotification
- Acknowledgements: Thanks to @saedAlHanash for their testing 🙏

## 1.4.10

- Migrated from deprecated AppDelegate lifecycle methods to modern iOS Scene Lifecycle using UIScene notifications

## 1.4.9

- Fix: iOS preview data leakage not disabled

## 1.4.8

- Fix iOS crash on iOS 18 when returning from background by recreating the
  ScreenProtectorKit whenever the active UIWindow changes or a UIScene reconnects.
- Acknowledgements: Thanks to @Jens-source for their PRs 🙏

## 1.4.7

- Ensured all ScreenProtectorKit initialization runs on the main thread

## 1.4.6

- Added safe UIWindow resolver with AppDelegate and SceneDelegate fallback support.

## 1.4.5

- Fix iOS prevent creation before any window is visible

## 1.4.4

* Fix iOS plugin not work with flutter Apps that have SceneDelegate and AppDelegate
* Acknowledgements: Thanks to @MohamedElgamal93 for their report and fix issue 🙏

## 1.4.3

* Update Kotlin version and SDK settings
* Acknowledgements: Thanks to @Ikxyz and @pocketshop-app for their PRs 🙏

## 1.4.2+1

* Update example

## 1.4.2

* Add function protectDataLeakageOff for iOS

## 1.4.1

* fix(ios): missing disabling of protection screens when calling protectDataLeakage off methods in inactive app state

## 1.4.0

* feat(ios): add method protectDataLeakageWithColorOff
* fix(ios): missing result() calls for some methods

## 1.3.2

* Update ScreenProtectorKit (1.3.1)

## 1.3.1

* Update LifecycleState by App Lifecycle Listener
* Add LegacyLifecycleState

## 1.3.0

* Add function protect data leakage with blur off for iOS only
* Upgrade gradle version to 8.0
* Upgrade kotlin version to 1.7.10

## 1.2.0

* Add function check screen recording for iOS only

## 1.1.5

* Fixes color class usage was missing flutter material import by juampiq6

## 1.1.4

* Fix bug Could not find com.github.prongbang:screen-protector:x.x.x

## 1.1.3+1

* Config maven jitpack

## 1.1.3

* Update compileSdkVersion to 33
* Update screen-protector version to 1.0.1

## 1.1.2

* Fix bug some device white screen

## 1.1.1

* Added compatibility with Flutter 3.0

## 1.1.0

* Add function observer screenshot and screen record for iOS.

## 1.0.0

* Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and
  iOS.
