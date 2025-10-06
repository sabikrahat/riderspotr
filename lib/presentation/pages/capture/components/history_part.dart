import 'package:flutter/material.dart';

class HistoryPart extends StatelessWidget {
  const HistoryPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'History Part',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
