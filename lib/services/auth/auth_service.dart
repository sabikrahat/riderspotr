import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  late final SupabaseClient supabase;
  @override
  FutureOr<void> build() async {
    supabase = Supabase.instance.client;
  }

  Future<void> sendOtp(String email) async {
    // TODO: Implement sendOtp
  }

  Future<void> verifyOtp(String email, String otp) async {
    // TODO: Implement verifyOtp
  }
}
