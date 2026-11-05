// features/feature_auth/presentation/widgets/auth_widgets.dart
import 'package:flutter/material.dart';

void showAuthSnack(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Vazir',
        ),
      ),
      backgroundColor: color,
    ),
  );
}

class AuthTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool isPassword;
  final bool isLtr; // email/password are typed left-to-right
  final VoidCallback? onSubmitted;
  final Widget? suffix;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.isPassword = false,
    this.isLtr = false,
    this.onSubmitted,
    this.suffix,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
    borderSide: BorderSide(width: width, color: color),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazir',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          obscureText: widget.isPassword && _obscure,
          textDirection: widget.isLtr ? TextDirection.ltr : null,
          textAlign: widget.isLtr ? TextAlign.left : TextAlign.start,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : widget.suffix,
            border: _border(Colors.transparent, 0),
            enabledBorder: _border(Colors.transparent, 0),
            errorBorder: _border(Colors.transparent, 0),
            focusedBorder: _border(Colors.blue, 1),
          ),
        ),
      ],
    );
  }
}

/// Shared validators, so both screens stay consistent.
class AuthValidators {
  static String? email(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'ایمیل را وارد کنید';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'ایمیل معتبر نیست';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'رمز عبور را وارد کنید';
    if (v.length < 6) return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
    return null;
  }

  static String? name(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'نام را وارد کنید';
    if (value.length < 2) return 'نام باید حداقل ۲ کاراکتر باشد';
    if (value.length > 24) return 'نام باید کمتر از ۲۴ کاراکتر باشد';
    return null;
  }
}
