import 'package:flutter/material.dart';

class ProfileListModel {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;

  /// Shown in red (logout, delete account...).
  final bool isDestructive;

  const ProfileListModel({
    required this.iconData,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}