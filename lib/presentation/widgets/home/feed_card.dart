import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:ridespotr/presentation/widgets/shared/rarity_badge.dart';
import 'package:ridespotr/presentation/widgets/shared/xp_badge.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../pages/capture/car_preview_screen.dart';
import '../../providers/likes/likes_provider.dart';

class FeedCard extends ConsumerStatefulWidget {
  const FeedCard({
    super.key,
    required this.carSpot,
  });

  final CarSpotModel carSpot;

  @override
  ConsumerState<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends ConsumerState<FeedCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  bool _showHeartAnimation = false;

  @override
  bool get wantKeepAlive => true;

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

  void _handleDoubleTap() async {
    final likeAsync = ref.read(likeProvider(widget.carSpot.id));
    if (likeAsync is AsyncData<LikeState>) {
      final likeState = likeAsync.value;
      if (!likeState.isLiked) {
        await ref.read(likeProvider(widget.carSpot.id).notifier).toggleLike();
        setState(() {
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
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
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.95),
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
                      _buildUserHeader(widget.carSpot.userProfile?.username),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RarityBadge(
                            rarity: widget.carSpot.car?.rarity ?? Rarity.common,
                            style: BadgeStyle.solid,
                          ),
                          XpBadge(points: widget.carSpot.car?.points ?? 0),
                        ],
                      ),
                    ],
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
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(16),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Make (Bold & Large)
                      Text(
                        (widget.carSpot.car?.make?.name ?? '').toUpperCase(),
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      // Car Model (Normal weight)
                      Text(
                        (widget.carSpot.car?.model ?? '').toUpperCase(),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(12),
                      // Stats Row
                      Row(
                        children: [
                          // 0-100 km/h
                          if (widget.carSpot.car?.specs?.acceleration0100 !=
                              null)
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
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final likeAsync = ref.watch(
                                likeProvider(widget.carSpot.id),
                              );
                              return likeAsync.when(
                                data: (likeState) => Row(
                                  children: [
                                    LikeButton(
                                      isLiked: likeState.isLiked,
                                      size: 24,
                                      onTap: (isLiked) async {
                                        await ref
                                            .read(
                                              likeProvider(
                                                widget.carSpot.id,
                                              ).notifier,
                                            )
                                            .toggleLike();
                                        return !isLiked;
                                      },
                                    ),
                                    const Gap(4),
                                    Text(
                                      '${likeState.count}',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                                loading: () => Row(
                                  children: [
                                    LikeButton(
                                      isLiked: false,
                                      size: 24,
                                    ),
                                    const Gap(4),
                                    Text(
                                      '0',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                                error: (_, __) => Row(
                                  children: [
                                    LikeButton(
                                      isLiked: false,
                                      size: 24,
                                    ),
                                    const Gap(4),
                                    Text(
                                      '0',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Text(
                            _formatTimestamp(widget.carSpot.createdAt),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(String? username) {
    final userId = widget.carSpot.userProfile?.id;

    return GestureDetector(
      onTap: userId != null
          ? () {
              context.push(
                '/user-profile',
                extra: userId,
              );
            }
          : null,
      child: Row(
        children: [
          // User avatar
          Container(
            width: 40,
            height: 40,
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
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
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
      ),
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
