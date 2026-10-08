import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/intro_cubit/intro_cubit.dart';
import 'package:shopping/features/feature_intro/presentation/widgets/get_start_btn.dart';
import 'package:shopping/features/feature_intro/presentation/widgets/intro_page.dart';
import 'package:shopping/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// The onboarding screen shown on the first app launch.
///
/// It displays 3 swipeable intro pages, a page indicator, and a button that
/// changes from "Next" (ورق بزن) to "Get Started" (شروع کنید) on the last page.
/// The button state is managed by [IntroCubit].
class IntroMainWrapper extends StatelessWidget {
  /// Route name used by the app's router / Navigator.
  static const routeName = '/intro_main_wrapper';
  IntroMainWrapper({super.key});

  /// Controls the PageView (jump/animate to a page, read the current page).
  /// It's shared with the page indicator so both stay in sync.
  final PageController pageController = PageController();

  /// The content of each intro page (title, description, and image).
  /// `const` is used because these widgets never change.
  final List<Widget> introPages = [
    const IntroPage(
      title: 'تخصص حرف اول رو میزنه!',
      description:
          'اپلیکیشن تخصصی خرید و فروش انواع قطعات یدکی خودروهای داخلی و خارجی با ضمانت اصالت کالا و نازلترین قیمت',
      image: "assets/images/benz.png",
    ),
    const IntroPage(
      title: 'آسان خرید و فروش کن!',
      description: 'خرید و فروش سریع و آسان همراه با تیم پشتیبانی قوی',
      image: "assets/images/bmw.png",
    ),
    const IntroPage(
      title: 'همه چی اینجا هست!',
      description: 'ثبت قطعات کمیاب و خرید و فروش عمده تنها با یک کلیک',
      image: "assets/images/tara.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as String;

    /// Get the device size (used for responsive positions and sizes below).
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Provide the IntroCubit to everything below this widget.
    return BlocProvider(
      create: (context) => IntroCubit(),
      // Builder gives us a new `context` that sits *below* BlocProvider.
      // Without it, BlocProvider.of(context) would not find the cubit,
      // because the outer `context` is above the provider.
      child: Builder(
        builder: (context) {
          return Scaffold(
            // Stack lets us layer widgets on top of each other and place
            // them exactly with Positioned.
            body: Stack(
              children: [
                /// Layer 1: amber background shape at the top (60% of the screen),
                /// with one big rounded corner for a decorative look.
                Positioned(
                  top: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(150),
                      ),
                    ),
                    width: width,
                    height: height * 0.6,
                  ),
                ),

                /// Layer 2: the swipeable intro pages.
                /// It sits 10% above the bottom, so the buttons and the
                /// indicator below have space and don't overlap the content.
                Positioned(
                  bottom: height * 0.1,
                  child: SizedBox(
                    width: width,
                    height: height * 0.9,
                    child: PageView(
                      // Called every time the user swipes to a new page.
                      onPageChanged: (index) {
                        // Index 2 = last page -> show the "Get Started" button.
                        // Any other page -> show the "Next" button.
                        if (index == 2) {
                          BlocProvider.of<IntroCubit>(
                            context,
                          ).changeGetStart(true);
                        } else {
                          BlocProvider.of<IntroCubit>(
                            context,
                          ).changeGetStart(false);
                        }
                      },
                      controller: pageController,
                      children: introPages,
                    ),
                  ),
                ),

                /// Layer 3: the main button (bottom right).
                /// BlocBuilder rebuilds only this part when the state changes.
                Positioned(
                  bottom: height * .07,
                  right: 30,
                  child: BlocBuilder<IntroCubit, IntroState>(
                    builder: (context, state) {
                      // Last page: show "Get Started".
                      if (state.showGetStart) {
                        return GetStartBtn(
                          text: 'شروع کنید',

                          onTap: () async {
                            // Save in local storage that the intro was seen,
                            // so it won't be shown again on the next launch.
                            await locator<PrefsOperator>().changeIntroState();

                            // After an `await`, the widget may have been removed
                            // from the tree. Don't use `context` if it's gone.
                            if (!context.mounted) return;

                            // Go to the main screen and clear the whole back
                            // stack (the `false` predicate removes every route),
                            // so the user can't go back to the intro.
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              MainWrapper.routeName,
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        // Earlier pages: show "Next" with a slide-in animation.
                        return DelayedWidget(
                          delayDuration: const Duration(
                            milliseconds: 500,
                          ), // Not required
                          animationDuration: const Duration(
                            seconds: 1,
                          ), // Not required
                          animation: DelayedAnimations
                              .SLIDE_FROM_BOTTOM, // Not required
                          child: GetStartBtn(
                            text: 'ورق بزن',
                            onTap: () {
                              // Only move forward if we're not on the last page.
                              if (pageController.page!.toInt() < 2) {
                                // If we're on page 1, the next page is the last
                                // one, so switch to the "Get Started" button now.
                                if (pageController.page!.toInt() == 1) {
                                  BlocProvider.of<IntroCubit>(
                                    context,
                                  ).changeGetStart(true);
                                }
                                // Slide to the next page.
                                pageController.animateToPage(
                                  pageController.page!.toInt() + 1,
                                  duration: Duration(microseconds: 400),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),

                /// Layer 4: page indicator (bottom left), with the same
                /// slide-in animation as the "Next" button.
                Positioned(
                  bottom: height * .07,
                  left: 30,
                  child: DelayedWidget(
                    delayDuration: const Duration(
                      milliseconds: 500,
                    ), // Not required
                    animationDuration: const Duration(
                      seconds: 1,
                    ), // Not required
                    animation:
                        DelayedAnimations.SLIDE_FROM_BOTTOM, // Not required
                    child: SmoothPageIndicator(
                      // Listens to the same controller as the PageView,
                      // so the dots follow the swipe automatically.
                      controller: pageController,
                      count: 3, // Must match the number of intro pages.
                      effect: ExpandingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                        activeDotColor: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
