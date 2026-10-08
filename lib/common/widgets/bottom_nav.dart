import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/bottom_nav_cubit/bottom_nav_cubit.dart';

/// Custom bottom bar with 4 tabs and a center notch for a docked FAB.
///
/// This widget only does two things:
///  - SHOWS which tab is selected (by listening to [BottomNavCubit]).
///  - REPORTS taps (by writing the tapped index to [BottomNavCubit]).
///
/// It does not move the pages. `MainWrapper` listens to the Cubit and
/// slides the PageView, so this bar stays simple and reusable.
class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  /// Handles a tap on a tab by telling the Cubit which tab is selected.
  /// `read` is correct here: we are in a callback and only SEND a value,
  /// we don't need to rebuild when the state changes.
  void _onItemTap(BuildContext context, int index) {
    context.read<BottomNavCubit>().changeSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      padding: EdgeInsets.zero, // remove the M3 default 16px side padding
      shape: const CircularNotchedRectangle(), // round cut-out for a docked FAB
      notchMargin: 5, // gap between the FAB and the edge of the notch
      color: Colors.white,
      // Only this subtree rebuilds when the selected index changes,
      // not the whole screen.
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, selectedIndex) {
          // Small helper so we don't repeat the same _NavItem setup 4 times.
          // It lives inside the builder because it needs `selectedIndex`.
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
              // Left half: tabs 0 and 1.
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildItem(
                      index: 0,
                      label: 'بیسینیور',
                      // PNG icon: filled version when selected, outline otherwise.
                      iconBuilder: (color) => Image.asset(
                        selectedIndex == 0
                            ? 'assets/images/home_icon.png'
                            : 'assets/images/home_icon2.png',
                        // Tints the image (needs a transparent PNG).
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
              // Right half: tabs 2 and 3. The gap between the two halves
              // is where the docked FAB will sit.
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildItem(
                      index: 2,
                      label: 'حساب کاربری',
                      // SVG icon, same filled/outline idea.
                      iconBuilder: (color) => SvgPicture.asset(
                        selectedIndex == 2
                            ? 'assets/images/person_icon.svg'
                            : 'assets/images/person_icon2.svg',
                        // `color:` is deprecated in flutter_svg, use colorFilter.
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                    ),
                    buildItem(
                      index: 3,
                      label: 'سبد خرید',
                      // Built-in Material icon, no asset needed.
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

/// A single tab: an icon on top and a label below.
///
/// It is private (`_NavItem`) because only [BottomNav] uses it.
/// It is "dumb": it gets everything from its parent and has no state.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.iconBuilder,
  });

  /// Text shown under the icon.
  final String label;

  /// Whether this tab is the current one (decides color and font weight).
  final bool selected;

  /// Called when the user taps this tab.
  final VoidCallback onTap;

  /// Builds the icon using the color chosen by this item (red / grey).
  /// This way the item doesn't care if the icon is a PNG, an SVG or an [Icon].
  final Widget Function(Color color) iconBuilder;

  /// Fixed icon size, so every icon looks the same whatever the asset is.
  static const double _iconBoxSize = 28;

  @override
  Widget build(BuildContext context) {
    // One place decides the color for both the icon and the text.
    final color = selected ? Colors.red : Colors.grey.shade700;

    return InkWell(
      onTap: onTap,
      // Clips the ripple effect to a rounded shape.
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min, // only take the space needed
          children: [
            SizedBox(
              width: _iconBoxSize,
              height: _iconBoxSize,
              child: iconBuilder(color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              // Avoids wrapping to a second line on small screens.
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Yekan',
                color: color,
                // Slightly bolder text for the active tab.
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}