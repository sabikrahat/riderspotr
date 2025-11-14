import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ridespotr/core/extensions.dart';

class XpBadge extends StatelessWidget {
  final int points;
  final double? iconSize;
  final double? fontSize;
  const XpBadge({
    super.key,
    required this.points,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.stars_rounded,
          size: iconSize ?? 14,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        const Gap(4),
        Text(
          '$points XP',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? 11,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
