import 'package:flutter/material.dart';
import '../../../core/extensions.dart';

import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const String routeName = '/payment';

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
      body: CarbonBackground(
        imgPath: 'assets/carbon/leaderboard-bg.jpg',
        child: PagePadding(
          child: Column(
            children: [
              // Add your payment screen content here
            ],
          ),
        ),
      ),
    );
  }
}
