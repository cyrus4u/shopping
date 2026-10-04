import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/config/my_theme.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shopping/features/feature_intro/presentation/screens/intro_main_wrapper.dart';
import 'package:shopping/features/feature_intro/presentation/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping/test_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => SplashCubit())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      scrollBehavior: AppScrollBehavior(),
      initialRoute: '/',
      locale: Locale('fa', ''),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('fa', ''), // Farsi
      ],
      routes: {
        IntroMainWrapper.routeName: (context) => IntroMainWrapper(),
        TestScreen.routeName: (context) => TestScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Besinior Shop',
      home: const SplashScreen(),
    );
  }
}
