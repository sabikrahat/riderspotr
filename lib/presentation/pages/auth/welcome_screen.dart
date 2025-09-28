import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridespotr/core/extensions.dart';
import 'package:ridespotr/presentation/widgets/shared/back.dart';
import 'package:ridespotr/presentation/widgets/shared/logo.dart';
import 'package:ridespotr/presentation/widgets/shared/long_button.dart';
import 'package:ridespotr/presentation/widgets/shared/page_padding.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagePadding(
        child: Column(
          children: [
            Logo(),
            Text(
              'WELCOME TO RIDESPOTR',
              style: context.textTheme.headlineSmall,
            ),
            Text(
              "This is a simple app that allows you to find rides in your area.",
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            LongButton(text: 'Continue'),
            Back(),
          ],
        ),
      ),
    );
  }
}
