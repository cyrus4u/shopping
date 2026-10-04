import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test_screen';
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.blue));
  }
}
