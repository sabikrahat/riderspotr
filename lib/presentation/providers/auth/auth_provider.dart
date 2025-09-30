import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../config/router.dart';
import '../../../core/toastification.dart';
import '../../../services/auth/auth_service.dart';

import '../../../core/exception.dart';

final authProvider = NotifierProvider<AuthProvider, void>(AuthProvider.new);

class AuthProvider extends Notifier {
  @override
  void build() {}

  Future<void> login({required BuildContext context, required String email}) async {
    final ld = context.loaderOverlay;
    ld.show();
    try {
      await AuthService().login(email: email);
      if (context.mounted) {
        context.push('/otp/${Uri.encodeComponent(email)}?shouldCreateUser=false');
      }
      return;
    } on KException catch (e) {
      debugPrint('Login error: $e');
      showErrorMessage(e.message);
    } finally {
      ld.hide();
    }
  }

  Future<void> register({required BuildContext context, required String email}) async {
    final ld = context.loaderOverlay;
    ld.show();
    try {
      await AuthService().register(email: email);
      if (context.mounted) context.push('/otp/${Uri.encodeComponent(email)}?shouldCreateUser=true');
      return;
    } on KException catch (e) {
      debugPrint('Register error: $e');
      showErrorMessage(e.message);
    } finally {
      ld.hide();
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    final ld = context.loaderOverlay;
    ld.show();
    try {
      await AuthService().signout();
      router.refresh();
    } on KException catch (e) {
      debugPrint('Signout error: $e');
      showErrorMessage(e.message);
    } finally {
      ld.hide();
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String token,
    required bool shouldCreateUser,
  }) async {
    final ld = context.loaderOverlay;
    ld.show();
    try {
      await AuthService().verifyOtp(email: email, token: token, shouldCreateUser: shouldCreateUser);
    } on KException catch (e) {
      debugPrint('Verify OTP error: $e');
      showErrorMessage(e.message);
    } finally {
      ld.hide();
    }
  }

  Future<void> resendOtp({
    required BuildContext context,
    required String email,
    required bool shouldCreateUser,
  }) async {
    final ld = context.loaderOverlay;
    ld.show();
    try {
      await AuthService().resendOtp(email: email, shouldCreateUser: shouldCreateUser);
      showSuccessMessage('OTP has been resent to your email');
    } on KException catch (e) {
      debugPrint('Resend OTP error: $e');
      showErrorMessage(e.message);
    } finally {
      ld.hide();
    }
  }
}
