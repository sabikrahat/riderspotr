import 'package:flutter/material.dart';

class ProductionPart extends StatelessWidget {
  const ProductionPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Production Part',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
