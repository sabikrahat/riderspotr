import 'dart:async';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/story/story_model.dart';
import '../../../models/user/story_user_model.dart';

class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({
    super.key,
    required this.initialUserIndex,
    required this.storyUsers,
    required this.storiesMap,
  });

  static const String routeName = '/story-viewer';

  final int initialUserIndex;
  final List<StoryUserModel> storyUsers;
  final Map<String, List<StoryItemModel>> storiesMap;

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentUserIndex;
  int _currentStoryIndex = 0;
  late AnimationController _progressController;
  Timer? _storyTimer;
  double _dragOffset = 0;

  List<StoryItemModel> get _currentUserStories =>
      widget.storiesMap[widget.storyUsers[_currentUserIndex].id] ?? [];

  @override
  void initState() {
    super.initState();
    _currentUserIndex = widget.initialUserIndex;
    _pageController = PageController(initialPage: _currentUserIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _startStory();
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startStory() {
    _progressController.forward(from: 0);
    _storyTimer?.cancel();
    _storyTimer = Timer(const Duration(seconds: 10), () {
      _nextStory();
    });
  }

  void _pauseStory() {
    _progressController.stop();
    _storyTimer?.cancel();
  }

  void _resumeStory() {
    _progressController.forward();
    final remaining = (1 - _progressController.value) * 10000;
    _storyTimer?.cancel();
    _storyTimer = Timer(Duration(milliseconds: remaining.toInt()), () {
      _nextStory();
    });
  }

  void _nextStory() {
    if (_currentStoryIndex < _currentUserStories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _startStory();
    } else {
      _nextUser();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _startStory();
    } else {
      _previousUser();
    }
  }

  void _nextUser() {
    if (_currentUserIndex < widget.storyUsers.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _pageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStory();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousUser() {
    if (_currentUserIndex > 0) {
      setState(() {
        _currentUserIndex--;
        _currentStoryIndex = 0;
      });
      _pageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStory();
    }
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _pauseStory();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      // Clamp the drag offset to prevent upward drag
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {

    // If dragged down more than 150 pixels, dismiss
    if (_dragOffset > 150) {
      Navigator.of(context).pop();
    } else {
      // Animate back to original position
      setState(() {
        _dragOffset = 0;
      });
      _resumeStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final opacity = 1.0 - (_dragOffset / 400).clamp(0.0, 1.0);
    final scale = 1.0 - (_dragOffset / 1000).clamp(0.0, 0.1);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: opacity),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        onTapDown: (details) {
          _pauseStory();
        },
        onTapUp: (details) {
          _resumeStory();
        },
        onTapCancel: () {
          _resumeStory();
        },
        onLongPressStart: (_) {
          _pauseStory();
        },
        onLongPressEnd: (_) {
          _resumeStory();
        },
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: Transform.scale(
            scale: scale,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.storyUsers.length,
              itemBuilder: (context, userIndex) {
                if (userIndex != _currentUserIndex) {
                  return const SizedBox.shrink();
                }

                final stories =
                    widget.storiesMap[widget.storyUsers[userIndex].id] ?? [];
                if (stories.isEmpty) return const SizedBox.shrink();

                final storyUser = widget.storyUsers[userIndex];

                return _StoryContent(
                  key: ValueKey('${storyUser.id}_$_currentStoryIndex'),
                  story: stories[_currentStoryIndex],
                  storyIndex: _currentStoryIndex,
                  totalStories: stories.length,
                  progressController: _progressController,
                  onTapLeft: _previousStory,
                  onTapRight: _nextStory,
                  onClose: () => Navigator.of(context).pop(),
                  username: storyUser.username,
                  profilePictureUrl: storyUser.profilePictureUrl,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryContent extends StatelessWidget {
  final StoryItemModel story;
  final int storyIndex;
  final int totalStories;
  final AnimationController progressController;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final VoidCallback onClose;
  final String? username;
  final String? profilePictureUrl;

  const _StoryContent({
    super.key,
    required this.story,
    required this.storyIndex,
    required this.totalStories,
    required this.progressController,
    required this.onTapLeft,
    required this.onTapRight,
    required this.onClose,
    this.username,
    this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Story Image
        Positioned.fill(
          child: FastCachedImage(
            url: story.imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
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
                color: Colors.black,
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

        // Top gradient overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                // Progress bars
                Row(
                  children: List.generate(
                    totalStories,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index < totalStories - 1 ? 4 : 0,
                        ),
                        child: _ProgressBar(
                          isActive: index == storyIndex,
                          isCompleted: index < storyIndex,
                          animationController: progressController,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // User info
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            profilePictureUrl != null &&
                                profilePictureUrl!.isNotEmpty
                            ? FastCachedImage(
                                url: profilePictureUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, exception, stacktrace) {
                                  return _buildDefaultAvatar();
                                },
                                loadingBuilder: (context, progress) {
                                  return _buildDefaultAvatar();
                                },
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                    const Gap(12),
                    // Username and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username ?? 'Unknown',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _formatTimestamp(story.createdAt),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close button
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bottom car info overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 350,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              top: 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.95),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  story.carMake.toUpperCase(),
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Gap(4),
                Text(
                  story.carModel.toUpperCase(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (story.address.isNotEmpty) ...[
                  const Gap(8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          story.address,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
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
        ),

        // Tap areas for navigation
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTapLeft,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTapRight,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.white.withValues(alpha: 0.5),
          size: 18,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final AnimationController animationController;

  const _ProgressBar({
    required this.isActive,
    required this.isCompleted,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white.withValues(alpha: 0.3),
      ),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: isActive
                ? animationController.value
                : isCompleted
                ? 1.0
                : 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
