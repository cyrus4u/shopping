import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:shopping/config/my_theme.dart';
import 'package:shopping/config/supabase_config.dart';
import 'package:shopping/features/feature_auth/presentation/bloc/login_bloc/bloc/login_bloc.dart';
import 'package:shopping/features/feature_auth/presentation/bloc/signup_bloc/bloc/signup_bloc.dart';
import 'package:shopping/features/feature_auth/presentation/screens/email_auth_screen.dart';

import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shopping/features/feature_intro/presentation/screens/intro_main_wrapper.dart';
import 'package:shopping/features/feature_intro/presentation/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping/features/feature_product/presentation/screens/all_product_screen.dart';
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

final navigatorKey = GlobalKey<NavigatorState>();

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

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          EmailAuthScreen.routeName,  
          (route) => false,
        );
      }
    });

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()),
          BlocProvider(create: (_) => BottomNavCubit()),
          BlocProvider(create: (_) => locator<SignupBloc>()),
          BlocProvider(create: (_) => locator<LoginBloc>()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, st) {
    AppLogger.error(
      'Startup failed',
      error: e,
      stackTrace: st,
      name: 'Startup',
    );
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
      navigatorKey: navigatorKey,
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
        
        AllProductsScreen.routeName: (context) => AllProductsScreen(),
        EmailAuthScreen.routeName: (context) => const EmailAuthScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Besinior Shop',
      home: const SplashScreen(),
    );
  }
}
