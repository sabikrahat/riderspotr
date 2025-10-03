import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/extensions.dart';
import '../../../models/google_maps/map_prediction_model.dart';
import 'custom_text_field.dart';

class AddressTextField extends StatefulWidget {
  final FutureOr<List<MapPredictionModel>> Function(TextEditingValue)
  optionsBuilder;
  final void Function(MapPredictionModel) onSelected;
  final String Function(MapPredictionModel) displayStringForOption;
  // final String hint;
  final String labelText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final AutocompleteOptionsViewBuilder<MapPredictionModel>? optionsViewBuilder;

  const AddressTextField({
    super.key,
    required this.optionsBuilder,
    required this.onSelected,
    required this.displayStringForOption,
    // required this.hint,
    required this.labelText,
    this.validator,
    this.optionsViewBuilder,
    this.initialValue,
  });

  @override
  State<AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  late TextEditingController _controller;
  bool _hasSetInitialValue = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<MapPredictionModel>(
      optionsBuilder: widget.optionsBuilder,
      onSelected: widget.onSelected,
      displayStringForOption: widget.displayStringForOption,
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Set initial value if not already set
            if (!_hasSetInitialValue && widget.initialValue != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  fieldTextEditingController.text = widget.initialValue!;
                  _hasSetInitialValue = true;
                }
              });
            }

            return CustomTextField(
              controller: fieldTextEditingController,
              decoration: InputDecoration(labelText: widget.labelText),
              focusNode: fieldFocusNode,
              validator: widget.validator,
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },
      optionsViewBuilder:
          widget.optionsViewBuilder ??
          (
            BuildContext ctx,
            AutocompleteOnSelected<MapPredictionModel> onSelected,
            Iterable<MapPredictionModel> options,
          ) {
            // Calculate available height considering keyboard
            final mediaQuery = MediaQuery.of(ctx);
            final keyboardHeight = mediaQuery.viewInsets.bottom;
            final screenHeight = mediaQuery.size.height;
            final availableHeight =
                screenHeight -
                keyboardHeight -
                2000; // Reserve space for input field and padding
            final maxHeight = availableHeight.clamp(150.0, 250.0);

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                    minHeight: 100,
                  ),
                  child: Container(
                    width: ctx.width - 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: options.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                options.length,
                                (index) {
                                  final option = options.elementAt(index);
                                  return Column(
                                    children: [
                                      ListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                        title: Text(
                                          widget.displayStringForOption(option),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () => onSelected(option),
                                        trailing: Icon(
                                          Icons.arrow_outward_rounded,
                                          color: ctx.theme.dividerColor,
                                          size: 20,
                                        ),
                                      ),
                                      if (index < options.length - 1)
                                        const Divider(
                                          height: 1,
                                          color: Colors.white24,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
    );
  }
}
