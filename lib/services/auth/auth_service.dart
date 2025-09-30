import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../config/router.dart';
import '../../core/exception.dart';
import '../../models/auth/user_model.dart';
import 'user_service.dart';

class AuthService {
  late SupabaseClient _client;

  AuthService() {
    _client = Supabase.instance.client;
  }

  Future<void> login({required String email}) async {
    try {
      await _client.auth.signInWithOtp(email: email, shouldCreateUser: true);
      debugPrint('Supabase login successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      debugPrint('Supabase login error: $e');
      throw KException(e.message, code: e.code);
    } catch (e) {
      debugPrint('Supabase login error: $e');
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> register({required String email}) async {
    try {
      await _client.auth.signInWithOtp(email: email, shouldCreateUser: true);
      debugPrint('Supabase register successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      debugPrint('Supabase register error: $e');
      throw KException(e.message, code: e.code);
    } catch (e) {
      debugPrint('Supabase register error: $e');
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
    bool shouldCreateUser = false,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        type: shouldCreateUser ? OtpType.signup : OtpType.magiclink,
        email: email,
        token: token,
      );
      debugPrint('Supabase verifyOtp response: $response');
      if (response.user != null && shouldCreateUser) {
        await UserService().createUser(
          user: UserModel(
            id: response.user?.id ?? Uuid().v4(),
            email: email,
            createdAt: DateTime.now(),
          ),
        );
      }
      router.refresh();
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      debugPrint('Supabase verifyOtp error: $e');
      throw KException(e.message, code: e.code);
    } catch (e) {
      debugPrint('Supabase verifyOtp error: $e');
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> resendOtp({required String email, required bool shouldCreateUser}) async {
    try {
      // ! can't define type as signup or login here, so using signInWithOtp instead
      // ! Moreover, Supabase resends OTP doesn't work as expected
      // await _client.auth.resend(type: OtpType.signup, email: email);
      await _client.auth.signInWithOtp(email: email, shouldCreateUser: shouldCreateUser);
      debugPrint('Supabase resendOtp successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      debugPrint('Supabase resendOtp error: $e');
      throw KException(e.message, code: e.code);
    } catch (e) {
      debugPrint('Supabase resendOtp error: $e');
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> signout() async {
    try {
      await _client.auth.signOut();
      debugPrint('Supabase signout successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw 'No internet connection. $e';
    } on AuthException catch (e) {
      debugPrint('Supabase signout error: $e');
      rethrow;
    } catch (e) {
      debugPrint('Supabase signout error: $e');
      rethrow;
    }
  }
}
