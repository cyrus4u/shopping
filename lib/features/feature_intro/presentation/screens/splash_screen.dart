import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shopping/common/utils/custom_snackbar.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/connection_status.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:shopping/features/feature_intro/presentation/screens/intro_main_wrapper.dart';
import 'package:shopping/locator.dart';
import 'package:shopping/test_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // goToHome();
    BlocProvider.of<SplashCubit>(context).checkConnectionEvent();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: DelayedWidget(
                delayDuration: const Duration(milliseconds: 200),
                animationDuration: const Duration(milliseconds: 3000),
                animation: DelayedAnimations.SLIDE_FROM_TOP,
                child: Image.asset(
                  'assets/images/besenior_logo.png',
                  width: width * .8,
                ),
              ),
            ),
            BlocConsumer<SplashCubit, SplashState>(
              builder: (context, state) {
                /// if user is online
                if (state.connectionStatus is ConnectionInitial ||
                    state.connectionStatus is ConnectionOn) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: LoadingAnimationWidget.progressiveDots(
                      color: Colors.red,
                      size: 50,
                    ),
                  );
                }

                /// if user is offline
                if (state.connectionStatus is ConnectionOff) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'به اینترنت متصل نیستید!',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontFamily: "vazir",
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.red,
                        onPressed: () {
                          /// check that we are online or not
                          BlocProvider.of<SplashCubit>(
                            context,
                          ).checkConnectionEvent();
                        },
                        icon: const Icon(Icons.autorenew, color: Colors.red),
                      ),
                    ],
                  );
                }

                /// default value
                return Container();
              },
              listener: (context, state) {
                if (state.connectionStatus is ConnectionOn) {
                  goToHome();
                }
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  bool _navigated = false;

  Future<void> goToHome() async {
    if (_navigated) return;
    _navigated = true;

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final shouldShowIntro = await locator<PrefsOperator>().getIntroState();
    if (!mounted) return; // check again after every await

    Navigator.pushNamedAndRemoveUntil(
      context,
      shouldShowIntro ? IntroMainWrapper.routeName : MainWrapper.routeName,
      (route) => false,
    );
  }

  // Future<void> goToHome() async {
  //   await Future.delayed(const Duration(seconds: 3));

  //   if (!mounted) return; // the widget is still in the tree, so context is safe

  //   PrefsOperator prefsOperator = locator<PrefsOperator>();
  //   var shouldShowIntro = await prefsOperator.getIntroState();
  //   if (shouldShowIntro) {
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       IntroMainWrapper.routeName,
  //       ModalRoute.withName("intro_main_wrapper"),

  //       //  arguments: 'Besinior'
  //     );
  //   } else {
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       MainWrapper.routeName,
  //       ModalRoute.withName("main_wrapper"),
  //     );
  //   }
  // }
}
