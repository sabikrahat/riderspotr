import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/enums.dart';
import '../../../services/subscription/subscription_service.dart';

part 'subscription_provider.g.dart';

@Riverpod(keepAlive: true)
class Subscription extends _$Subscription {
  final _service = SubscriptionService();
  CustomerInfo? _customerInfo;
  SubscriptionTier _currentTier = SubscriptionTier.free;

  @override
  Future<SubscriptionTier> build() async {
    await _loadCustomerInfo();
    return _currentTier;
  }

  Future<void> _loadCustomerInfo() async {
    try {
      _customerInfo = await _service.getCustomerInfo();
      _currentTier = _determineSubscriptionTier();
    } catch (e) {
      _currentTier = SubscriptionTier.free;
    }
  }

  SubscriptionTier _determineSubscriptionTier() {
    if (_customerInfo == null) return SubscriptionTier.free;

    final entitlements = _customerInfo!.entitlements.active;

    final entitlementKeys = entitlements.keys.map((key) => key.toLowerCase());

    if (entitlementKeys.contains('premium')) {
      return SubscriptionTier.premium;
    }

    if (entitlementKeys.contains('basic')) {
      return SubscriptionTier.basic;
    }

    return SubscriptionTier.free;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadCustomerInfo();
    state = AsyncValue.data(_currentTier);
  }

  CustomerInfo? get customerInfo => _customerInfo;
  SubscriptionTier get currentTier => _currentTier;
  bool get hasActiveSubscription => _currentTier != SubscriptionTier.free;
  bool get hasStatsAccess => _currentTier.hasStatsAccess;
  bool get hasLeaderboardAccess => _currentTier.hasLeaderboardAccess;
  int get maxCarSpots => _currentTier.maxCarSpots;
  bool get isUnlimited => _currentTier.isUnlimited;
  bool get isFree => _currentTier == SubscriptionTier.free;
  bool get isBasic => _currentTier == SubscriptionTier.basic;
  bool get isPremium => _currentTier == SubscriptionTier.premium;

  bool canAddMoreCars(int currentCarCount) {
    final maxSpots = _currentTier.maxCarSpots;
    if (maxSpots == -1) return true;
    return currentCarCount < maxSpots;
  }

  int getRemainingCarSpots(int currentCarCount) {
    final maxSpots = _currentTier.maxCarSpots;
    if (maxSpots == -1) return -1;
    final remaining = maxSpots - currentCarCount;
    return remaining > 0 ? remaining : 0;
  }
}
