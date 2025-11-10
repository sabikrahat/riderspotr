import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:ridespotr/core/extensions.dart';

import '../../../core/toastification.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../home/home_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  static const routeName = '/payment';
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isLoading = false;
  late Future<Offerings> _getOfferings;
  late void Function(CustomerInfo) _customerInfoUpdateListener;
  Set<String>? _initialEntitlements;

  @override
  void initState() {
    super.initState();

    // Save initial entitlements when screen opens
    _initializeEntitlements();

    _getOfferings = Purchases.getOfferings();
    _customerInfoUpdateListener = (info) {
      // Get current entitlements
      final currentEntitlements = info.entitlements.active.keys.toSet();

      // Only trigger if entitlements have changed from initial state
      if (_initialEntitlements != null &&
          !_areEntitlementsEqual(_initialEntitlements!, currentEntitlements) &&
          info.activeSubscriptions.isNotEmpty) {
        // Delay the provider modification until after the widget tree is done building
        Future(() async {
          setState(() {
            _isLoading = true;
          });

          // Refresh the subscription provider to get latest status
          await ref.read(subscriptionProvider.notifier).refresh();

          if (mounted) {
            // Show success message
            showSuccessMessage('Thanks for subscribing!');

            // Navigate to home screen
            context.go(HomeScreen.routeName);
          }

          setState(() {
            _isLoading = false;
          });
        });
      }
    };
    Purchases.addCustomerInfoUpdateListener(_customerInfoUpdateListener);
  }

  Future<void> _initializeEntitlements() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      setState(() {
        _initialEntitlements = customerInfo.entitlements.active.keys.toSet();
      });
    } catch (e) {
      // If we can't get customer info, assume no entitlements
      setState(() {
        _initialEntitlements = {};
      });
    }
  }

  bool _areEntitlementsEqual(Set<String> set1, Set<String> set2) {
    if (set1.length != set2.length) return false;
    return set1.every((element) => set2.contains(element));
  }

  @override
  void dispose() {
    Purchases.removeCustomerInfoUpdateListener(_customerInfoUpdateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        title: Text('PAYMENT', style: context.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: FutureBuilder(
          future: _getOfferings,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final offerings = snapshot.data!.all;
                  final offering = offerings[offerings.keys.first];
                  return PaywallView(
                    offering: offering,
                    displayCloseButton: false,
                    onPurchaseError: (error) {
                      showErrorMessage(error.message);
                    },
                  );
                }
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
