import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions.dart';

class ProductionPart extends StatelessWidget {
  const ProductionPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoCard(
                        title: 'YEARS PRODUCED',
                        subtitle: '2018 - 2020',
                      ),
                      InfoCard(
                        title: 'ORIGINAL MSRP',
                        subtitle: '\$958,966',
                      ),
                      InfoCard(
                        title: 'TOTAL MADE',
                        subtitle: '500',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Description',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Image.asset(
                  'assets/images/production.png',
                  height: 400,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam id efficitur ligula. Vivamus quis ligula urna. Nullam suscipit magna quis eleifend ultrices.',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        Gap(100),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.calendar_today, size: 18, color: Colors.white),
          ),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Gap(8),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
