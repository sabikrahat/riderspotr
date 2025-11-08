import 'package:ridespotr/services/auth/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_rank_provider.g.dart';

@riverpod
class UserRankNotifier extends _$UserRankNotifier {
  @override
  FutureOr<int> build() async {
    return UserService().getUserLeaderboardRank();
  }
}
