import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user/spot_stat_model.dart';
import '../../../services/car/car_service.dart';

part 'spot_stat_provider.g.dart';

@Riverpod(keepAlive: true)
class SpotStat extends _$SpotStat {
  @override
  Future<SpotStatModel> build() async {
    return await CarService().getSpotStats();
  }
}
