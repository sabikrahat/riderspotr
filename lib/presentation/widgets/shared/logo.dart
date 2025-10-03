import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

enum LogoVariant { full, icon }

class Logo extends StatelessWidget {
  final LogoVariant variant;
  const Logo({super.key, this.variant = LogoVariant.full});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case LogoVariant.full:
        return SvgPicture.asset('assets/logo/logo-full.svg');
      case LogoVariant.icon:
        return Placeholder();
    }
  }
}
