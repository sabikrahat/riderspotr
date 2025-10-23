import 'dart:async';

import '../../../models/auth/user_model.dart';
import '../../../services/auth/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_friend_provider.g.dart';

@Riverpod(keepAlive: true)
class SearchFriendNotifier extends _$SearchFriendNotifier {
  List<UserModel> _users = [];

  @override
  FutureOr<List<UserModel>> build() async {
    _users = await UserService().getUsers();
    return _users;
  }

  List<UserModel> get users => _users;

  Future<void> refresh([String? query]) async {
    _users = await UserService().getUsers(query);
    state = AsyncValue.data(_users);
  }
}
