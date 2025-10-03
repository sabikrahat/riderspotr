import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/auth/user_model.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/auth/user_service.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  UserModel? _user;

  @override
  FutureOr<UserModel?> build() async {
    _user = await UserService().getUser();
    return _user;
  }

  UserModel? get user => _user;

  Future<void> refreshUser() async {
    _user = await UserService().getUser();
    state = AsyncValue.data(_user);
  }

  Future<void> login({
    required BuildContext context,
    required String email,
  }) async {
    await AuthService().login(email: email);
  }

  Future<void> register({
    required BuildContext context,
    required String email,
  }) async {
    await AuthService().register(email: email);
  }

  Future<void> signOut({required BuildContext context}) async {
    await AuthService().signout();
    await refreshUser();
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String token,
    required bool shouldCreateUser,
  }) async {
    await AuthService().verifyOtp(
      email: email,
      token: token,
    );
    if (shouldCreateUser) {
      await UserService().createUser();
    }
    await refreshUser();
  }

  Future<void> resendOtp({
    required BuildContext context,
    required String email,
    required bool shouldCreateUser,
  }) async {
    await AuthService().resendOtp(
      email: email,
      shouldCreateUser: shouldCreateUser,
    );
  }

  Future<void> updateUser({
    required UserModel user,
  }) async {
    await UserService().update(user: user);
    await refreshUser();
  }
}
