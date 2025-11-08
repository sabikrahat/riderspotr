import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';

class AuthService {
  late SupabaseClient _client;

  AuthService() {
    _client = Supabase.instance.client;
  }

  Future<bool> checkEmailExists({required String email}) async {
    final emailExists = await _client
        .from('emails')
        .select()
        .eq('email', email.toLowerCase())
        .maybeSingle();
    return emailExists != null;
  }

  Future<void> login({required String email}) async {
    try {
      final emailExists = await checkEmailExists(email: email);

      if (!emailExists) {
        throw KException(
          'User not found with this email. Please register first.',
          code: '400',
        );
      }
      await _client.auth.signInWithOtp(email: email, shouldCreateUser: true);
      return;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      throw KException(e.message, code: e.code);
    } on KException catch (_) {
      rethrow;
    } catch (e) {
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> register({required String email}) async {
    try {
      final emailExists = await checkEmailExists(email: email);

      if (emailExists) {
        throw KException(
          'Email already used. Please use a different email.',
          code: '400',
        );
      }

      await _client.auth.signInWithOtp(
        email: email.toLowerCase(),
        shouldCreateUser: true,
      );
      return;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      throw KException(e.message, code: e.code);
    } on KException catch (_) {
      rethrow;
    } catch (e) {
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      await _client.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: token,
      );
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}', code: '500');
    } on AuthException catch (e) {
      throw KException(e.message, code: e.code);
    } catch (e) {
      throw KException(e.toString(), code: '500');
    }
  }

  Future<void> resendOtp({
    required String email,
    required bool shouldCreateUser,
  }) async {
    try {
      // ! can't define type as signup or login here, so using signInWithOtp instead
      // ! Moreover, Supabase resends OTP doesn't work as expected
      // await _client.auth.resend(type: OtpType.signup, email: email);
      await _client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: shouldCreateUser,
      );
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
