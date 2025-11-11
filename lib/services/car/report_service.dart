import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';

class ReportService {
  late SupabaseClient _client;

  ReportService() {
    _client = Supabase.instance.client;
  }

  /// Report a car spot with a reason and optional comments
  Future<void> reportCarSpot({
    required String carSpotId,
    required String reason,
    String? comments,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw KException('You must be logged in to report a car');
      }

      await _client.from('flagged_car_spots').insert({
        'user': userId,
        'car_spot': carSpotId,
        'reason': reason,
        'comments': comments,
      });

      debugPrint('Car spot reported successfully');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      debugPrint('Error reporting car spot: $e');
      throw KException('Failed to report car spot. Please try again.');
    }
  }
}
