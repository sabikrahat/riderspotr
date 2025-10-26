import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:ridespotr/core/extensions.dart';

class CarDetailTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  const CarDetailTabBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Stack(
        children: [
          // Glass background
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.grey[800]!,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(100),
              child: SizedBox(
                height: 55,
                width: double.infinity,
              ).asGlass(),
            ),
          ),
          // Animated sliding indicator
          Container(
            height: 57,
            padding: const EdgeInsets.all(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / 3;
                return AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment(
                    -1 + (selectedIndex * 2 / 2),
                    0,
                  ),
                  child: Container(
                    width: tabWidth,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.grey[850]!,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black26,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Tab items
          Container(
            height: 55,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                _TabItem(
                  text: 'Production',
                  isSelected: selectedIndex == 0,
                  onTap: () => onSelect(0),
                ),
                _TabItem(
                  text: 'Specs',
                  isSelected: selectedIndex == 1,
                  onTap: () => onSelect(1),
                ),
                _TabItem(
                  text: 'History',
                  isSelected: selectedIndex == 2,
                  onTap: () => onSelect(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onTap;
  const _TabItem({
    required this.text,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: context.textTheme.bodySmall!.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
