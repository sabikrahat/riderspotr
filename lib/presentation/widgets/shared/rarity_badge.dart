import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';

enum BadgeStyle {
  solid,
  gradient,
}

class RarityBadge extends StatelessWidget {
  final Rarity rarity;
  final BadgeStyle style;

  const RarityBadge({
    super.key,
    required this.rarity,
    this.style = BadgeStyle.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = rarity.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: style == BadgeStyle.solid
            ? null
            : LinearGradient(
                colors: [
                  rarityColor.withValues(alpha: 0.2),
                  rarityColor.withValues(alpha: 0.05),
                ],
              ),
        // Elegant solid style: dark semi-transparent with subtle rarity accent
        color: style == BadgeStyle.solid
            ? Colors.black.withValues(alpha: 0.75)
            : null,
        border: Border.all(
          color: style == BadgeStyle.solid
              ? rarityColor.withValues(alpha: 0.6)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          // Soft black shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
          // Colored glow for rarity
          BoxShadow(
            color: rarityColor.withValues(
              alpha: style == BadgeStyle.solid ? 0.35 : 0.3,
            ),
            blurRadius: style == BadgeStyle.solid ? 16 : 20,
            spreadRadius: style == BadgeStyle.solid ? 0 : 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rarityColor,
              boxShadow: [
                BoxShadow(
                  color: rarityColor.withValues(alpha: 0.8),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Gap(8),
          Text(
            rarity.name.toUpperCase(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
