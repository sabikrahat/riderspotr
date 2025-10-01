import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/extensions.dart';

class KMapLocationInputField<T extends Object> extends StatelessWidget {
  final FutureOr<List<T>> Function(TextEditingValue) optionsBuilder;
  final void Function(T) onSelected;
  final String Function(T) displayStringForOption;
  final String hint;
  final String? Function(String?)? validator;
  // final void Function(String?)? onChanged;
  final String? initialValue;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  const KMapLocationInputField({
    super.key,
    required this.optionsBuilder,
    required this.onSelected,
    required this.displayStringForOption,
    required this.hint,
    this.validator,
    // this.onChanged,
    this.optionsViewBuilder,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            fieldTextEditingController.text = initialValue ?? '';
            return TextFormField(
              controller: fieldTextEditingController,
              decoration: InputDecoration(hintText: hint),
              // onChanged: onChanged,
              focusNode: fieldFocusNode,
              validator: validator,
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },
      optionsViewBuilder:
          optionsViewBuilder ??
          (BuildContext ctx, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.black,
                child: SizedBox(
                  width: ctx.width - 32,
                  height: 300,
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          displayStringForOption(option),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () => onSelected(option),
                        trailing: Icon(Icons.arrow_outward_rounded, color: ctx.theme.dividerColor),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }
}
