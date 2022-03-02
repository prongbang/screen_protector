import 'package:flutter/material.dart';
import 'package:screen_protector_example/prevent_screenshot_page.dart';
import 'package:screen_protector_example/transition/transition.dart';

class AppRouters {
  static RouteFactory? routes() {
    return (settings) => {
          "/prevent-screenshot":
              nextTransition(settings, const PreventScreenshotPage()),
        }[settings.name];
  }
}
