import 'package:flutter/material.dart';
import 'package:ridespotr/core/extensions.dart';

class ExploreTabBar extends StatefulWidget {
  const ExploreTabBar({super.key});

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
        border: Border.all(color: Colors.grey[850]!),
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey.shade900,
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabItem(
              text: '24 HR',
              isSelected: true,
            ),
            _VerticalDivider(),
            _TabItem(
              text: '7 DAYS',
              isSelected: false,
            ),
            _VerticalDivider(),
            _TabItem(
              text: 'ALL',
              isSelected: false,
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
  const _TabItem({
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
