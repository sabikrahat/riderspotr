import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:ridespotr/core/extensions.dart';

import '../../../core/toastification.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/loading_overlay.dart';

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

  @override
  void initState() {
    super.initState();
    _getOfferings = Purchases.getOfferings();
    _customerInfoUpdateListener = (info) {
      setState(() {
        _isLoading = true;
      });
      if (info.activeSubscriptions.isNotEmpty) {
        if (mounted) {
          context.go('/');
        }
      }
      setState(() {
        _isLoading = false;
      });
    };
    Purchases.addCustomerInfoUpdateListener(_customerInfoUpdateListener);
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
