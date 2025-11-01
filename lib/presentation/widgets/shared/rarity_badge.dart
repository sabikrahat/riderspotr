import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';

class RarityBadge extends StatelessWidget {
  final Rarity rarity;

  const RarityBadge({
    super.key,
    required this.rarity,
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
        gradient: LinearGradient(
          colors: [
            rarityColor.withValues(alpha: 0.2),
            rarityColor.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: rarityColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1,
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
                  color: rarityColor,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Gap(8),
          Text(
            rarity.name.toUpperCase(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: rarityColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
