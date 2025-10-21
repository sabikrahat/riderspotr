import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/toastification.dart';
import '../../../services/car/car_spot.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../widgets/capture/scan_detail_container.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/page_padding.dart';
import 'car_deatil_screen.dart';

class ScanDeatilScreen extends StatelessWidget {
  static const String routeName = '/scan-detail';
  const ScanDeatilScreen({super.key, required this.carSpot});

  final CarSpotModel? carSpot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            width: context.width,
            height: context.height,
            child: Image.network(carSpot!.imageUrl, fit: BoxFit.cover),
          ),
          // Title and rarity
          Positioned(
            child: Container(
              width: context.width,
              height: context.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 1),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carSpot!.car?.make?.name.toUpperCase() ?? 'UNKNOWN MAKE',
                        style: context.textTheme.headlineMedium,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purpleAccent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withValues(alpha: 0.25),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Text(
                            'EPIC',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom car details section
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height: context.height * 0.42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 1),
                  ],
                ),
              ),
              child: PagePadding(
                child: ScanDetailContainer(
                  title: 'LEVEL UP',
                  buttonText: 'DETAILS',
                  onButtonPressed: () async =>
                      await context.push(CarDeatilScreen.routeName, extra: carSpot),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '200 XP',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SvgPicture.asset('assets/images/long-arrow.svg'),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.electric_bolt_rounded,
                                  color: Colors.purpleAccent,
                                  size: 18,
                                ),
                                Gap(2),
                                Text(
                                  '250 XP',
                                  style: context.textTheme.headlineSmall?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withValues(alpha: 0.25),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: LinearProgressIndicator(
                            value: 0.4,
                            backgroundColor: Colors.grey.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(45),
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        spacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              try {
                                await CarSpotService().delete(carSpot!.id);
                                if (!context.mounted) return;
                                context.pop();
                              } catch (e) {
                                showErrorMessage('Error deleting car spot: $e');
                              }
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Retake'),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent.withValues(alpha: 0.25),
                                    blurRadius: 30,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: FilledButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.purpleAccent),
                                  fixedSize: WidgetStatePropertyAll(Size(double.infinity, 40)),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                ),
                                onPressed: () async {
                                  try {
                                    await CarSpotService().markClaimed(carSpot!.id);
                                    showSuccessMessage('Car spot claimed successfully!');
                                  } catch (e) {
                                    showErrorMessage('Error claiming car spot: $e');
                                  }
                                },
                                icon: Icon(Icons.check),
                                label: Text(
                                  'CLAIM',
                                  style: context.textTheme.headlineSmall?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
