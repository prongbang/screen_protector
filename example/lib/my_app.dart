import 'package:flutter/material.dart';
import 'package:screen_protector_example/router/routers.dart';
import 'package:screen_protector_example/screen/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      onGenerateRoute: AppRouters.routes(),
    );
  }
}
