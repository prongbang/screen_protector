import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class ProtectDataLeakagePage extends StatefulWidget {
  const ProtectDataLeakagePage({Key? key}) : super(key: key);

  @override
  _ProtectDataLeakagePageState createState() => _ProtectDataLeakagePageState();
}

class _ProtectDataLeakagePageState extends State<ProtectDataLeakagePage> {
  String _protectionMode = 'color';

  @override
  void initState() {
    _protectDataLeakageOn();
    super.initState();
  }

  @override
  void dispose() async {
    await ScreenProtector.protectDataLeakageOff();
    super.dispose();
  }

  void _protectDataLeakageOn() async {
    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageOff();
      print("protectionMode: $_protectionMode");
      switch (_protectionMode) {
        case 'color':
          await ScreenProtector.protectDataLeakageWithColor(Colors.yellow);
          break;
        case 'image':
          await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
          break;
        case 'blur':
          await ScreenProtector.protectDataLeakageWithBlur();
          break;
      }
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Protect Screen Data Leakage'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Protect Screen Data Leakage with Color'),
            onTap: () {
              setState(() {
                _protectionMode = 'color';
              });
              _protectDataLeakageOn();
            },
          ),
          ListTile(
            title: const Text('Protect Screen Data Leakage with Image'),
            onTap: () {
              setState(() {
                _protectionMode = 'image';
              });
              _protectDataLeakageOn();
            },
          ),
          ListTile(
            title: const Text('Protect Screen Data Leakage with Blur'),
            onTap: () {
              setState(() {
                _protectionMode = 'blur';
              });
              _protectDataLeakageOn();
            },
          ),
        ],
      ),
    );
  }
}
