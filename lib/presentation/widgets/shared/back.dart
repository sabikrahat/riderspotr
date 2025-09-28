import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Back extends StatelessWidget {
  final VoidCallback? onPressed;
  const Back({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!.call();
        } else {
          context.pop();
        }
      },
      icon: Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.white),
    );
  }
}
