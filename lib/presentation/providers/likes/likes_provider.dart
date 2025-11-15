import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/likes/likes_service.dart';

part 'likes_provider.g.dart';

/// Provider for the likes service
final likesServiceProvider = Provider<LikesService>((ref) {
  return LikesService();
});

/// State class to hold like information for a car spot
class LikeState {
  final int count;
  final bool isLiked;
  final bool isLoading;

  LikeState({
    required this.count,
    required this.isLiked,
    this.isLoading = false,
  });

  LikeState copyWith({
    int? count,
    bool? isLiked,
    bool? isLoading,
  }) {
    return LikeState(
      count: count ?? this.count,
      isLiked: isLiked ?? this.isLiked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for like state of a specific car spot
@riverpod
class Like extends _$Like {
  @override
  FutureOr<LikeState> build(String carSpotId) async {
    final likesService = ref.watch(likesServiceProvider);
    try {
      final count = await likesService.getLikeCount(carSpotId);
      final isLiked = await likesService.hasLiked(carSpotId);
      return LikeState(count: count, isLiked: isLiked, isLoading: false);
    } catch (e) {
      return LikeState(count: 0, isLiked: false, isLoading: false);
    }
  }

  Future<void> toggleLike() async {
    final currentState = await future;
    if (currentState.isLoading) {
      return;
    }

    final likesService = ref.read(likesServiceProvider);

    // Optimistic update
    final previousState = currentState;
    final optimisticCount = currentState.isLiked
        ? (currentState.count - 1).clamp(0, double.infinity).toInt()
        : currentState.count + 1;
    state = AsyncData(
      LikeState(
        isLiked: !currentState.isLiked,
        count: optimisticCount,
        isLoading: true,
      ),
    );

    try {
      if (previousState.isLiked) {
        await likesService.unlikeCarSpot(carSpotId);
      } else {
        await likesService.likeCarSpot(carSpotId);
      }
      // Create fresh state with correct values
      final newCount = previousState.isLiked
          ? (previousState.count - 1).clamp(0, double.infinity).toInt()
          : previousState.count + 1;
      final newState = LikeState(
        isLiked: !previousState.isLiked,
        count: newCount,
        isLoading: false,
      );
      state = AsyncData(newState);
    } catch (e) {
      // Revert on error
      state = AsyncData(previousState);
    }
  }

  Future<void> refresh() async {
    final likesService = ref.read(likesServiceProvider);
    try {
      final count = await likesService.getLikeCount(carSpotId);
      final isLiked = await likesService.hasLiked(carSpotId);
      state = AsyncData(LikeState(count: count, isLiked: isLiked));
    } catch (e) {
      // Keep current state on error
    }
  }
}

/// Provider to get batch like information for multiple car spots
final batchLikesProvider =
    FutureProvider.family<
      Map<String, ({int count, bool isLiked})>,
      List<String>
    >((ref, carSpotIds) async {
      final likesService = ref.watch(likesServiceProvider);

      if (carSpotIds.isEmpty) {
        return {};
      }

      try {
        final counts = await likesService.getLikeCounts(carSpotIds);
        final likedSpots = await likesService.getLikedCarSpots(carSpotIds);

        final result = <String, ({int count, bool isLiked})>{};
        for (final spotId in carSpotIds) {
          result[spotId] = (
            count: counts[spotId] ?? 0,
            isLiked: likedSpots.contains(spotId),
          );
        }

        return result;
      } catch (e) {
        return {};
      }
    });
