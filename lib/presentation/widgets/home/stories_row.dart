import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/story/story_model.dart';
import '../../../models/user/story_user_model.dart';
import '../../../services/story/story_service.dart';
import '../../pages/story/story_viewer_screen.dart';
import '../../providers/following/stories_provider.dart';

class StoriesRow extends ConsumerWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);

    return storiesAsync.when(
      loading: () => const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white24,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (stories) {
        if (stories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == stories.length - 1 ? 0 : 12,
                ),
                child: _StoryAvatar(
                  storyUser: stories[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final StoryUserModel storyUser;

  const _StoryAvatar({
    required this.storyUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (storyUser.hasRecentSpot) {
          // Navigate to story viewer
          await _openStoryViewer(context);
        }
        // If no recent spot, do nothing (or navigate to profile)
      },
      child: Column(
        children: [
          // Avatar with conditional gradient ring
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Show gradient ring only if user has recent spot
              gradient: storyUser.hasRecentSpot
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade400,
                        Colors.pink.shade400,
                        Colors.orange.shade400,
                      ],
                    )
                  : null,
              // Show subtle border if no recent spot
              border: !storyUser.hasRecentSpot
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 2,
                    )
                  : null,
            ),
            padding: EdgeInsets.all(storyUser.hasRecentSpot ? 2.5 : 0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: storyUser.hasRecentSpot
                    ? Border.all(
                        color: Colors.black,
                        width: 3,
                      )
                    : null,
              ),
              child: ClipOval(
                child:
                    storyUser.profilePictureUrl != null &&
                        storyUser.profilePictureUrl!.isNotEmpty
                    ? FastCachedImage(
                        url: storyUser.profilePictureUrl!,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
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
          ),
          const Gap(6),
          // Username
          SizedBox(
            width: 68,
            child: Text(
              storyUser.username ?? 'User',
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.white.withValues(alpha: 0.3),
          size: 28,
        ),
      ),
    );
  }

  Future<void> _openStoryViewer(BuildContext context) async {
    // We need access to all story users to navigate between them
    // Get the ref from context to access the stories provider
    final container = ProviderScope.containerOf(context);
    final storiesAsyncValue = container.read(storiesProvider);

    final allStoryUsers = storiesAsyncValue.when(
      data: (data) => data,
      loading: () => <StoryUserModel>[],
      error: (_, __) => <StoryUserModel>[],
    );

    // Find the index of the tapped user
    final initialIndex = allStoryUsers.indexWhere((u) => u.id == storyUser.id);
    if (initialIndex == -1) return;

    // Get only users with recent spots
    final usersWithStories = allStoryUsers
        .where((u) => u.hasRecentSpot)
        .toList();
    final adjustedIndex = usersWithStories.indexWhere(
      (u) => u.id == storyUser.id,
    );
    if (adjustedIndex == -1) return;

    try {
      // Fetch stories for all users with recent spots
      final storyService = StoryService();
      final storiesMap = <String, List<StoryItemModel>>{};

      for (var user in usersWithStories) {
        final stories = await storyService.getUserStories(
          user.id,
          user.username,
          user.profilePictureUrl,
        );
        if (stories.isNotEmpty) {
          storiesMap[user.id] = stories;
        }
      }

      if (!context.mounted) return;

      // Navigate with hero animation using root navigator to hide bottom nav
      await Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black,
          barrierDismissible: false,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: StoryViewerScreen(
                initialUserIndex: adjustedIndex,
                storyUsers: usersWithStories,
                storiesMap: storiesMap,
              ),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error opening story: $e');
    }
  }
}
