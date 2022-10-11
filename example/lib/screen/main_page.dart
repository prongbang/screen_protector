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
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text('Screen Protector'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/prevent-screenshot');
              },
              child: const Text('Prevent Screenshot'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/protect-data-leakage');
              },
              child: const Text('Protect Screen Data Leakage'),
            )
          ],
        ),
      ),
    );
  }
}
