import 'package:ridespotr/models/car/car_spot_model.dart';
import 'package:ridespotr/services/car/car_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user/user_model.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/following/following.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  List<CarSpotModel> _carSpots = [];
  UserModel? _user;
  bool _isFollwing = false;

  @override
  FutureOr<UserModel?> build(String? userId) async {
    _user = await UserService().getUser(userId);
    if (user != null) {
      _isFollwing = await FollowingService().isFollowing(user!.id);
      _carSpots = await CarService().getAllCarSpots(user!.id);
    }

    return _user;
  }

  UserModel? get user => _user;
  bool get isFollowing => _isFollwing;
  List<CarSpotModel> get carSpots => _carSpots;

  Future<void> refreshUser() async {
    _user = await UserService().getUser(userId);
    if (user != null) {
      _isFollwing = await FollowingService().isFollowing(user!.id);
    }
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
