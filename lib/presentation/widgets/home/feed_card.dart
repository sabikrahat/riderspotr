import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../pages/capture/car_preview_screen.dart';
import '../../providers/auth/profile_provider.dart';

class FeedCard extends ConsumerStatefulWidget {
  const FeedCard({
    super.key,
    required this.carSpot,
    required this.onLike,
  });

  final CarSpotModel carSpot;
  final VoidCallback onLike;

  @override
  ConsumerState<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends ConsumerState<FeedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  bool _showHeartAnimation = false;
  bool _isLiked = false; // TODO: Get from backend

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _likeScaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!_isLiked) {
      widget.onLike();
      setState(() {
        _isLiked = true;
        _showHeartAnimation = true;
      });
      _likeAnimationController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _likeAnimationController.reverse();
            setState(() {
              _showHeartAnimation = false;
            });
          }
        });
      });
    }
  }

  void _handleLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onLike();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(widget.carSpot.user));

    return GestureDetector(
      onTap: () {
        context.push(
          CarPreviewScreen.routeName,
          extra: widget.carSpot,
        );
      },
      onDoubleTap: _handleDoubleTap,
      child: Container(
        height: 480,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Car Image - Full
              Positioned.fill(
                child: FastCachedImage(
                  key: Key(widget.carSpot.id),
                  url: widget.carSpot.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 500),
                  errorBuilder: (context, exception, stacktrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.white24,
                          size: 64,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white24,
                          value: progress.progressPercentage.value,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Top Gradient Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Gradient Overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),

              // Heart animation overlay (center)
              if (_showHeartAnimation)
                Center(
                  child: ScaleTransition(
                    scale: _likeScaleAnimation,
                    child: Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),

              // User Header (Top)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: profileAsync.when(
                  loading: () => _buildUserHeader(null),
                  error: (_, __) => _buildUserHeader(null),
                  data: (_) {
                    final user = ref
                        .read(profileProvider(widget.carSpot.user).notifier)
                        .user;
                    return _buildUserHeader(user?.username);
                  },
                ),
              ),

              // Rarity Badge (Top Right)
              Positioned(
                top: 70,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Text(
                    widget.carSpot.car?.rarity.name.toUpperCase() ?? 'COMMON',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: widget.carSpot.car?.rarity.color,
                    ),
                  ),
                ),
              ),

              // Car Info (Bottom)
              Positioned(
                left: 16,
                right: 16,
                bottom: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.carSpot.car?.make?.name ?? '').toUpperCase(),
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      (widget.carSpot.car?.model ?? '').toUpperCase(),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(12),
                    // Stats Row
                    Row(
                      children: [
                        // 0-100 km/h
                        if (widget.carSpot.car?.specs?.acceleration0100 != null)
                          Expanded(
                            child: _StatItem(
                              label: '0-100',
                              value:
                                  '${widget.carSpot.car!.specs!.acceleration0100!.toStringAsFixed(1)}s',
                              icon: Icons.speed,
                            ),
                          ),
                        // Horsepower
                        if (widget.carSpot.car?.specs?.powerKw != null)
                          Expanded(
                            child: _StatItem(
                              label: 'POWER',
                              value:
                                  '${(widget.carSpot.car!.specs!.powerKw! * 1.34102).toInt()}hp',
                              icon: Icons.flash_on,
                            ),
                          ),
                        // Top Speed
                        if (widget.carSpot.car?.specs?.topSpeedKmh != null)
                          Expanded(
                            child: _StatItem(
                              label: 'TOP SPEED',
                              value:
                                  '${widget.carSpot.car!.specs!.topSpeedKmh}km/h',
                              icon: Icons.speed,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Bar (Bottom)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  children: [
                    // Like button
                    GestureDetector(
                      onTap: _handleLikeTap,
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(_isLiked),
                              color: _isLiked
                                  ? Colors.red.shade400
                                  : Colors.white.withValues(alpha: 0.9),
                              size: 24,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '0', // TODO: Get actual like count from backend
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Comment button
                    // GestureDetector(
                    //   onTap: () {
                    //     // TODO: Navigate to comments
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.chat_bubble_outline,
                    //         color: Colors.white.withValues(alpha: 0.9),
                    //         size: 22,
                    //       ),
                    //       const Gap(8),
                    //       Text(
                    //         '0',
                    //         style: context.textTheme.bodyMedium?.copyWith(
                    //           fontWeight: FontWeight.w600,
                    //           color: Colors.white.withValues(alpha: 0.9),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Spacer(),

                    // Timestamp
                    Text(
                      _formatTimestamp(widget.carSpot.createdAt),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(String? username) {
    return Row(
      children: [
        // User avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Icon(
            Icons.person,
            color: Colors.white.withValues(alpha: 0.6),
            size: 18,
          ),
        ),
        const Gap(12),
        // Username and location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username ?? 'Unknown User',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              if (widget.carSpot.address.isNotEmpty) ...[
                const Gap(2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        widget.carSpot.address,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
