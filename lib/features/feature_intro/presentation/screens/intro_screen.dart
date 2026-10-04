import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro_screen';
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(args),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
