import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:shopping/config/my_theme.dart';
import 'package:shopping/config/supabase_config.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shopping/features/feature_intro/presentation/screens/intro_main_wrapper.dart';
import 'package:shopping/features/feature_intro/presentation/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping/locator.dart';
import 'package:shopping/test_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopping/config/app_logger.dart';


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    assert(
      SupabaseConfig.url.isNotEmpty && SupabaseConfig.anonKey.isNotEmpty,
      'Run with --dart-define-from-file=env.json',
    );

    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
      postgrestOptions: const PostgrestClientOptions(schema: 'shopping'),
    );

    await initLocator();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()),
          BlocProvider(create: (_) => BottomNavCubit()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, st) {
    AppLogger.error('Startup failed', error: e, stackTrace: st, name: 'Startup');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText('Startup error:\n\n$e'),
          ),
        ),
      ),
    );
  }
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
      // initialRoute: '/',
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
        MainWrapper.routeName: (context) => const MainWrapper(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Besinior Shop',
      home: const SplashScreen(),
    );
  }
}
