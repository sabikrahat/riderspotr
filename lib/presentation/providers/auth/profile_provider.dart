import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/auth/user_model.dart';
import '../../../services/auth/user_service.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  UserModel? _user;

  @override
  FutureOr<UserModel?> build(String? arg) async {
    _user = await UserService().getUser(arg);
    return _user;
  }

  UserModel? get user => _user;

  Future<void> refreshUser() async {
    _user = await UserService().getUser(arg);
    state = AsyncValue.data(_user);
  }
}
