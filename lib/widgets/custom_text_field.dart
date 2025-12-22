import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool showCounter;
  final InputDecoration? decoration;
  final TextStyle? textStyle; 

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.showCounter = false,
    this.decoration,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final defaultInputTextStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );
    
    final inputTextStyle = textStyle ?? defaultInputTextStyle;

    final defaultDecoration = InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,

      style: inputTextStyle,
      
      buildCounter: showCounter ? null : (context, 
      {required currentLength, required isFocused, required maxLength}) 
      => const SizedBox.shrink(),
      
      decoration: decoration ?? defaultDecoration,
    );
  }
}
