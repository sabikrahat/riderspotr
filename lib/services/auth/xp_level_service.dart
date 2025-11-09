import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../models/user/xp_level_model.dart';

class XpLevelService {
  late SupabaseClient _client;

  XpLevelService() {
    _client = Supabase.instance.client;
  }

  Future<List<XpLevelModel>> getXpLevels() async {
    try {
      final res = await _client
          .from('xp_levels')
          .select()
          .order('level', ascending: true);

      debugPrint('XP Levels fetched: ${res.length} levels');

      return res.map<XpLevelModel>((e) => XpLevelModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching XP levels: $e');
      throw KException('Error fetching XP levels: $e');
    }
  }
}
