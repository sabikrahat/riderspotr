import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

class AnimatedPrivacyToggle extends StatelessWidget {
  final bool isPublic;
  final VoidCallback onToggle;

  const AnimatedPrivacyToggle({
    super.key,
    required this.isPublic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.fromLTRB(isPublic ? 12 : 0, 5, isPublic ? 0 : 12, 5),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isPublic ? 0 : 44,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isPublic ? 0 : 1,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(width: isPublic ? 0 : 4),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: context.textTheme.bodySmall?.fontFamily,
              ),
              child: Text(isPublic ? 'Public' : 'Private'),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(width: isPublic ? 4 : 0),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isPublic ? 44 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isPublic ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_open,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
