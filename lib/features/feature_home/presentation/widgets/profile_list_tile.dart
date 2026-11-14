import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileListTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Colors.grey.shade700;

    return ListTile(
      onTap: onTap,
      leading: Icon(iconData, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Vazir',
        ),
      ),
      // The app is right-to-left, so "forward" points left.
      trailing: Icon(Icons.chevron_left, color: color),
    );
  }
}
