import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LostXFound'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Welcome to LostXFound'),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
