import 'package:flutter/material.dart';
import 'package:screen_protector_example/screen/prevent_screenshot_page.dart';
import 'package:screen_protector_example/screen/protect_data_leakage_page.dart';
import 'package:screen_protector_example/transition/transition.dart';

class AppRouters {
  static RouteFactory? routes() {
    return (settings) => {
          "/prevent-screenshot": nextTransition(
            settings,
            const PreventScreenshotPage(),
          ),
          "/protect-data-leakage": nextTransition(
            settings,
            const ProtectDataLeakagePage(),
          ),
        }[settings.name];
  }
}
