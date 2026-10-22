import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String name = 'App'}) {
    if (kDebugMode) dev.log(message, name: name, level: 800);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = 'App',
  }) {
    dev.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
// ******************************************************************************
// import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';

// class AppLogger {
//   static final Logger _logger = Logger(
//     printer: PrettyPrinter(
//       methodCount: 0,        // no stack trace for normal logs
//       errorMethodCount: 8,   // stack trace lines for errors
//       printEmojis: true,
//     ),
//   );

//   static void info(String message, {String name = 'App'}) {
//     if (kDebugMode) _logger.i('[$name] $message');
//   }

//   static void error(
//     String message, {
//     Object? error,
//     StackTrace? stackTrace,
//     String name = 'App',
//   }) {
//     _logger.e('[$name] $message', error: error, stackTrace: stackTrace);
//   }
// }