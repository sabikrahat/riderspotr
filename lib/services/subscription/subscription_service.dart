import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  Future<void> initialize({
    required String userId,
    required String iosApiKey,
    required String androidApiKey,
  }) async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;

    if (Platform.isIOS) {
      configuration = PurchasesConfiguration(iosApiKey);
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(androidApiKey);
    } else {
      throw Exception('Unsupported platform');
    }

    configuration = configuration..appUserID = userId;
    await Purchases.configure(configuration);
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  Future<CustomerInfo> restorePurchases() async {
    return await Purchases.restorePurchases();
  }

  Future<CustomerInfo> login(String userId) async {
    final result = await Purchases.logIn(userId);
    return result.customerInfo;
  }

  Future<CustomerInfo> logout() async {
    return await Purchases.logOut();
  }
}
