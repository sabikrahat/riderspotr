import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user/story_user_model.dart';
import '../../../services/following/following.dart';

part 'stories_provider.g.dart';

@riverpod
class StoriesNotifier extends _$StoriesNotifier {
  List<StoryUserModel> _stories = [];

  @override
  FutureOr<List<StoryUserModel>> build() async {
    _stories = await FollowingService().getFollowedUsersWithRecentSpots();
    return _stories;
  }

  List<StoryUserModel> get stories => _stories;

  Future<void> refresh() async {
    _stories = await FollowingService().getFollowedUsersWithRecentSpots();
    state = AsyncValue.data(_stories);
  }
}
