import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/bottom_nav.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';

class MainWrapper extends StatefulWidget {
  static const routeName = '/main_wrapper';
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late final PageController _pageController;

  static const List<Widget> _screens = [
    ColoredBox(color: Colors.red),
    ColoredBox(color: Colors.black),
    ColoredBox(color: Colors.amber),
    ColoredBox(color: Colors.green),
  ];
  // static const List<Widget> _screens = [
  //   Center(child: Text('PAGE 0', style: TextStyle(fontSize: 32))),
  //   Center(child: Text('PAGE 1', style: TextStyle(fontSize: 32))),
  //   Center(child: Text('PAGE 2', style: TextStyle(fontSize: 32))),
  //   Center(child: Text('PAGE 3', style: TextStyle(fontSize: 32))),
  // ];

  @override
  void initState() {
    super.initState();
    debugPrint('MainWrapper initState: ${identityHashCode(this)}');
    _pageController = PageController(
      initialPage: context.read<BottomNavCubit>().state,
    );
  }

  @override
  void dispose() {
    debugPrint('MainWrapper dispose: ${identityHashCode(this)}');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavCubit, int>(
      listener: (context, index) {
        // Guard 1: PageView not built yet
        if (!_pageController.hasClients) return;
        // Guard 2: the change came from swiping, so the page is already there
        if (_pageController.page?.round() == index) return;

        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        bottomNavigationBar: const BottomNav(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (i) =>
              context.read<BottomNavCubit>().changeSelectedIndex(i),
          children: _screens,
        ),
      ),
    );
  }
}

// class MainWrapper extends StatelessWidget {
//   static const routeName = '/main_wrapper';
//   MainWrapper({super.key});
//   PageController pageController = PageController();

//   List<Widget> topLevelScreens = [
//     Container(color: Colors.red),
//     Container(color: Colors.black),
//     Container(color: Colors.amber),
//     Container(color: Colors.green),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNav(controller: pageController),
//       body: PageView(controller: pageController, children: topLevelScreens),
//     );
//   }
// }
