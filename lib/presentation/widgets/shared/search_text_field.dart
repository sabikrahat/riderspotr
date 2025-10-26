import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  const SearchTextField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onClear,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade900,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        suffixIcon: showClearButton
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onClear,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
      ),
    );
  }
}
