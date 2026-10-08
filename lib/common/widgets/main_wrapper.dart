import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:shopping/common/widgets/bottom_nav.dart';

/// The main shell of the app: a [PageView] with one page per tab,
/// and a [BottomNav] bar at the bottom.
///
/// [BottomNavCubit] is the single source of truth for the selected tab:
///  - Tap on a tab  -> Cubit changes -> [BlocListener] slides the PageView.
///  - Swipe a page  -> onPageChanged -> Cubit changes -> bar highlight updates.
class MainWrapper extends StatefulWidget {
  /// Name used in the `routes` map of MaterialApp.
  static const routeName = '/main_wrapper';
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  /// Controls the PageView. It must be created once and disposed manually,
  /// which is why this widget is a StatefulWidget.
  late final PageController _pageController;

  /// Page we are animating towards after a tab tap (null = not animating).
  /// While it is not null, [_onPageChanged] ignores the in-between pages
  /// that the animation passes, so the highlight does not flicker.
  int? _animatingTo;

  /// The content of each tab (placeholders for now).
  /// `static const` means the list is created once, not on every instance.
  static const List<Widget> _screens = [
    ColoredBox(color: Colors.red),
    ColoredBox(color: Colors.black),
    ColoredBox(color: Colors.amber),
    ColoredBox(color: Colors.green),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('MainWrapper initState: ${identityHashCode(this)}');

    // Start on the tab the Cubit remembers, so the PageView and the
    // bottom bar always begin in sync. `read` is correct here:
    // we need the value once, and `watch` is not allowed in initState.
    _pageController = PageController(
      initialPage: context.read<BottomNavCubit>().state,
    );
  }

  @override
  void dispose() {
    debugPrint('MainWrapper dispose: ${identityHashCode(this)}');
    // Always dispose controllers to avoid memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  /// Slides the PageView to [index]. Called whenever the Cubit emits.
  void _goToPage(int index) {
    // Guard 1: the PageView is not attached yet, so there is nothing to move.
    if (!_pageController.hasClients) return;

    // Guard 2: the PageView is already on this page (the change came from
    // a swipe), so animating again would be useless.
    if (_pageController.page?.round() == index) return;

    // Remember our target so _onPageChanged can ignore the pages in between.
    _animatingTo = index;

    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .whenComplete(() {
          // A newer tap may have replaced the target while this animation
          // was running, so only clear the value if it is still ours.
          if (_animatingTo == index) _animatingTo = null;
        });
  }

  /// Called by the PageView every time the visible page changes.
  void _onPageChanged(int index) {
    // The page changed because of our own tap animation (we passed through
    // pages 1 and 2 on the way to 3), so do not write to the Cubit.
    if (_animatingTo != null) return;

    // The user swiped, so the PageView is the truth: update the Cubit.
    context.read<BottomNavCubit>().changeSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // BlocListener is for side effects (moving the PageView), not for
    // building UI. It does not rebuild its child when the state changes.
    return BlocListener<BottomNavCubit, int>(
      listener: (context, index) => _goToPage(index),
      child: Scaffold(
        // The bar listens to the Cubit by itself (BlocBuilder inside it).
        bottomNavigationBar: const BottomNav(),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _screens,
        ),
      ),
    );
  }
}