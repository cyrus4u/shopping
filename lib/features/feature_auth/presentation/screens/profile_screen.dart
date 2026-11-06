// features/feature_auth/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/features/feature_auth/data/models/auth_user_model.dart';
import 'package:shopping/features/feature_auth/presentation/widgets/auth_widgets.dart';
import 'package:shopping/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

    // Grab the cubit before the await: this screen is removed from the tree
    // as soon as the sign-out redirects to the login screen.
    final navCubit = context.read<BottomNavCubit>();

    try {
      // Signs out of Supabase and clears local data. The `signedOut` listener
      // in main.dart then sends the user to the login screen.
      await locator<PrefsOperator>().logout();

      // Start on the Home tab next time, not on this tab.
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

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 44,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            model?.displayName ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model?.email ?? '',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text(
                'خروج از حساب',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}