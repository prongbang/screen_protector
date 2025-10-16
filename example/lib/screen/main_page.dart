import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Screen Protector'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Prevent Screenshot'),
              onTap: () {
                Navigator.pushNamed(context, '/prevent-screenshot');
              },
            ),
            ListTile(
              title: const Text('Protect Screen Data Leakage'),
              onTap: () {
                Navigator.pushNamed(context, '/protect-data-leakage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
