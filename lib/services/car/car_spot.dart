import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../models/car/car_spot_model.dart';

class CarSpotService {
  late SupabaseClient _client;

  CarSpotService() {
    _client = Supabase.instance.client;
  }

  Future<List<CarSpotModel>> getCarSpots() async {
    try {
      final res = await _client
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('user', _client.auth.currentUser!.id)
          .eq('is_claimed', true);
      return res.map((e) => CarSpotModel.fromJson(e)).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      print(e);
      throw KException(e.toString());
    }
  }
}
