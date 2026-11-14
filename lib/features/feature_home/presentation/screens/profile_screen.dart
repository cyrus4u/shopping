import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/features/feature_auth/data/models/auth_user_model.dart';
import 'package:shopping/features/feature_auth/presentation/widgets/auth_widgets.dart';
import 'package:shopping/features/feature_home/presentation/utils/profile_list_model.dart';
import 'package:shopping/features/feature_home/presentation/widgets/profile_list_tile.dart';
import 'package:shopping/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context) {
    showAuthSnack(context, 'این بخش به‌زودی اضافه می‌شود', Colors.grey.shade700);
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('خروج از حساب', style: TextStyle(fontFamily: 'Vazir')),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید خارج شوید؟',
          style: TextStyle(fontFamily: 'Vazir'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Vazir')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'خروج',
              style: TextStyle(fontFamily: 'Vazir', color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Grab the cubit before the await: this screen leaves the tree as soon as
    // the sign-out redirects to the login screen.
    final navCubit = context.read<BottomNavCubit>();

    try {
      // Signs out of Supabase and clears local data. The `signedOut` listener
      // in main.dart then sends the user to the login screen.
      await locator<PrefsOperator>().logout();

      // Next login starts on the Home tab, not on this tab.
      navCubit.changeSelectedIndex(0);
    } catch (_) {
      if (context.mounted) {
        showAuthSnack(context, 'خروج ناموفق بود. دوباره تلاش کنید', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final model = user == null ? null : AuthUserModel.fromUser(user, null);

    // Built here (not as a field) because the callbacks need `context`.
    final items = <ProfileListModel>[
      ProfileListModel(
        iconData: Icons.person,
        title: 'حساب کاربری شخصی',
        onTap: () => _comingSoon(context),
      ),
      ProfileListModel(
        iconData: Icons.shopping_bag_outlined,
        title: 'حساب کاربری فروشگاهی',
        onTap: () => _comingSoon(context),
      ),
      ProfileListModel(
        iconData: Icons.inventory_2_outlined,
        title: 'سفارشات',
        onTap: () => _comingSoon(context),
      ),
      ProfileListModel(
        iconData: Icons.home_work,
        title: 'آدرس من',
        onTap: () => _comingSoon(context),
      ),
      ProfileListModel(
        iconData: Icons.support_agent,
        title: 'پشتیبانی',
        onTap: () => _comingSoon(context),
      ),
      ProfileListModel(
        iconData: Icons.exit_to_app,
        title: 'خروج از حساب',
        isDestructive: true,
        onTap: () => _confirmLogout(context),
      ),
    ];

    // A ListView (not Column + shrinkWrap) scrolls on small screens
    // instead of overflowing.
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.person, size: 44, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          model?.displayName ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazir',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          model?.email ?? '',
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < items.length; i++) ...[
          ProfileListTile(
            iconData: items[i].iconData,
            title: items[i].title,
            onTap: items[i].onTap,
            isDestructive: items[i].isDestructive,
          ),
          if (i != items.length - 1)
            const Divider(height: 1, indent: 16, endIndent: 16),
        ],
      ],
    );
  }
}