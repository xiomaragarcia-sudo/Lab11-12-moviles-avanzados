import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Campo de texto Cupertino con el estilo del diseño (borde gris redondeado).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.placeholder,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String placeholder;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      style: const TextStyle(fontSize: 16, color: AppColors.text),
      placeholderStyle: const TextStyle(fontSize: 16, color: AppColors.placeholder),
      prefix: prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(prefixIcon, color: AppColors.textMuted, size: 20),
            ),
      suffix: suffix == null
          ? null
          : Padding(padding: const EdgeInsets.only(right: 4), child: suffix),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
