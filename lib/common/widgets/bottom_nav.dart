import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/bottom_nav_cubit/bottom_nav_cubit.dart';

// import '../../features/feature_auth/presentation/screens/mobile_signup_screen.dart';


class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  

  void _onItemTap(BuildContext context, int index) {
    context.read<BottomNavCubit>().changeSelectedIndex(index);
    
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      padding: EdgeInsets.zero, // remove the M3 default 16px side padding
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: Colors.white,
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, selectedIndex) {
          Widget buildItem({
            required int index,
            required String label,
            required Widget Function(Color color) iconBuilder,
          }) {
            return _NavItem(
              label: label,
              selected: selectedIndex == index,
              onTap: () => _onItemTap(context, index),
              iconBuilder: iconBuilder,
            );
          }

          return Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildItem(
                      index: 0,
                      label: 'بیسینیور',
                      iconBuilder: (color) => Image.asset(
                        selectedIndex == 0
                            ? 'assets/images/home_icon.png'
                            : 'assets/images/home_icon2.png',
                        color: color,
                        fit: BoxFit.contain,
                      ),
                    ),
                    buildItem(
                      index: 1,
                      label: 'دسته بندی',
                      iconBuilder: (color) => Image.asset(
                        selectedIndex == 1
                            ? 'assets/images/category_icon.png'
                            : 'assets/images/category_icon2.png',
                        color: color,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildItem(
                      index: 2,
                      label: 'حساب کاربری',
                      iconBuilder: (color) => SvgPicture.asset(
                        selectedIndex == 2
                            ? 'assets/images/person_icon.svg'
                            : 'assets/images/person_icon2.svg',
                        // `color:` is deprecated in flutter_svg, use colorFilter
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                    ),
                    buildItem(
                      index: 3,
                      label: 'سبد خرید',
                      iconBuilder: (color) => Icon(
                        selectedIndex == 3
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: color,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.iconBuilder,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget Function(Color color) iconBuilder;

  static const double _iconBoxSize = 28;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.red : Colors.grey.shade700;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min, // only take the space needed
          children: [
            // Fixed box = every icon has the same size, whatever the asset is
            SizedBox(
              width: _iconBoxSize,
              height: _iconBoxSize,
              child: iconBuilder(color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Yekan',
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BottomNav extends StatelessWidget {
//   final PageController controller;

//   const BottomNav({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var primaryColor = Theme.of(context).primaryColor;
//     TextTheme textTheme = Theme.of(context).textTheme;

//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 5,
//       color: Colors.white,
//       padding: EdgeInsets.zero, // remove the M3 default 16px side padding
//       child: SizedBox(
//         height: 72,
//         child: BlocBuilder<BottomNavCubit, int>(
//           builder: (context, int state) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width / 2,
//                   height: 72,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               /// change selected index
//                               BlocProvider.of<BottomNavCubit>(
//                                 context,
//                               ).changeSelectedIndex(0);
//                               controller.animateToPage(
//                                 0,
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               );
//                             },
//                             icon: Image.asset(
//                               state == 0
//                                   ? "assets/images/home_icon.png"
//                                   : "assets/images/home_icon2.png",
//                               color: state == 0
//                                   ? Colors.red
//                                   : Colors.grey.shade700,
//                             ),
//                           ),
//                           Text(
//                             'بیسینیور',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: 'Yekan',
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               BlocProvider.of<BottomNavCubit>(
//                                 context,
//                               ).changeSelectedIndex(1);
//                               controller.animateToPage(
//                                 1,
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               );
//                             },
//                             icon: Image.asset(
//                               state == 1
//                                   ? "assets/images/category_icon.png"
//                                   : "assets/images/category_icon2.png",
//                               color: state == 1
//                                   ? Colors.red
//                                   : Colors.grey.shade700,
//                               width: 40,
//                             ),
//                           ),
//                           Text(
//                             'دسته بندی',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: 'Yekan',
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width / 2,
//                   height: 72,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               BlocProvider.of<BottomNavCubit>(
//                                 context,
//                               ).changeSelectedIndex(2);
//                               controller.animateToPage(
//                                 2,
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               );
//                             },
//                             icon: SvgPicture.asset(
//                               state == 2
//                                   ? "assets/images/person_icon.svg"
//                                   : "assets/images/person_icon2.svg",
//                               color: state == 2
//                                   ? Colors.red
//                                   : Colors.grey.shade700,
//                               width: 48,
//                             ),
//                           ),
//                           Text(
//                             'حساب کاربری',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: 'Yekan',
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () async {
//                               BlocProvider.of<BottomNavCubit>(
//                                 context,
//                               ).changeSelectedIndex(3);
//                               controller.animateToPage(
//                                 3,
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               );
//                             },
//                             icon: Icon(
//                               state == 3
//                                   ? Icons.shopping_cart
//                                   : Icons.shopping_cart_outlined,
//                               color: state == 3
//                                   ? Colors.red
//                                   : Colors.grey.shade700,
//                               size: 27,
//                             ),
//                           ),
//                           Text(
//                             'سبد خرید',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: 'Yekan',
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<bool> getDataFromPrefs() async {
//     // Obtain shared preferences.
//     final prefs = await SharedPreferences.getInstance();
//     final bool loggedIn = prefs.getBool('user_loggedIn') ?? false;

//     return loggedIn;
//   }
// }
