import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/auth/user_model.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/following/following.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  UserModel? _user;
  bool _isFollwing = false;

  @override
  FutureOr<UserModel?> build(String? arg) async {
    _user = await UserService().getUser(arg);
    if (user != null) _isFollwing = await FollowingService().isFollowing(user!.id);
    return _user;
  }

  UserModel? get user => _user;
  bool get isFollowing => _isFollwing;

  Future<void> refreshUser() async {
    _user = await UserService().getUser(arg);
    if (user != null) _isFollwing = await FollowingService().isFollowing(user!.id);
    ref.notifyListeners();
    state = AsyncValue.data(_user);
  }

  Future<void> followUnfollowUser() async {
    if (user == null) return;
    if (_isFollwing) {
      await FollowingService().unfollowUser(user!.id);
      _isFollwing = await FollowingService().isFollowing(user!.id);
    } else {
      await FollowingService().followUser(user!.id);
      _isFollwing = await FollowingService().isFollowing(user!.id);
    }
    ref.notifyListeners();
    state = AsyncValue.data(_user);
  }
}
