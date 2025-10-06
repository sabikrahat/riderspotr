import 'package:flutter/material.dart';

class SpecsPart extends StatelessWidget {
  const SpecsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Specs Part',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
