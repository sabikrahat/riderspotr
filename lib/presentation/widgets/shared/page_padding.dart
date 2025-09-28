import 'package:flutter/widgets.dart';

class PagePadding extends StatelessWidget {
  final Widget child;
  const PagePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(padding: EdgeInsetsGeometry.all(16), child: child),
    );
  }
}
