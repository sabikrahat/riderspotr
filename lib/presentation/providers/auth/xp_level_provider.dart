import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user/xp_level_model.dart';
import '../../../services/auth/xp_level_service.dart';

part 'xp_level_provider.g.dart';

@Riverpod(keepAlive: true)
class XpLevels extends _$XpLevels {
  @override
  Future<List<XpLevelModel>> build() async {
    return await XpLevelService().getXpLevels();
  }
}
