import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridespotr/core/extensions.dart';

class LongButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  const LongButton({super.key, this.text, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(context.width, 45)),
      ),
      onPressed: () => onPressed?.call(),
      child: child ?? Text(text ?? 'Continue'),
    );
  }
}
