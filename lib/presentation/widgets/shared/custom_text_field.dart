import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
    this.onTap,
    this.style,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextStyle? style;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool obscureText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      autovalidateMode: autovalidateMode,
      readOnly: readOnly,
      onTap: onTap,
      style:
          style ??
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
    );
  }
}

/// A convenience widget for creating text fields with common validation patterns
class ValidatedTextField extends StatelessWidget {
  const ValidatedTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.readOnly = false,
    this.onTap,
    this.style,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.required = false,
    this.emailValidation = false,
    this.firstNameValidation = false,
    this.lastNameValidation = false,
    this.usernameValidation = false,
    this.customErrorText,
  });

  final String labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextStyle? style;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool required;
  final bool emailValidation;
  final bool firstNameValidation;
  final bool lastNameValidation;
  final bool usernameValidation;
  final String? customErrorText;

  @override
  Widget build(BuildContext context) {
    List<String? Function(String?)> validators = [];

    if (required) {
      validators.add(
        FormBuilderValidators.required(
          errorText: customErrorText ?? 'Please enter $labelText',
        ),
      );
    }

    if (emailValidation) {
      validators.add(
        FormBuilderValidators.email(
          errorText: 'Please enter a valid email address',
        ),
      );
    }

    if (firstNameValidation) {
      validators.add(
        FormBuilderValidators.required(
          errorText: 'Please enter a valid first name',
        ),
      );
    }

    if (lastNameValidation) {
      validators.add(
        FormBuilderValidators.required(
          errorText: 'Please enter a valid last name',
        ),
      );
    }

    if (usernameValidation) {
      validators.add(
        FormBuilderValidators.username(
          errorText: 'Please enter a valid username',
        ),
      );
    }

    if (validator != null) {
      validators.add(validator!);
    }

    return CustomTextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validators.isEmpty
          ? null
          : FormBuilderValidators.compose(validators),
      autovalidateMode: autovalidateMode,
      readOnly: readOnly,
      onTap: onTap,
      style: style,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
    );
  }
}
