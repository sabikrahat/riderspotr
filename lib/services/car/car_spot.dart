import 'dart:io';

import 'package:flutter/widgets.dart';
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
      debugPrint('Car Spots fetched: ${res.toString()}');
      return res.map((e) => CarSpotModel.fromJson(e)).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  Future<void> markClaimed(String id) async {
    try {
      await _client.from('car_spots').update({'is_claimed': true}).eq('id', id);
    } catch (e) {
      throw Exception('Error marking claimed: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _client.from('car_spots').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting car spot: $e');
    }
  }
}
