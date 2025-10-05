import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ridespotr/core/extensions.dart';
import 'package:ridespotr/presentation/widgets/capture/scan_detail_container.dart';
import 'package:ridespotr/presentation/widgets/shared/back.dart';
import 'package:ridespotr/presentation/widgets/shared/page_padding.dart';

class ScanDeatilScreen extends StatelessWidget {
  static const String routeName = '/scan-detail';
  const ScanDeatilScreen({super.key});

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
            child: Image.asset('assets/demo.png', fit: BoxFit.cover),
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
                        'LAMBORGHINI AVENTADOR',
                        style: context.textTheme.headlineMedium,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purpleAccent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.25),
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
                  buttonText: 'STATS',
                  onButtonPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('200 XP'),
                          Text('250 XP'),
                        ],
                      ),
                      // TODO: Implement the progress bar
                      Spacer(),
                      Row(
                        spacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.refresh),
                            label: Text('Retake'),
                          ),
                          Expanded(
                            child: FilledButton.icon(
                              style: ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 40),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.check),
                              label: Text(
                                'CLAIM',
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
