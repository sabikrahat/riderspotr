import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

class ExploreTabBar extends StatefulWidget {
  const ExploreTabBar({
    super.key,
    required this.selectedText,
    this.onChanged,
  });

  final String selectedText;
  final void Function(String)? onChanged;

  @override
  State<ExploreTabBar> createState() => _ExploreTabBarState();
}

class _ExploreTabBarState extends State<ExploreTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[900]!),
        borderRadius: BorderRadius.circular(100),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabItem(
              text: '24 HR',
              isSelected: widget.selectedText == '24 HR',
              onTap: () {
                widget.onChanged?.call('24 HR');
              },
            ),
            _VerticalDivider(),
            _TabItem(
              text: '7 DAYS',
              isSelected: widget.selectedText == '7 DAYS',
              onTap: () {
                widget.onChanged?.call('7 DAYS');
              },
            ),
            _VerticalDivider(),
            _TabItem(
              text: 'ALL',
              isSelected: widget.selectedText == 'ALL',
              onTap: () {
                widget.onChanged?.call('ALL');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: 1,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[850],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function()? onTap;

  const _TabItem({
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.transparent,
          ),
          child: Text(
            text,
            style: context.textTheme.headlineSmall!.copyWith(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
