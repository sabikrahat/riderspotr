import '../../../models/auth/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserProvider extends _$UserProvider {
  @override
  FutureOr<UserModel?> build() async {
    // TODO: Fetch user
    return null;
  }
}
