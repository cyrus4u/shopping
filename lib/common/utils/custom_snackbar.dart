import 'package:flutter/material.dart';

class CustomSnackbar {
  const CustomSnackbar._(); // prevents instantiation, since this is a static-only class

  static void showSnack(
    BuildContext context,
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Vazir',
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}