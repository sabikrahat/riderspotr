import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/user/xp_level_model.dart';

class XpProgressionCard extends StatefulWidget {
  const XpProgressionCard({
    super.key,
    required this.rarityColor,
    required this.points,
    required this.currentLevel,
    required this.currentProgress,
    required this.newLevel,
    required this.newProgress,
    required this.xpLevels,
  });

  final Color rarityColor;
  final int points;
  final int currentLevel;
  final double currentProgress;
  final int newLevel;
  final double newProgress;
  final List<XpLevelModel> xpLevels;

  @override
  State<XpProgressionCard> createState() => _XpProgressionCardState();
}

class _XpProgressionCardState extends State<XpProgressionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentAnimatingLevel = 0;
  double _currentAnimatingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentAnimatingLevel = widget.currentLevel;
    _currentAnimatingProgress = widget.currentProgress;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startLevelProgression();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startLevelProgression() async {
    final levelsToGain = widget.newLevel - widget.currentLevel;

    if (levelsToGain == 0) {
      // Just animate to the new progress on current level
      _animateToProgress(widget.newProgress);
    } else {
      // Animate through each level
      for (int i = 0; i <= levelsToGain; i++) {
        final targetLevel = widget.currentLevel + i;

        if (i == 0) {
          // First animation: from current progress to 100%
          await _animateToProgress(1.0);
        } else if (i == levelsToGain) {
          // Last animation: from 0 to final progress
          setState(() {
            _currentAnimatingLevel = targetLevel;
            _currentAnimatingProgress = 0.0;
          });
          await _animateToProgress(widget.newProgress);
        } else {
          // Middle animations: from 0 to 100%
          setState(() {
            _currentAnimatingLevel = targetLevel;
            _currentAnimatingProgress = 0.0;
          });
          await _animateToProgress(1.0);
        }

        // Small delay between level transitions
        if (i < levelsToGain) {
          await Future.delayed(const Duration(milliseconds: 150));
        }
      }
    }
  }

  Future<void> _animateToProgress(double targetProgress) async {
    final startProgress = _currentAnimatingProgress;
    _animationController.reset();

    final animation =
        Tween<double>(
          begin: startProgress,
          end: targetProgress,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    animation.addListener(() {
      setState(() {
        _currentAnimatingProgress = animation.value;
      });
    });

    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // XP Gain
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_bolt_rounded,
              color: widget.rarityColor,
              size: 20,
            ),
            Gap(6),
            Text(
              '+${widget.points} XP',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.rarityColor,
                letterSpacing: 1,
                fontSize: 22,
              ),
            ),
          ],
        ),
        Gap(12),
        // Progress Bar with level labels
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LEVEL $_currentAnimatingLevel',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'LEVEL ${_currentAnimatingLevel + 1}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: _currentAnimatingLevel == widget.newLevel
                        ? widget.rarityColor
                        : Colors.white.withValues(alpha: 0.5),
                    fontWeight: _currentAnimatingLevel == widget.newLevel
                        ? FontWeight.bold
                        : FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            Gap(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Animated progress bar
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _currentAnimatingProgress.clamp(0.0, 1.0),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.rarityColor,
                                widget.rarityColor.withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.rarityColor.withValues(
                                  alpha: 0.6,
                                ),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
