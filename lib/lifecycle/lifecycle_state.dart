import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  AppLifecycleState? _lifecycleState;

  @override
  void initState() {
    super.initState();
    _lifecycleState = WidgetsBinding.instance.lifecycleState;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    onExitRequested();
    return AppExitResponse.exit;
  }

  /// [App Lifecycle Listener](https://miro.medium.com/v2/resize:fit:1400/0*bN0QtrIRWGDMC9LJ)
  ///
  /// detached -> resumed -|
  ///    ^                 v
  ///    |             inactive
  /// paused <- hidden <--|
  ///
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final AppLifecycleState? previousState = _lifecycleState;
    if (state == previousState) {
      // Transitioning to the same state twice doesn't produce any notifications (but also won't actually occur).
      return;
    }
    _lifecycleState = state;
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        if (previousState == AppLifecycleState.hidden) {
          onShow();
        } else if (previousState == null ||
            previousState == AppLifecycleState.resumed) {
          onInactive();
        }
        break;
      case AppLifecycleState.hidden:
        if (previousState == AppLifecycleState.paused) {
          onRestart();
        } else if (previousState == null ||
            previousState == AppLifecycleState.inactive) {
          onHidden();
        }
        break;
      case AppLifecycleState.paused:
        if (previousState == null ||
            previousState == AppLifecycleState.hidden) {
          onPaused();
        }
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      default:
    }

    // At this point, it can't be null anymore.
    if (_lifecycleState != null) {
      onStateChange(_lifecycleState!);
    }
  }

  void onExitRequested() {
    if (kDebugMode) {
      print("on exit requested");
    }
  }

  void onStateChange(AppLifecycleState state) {
    if (kDebugMode) {
      print("on state change: $state");
    }
  }

  void onShow() {
    if (kDebugMode) {
      print("on show");
    }
  }

  void onHidden() {
    if (kDebugMode) {
      print("on hidden");
    }
  }

  void onResumed() {
    if (kDebugMode) {
      print("on resumed");
    }
  }

  void onPaused() {
    if (kDebugMode) {
      print("on paused");
    }
  }

  void onInactive() {
    if (kDebugMode) {
      print("on inactive");
    }
  }

  void onDetached() {
    if (kDebugMode) {
      print("on detached");
    }
  }

  void onRestart() {
    if (kDebugMode) {
      print("on restart");
    }
  }
}
