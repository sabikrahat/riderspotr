import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../../core/extensions.dart';

class RarityChip extends StatelessWidget {
  final Rarity rarity;
  const RarityChip({super.key, required this.rarity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: rarity.color,
        ),
        boxShadow: [
          BoxShadow(
            color: rarity.color.withValues(
              alpha: 0.25,
            ),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Text(
          rarity.name.toUpperCase(),
          style: context.textTheme.bodySmall?.copyWith(
            color: rarity.color,
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
