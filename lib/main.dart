import 'package:flutter/material.dart';
import 'package:ridespotr/config/constants.dart';
import 'package:ridespotr/config/router.dart';
import 'package:ridespotr/config/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const Ridespotr());
}

class Ridespotr extends StatelessWidget {
  const Ridespotr({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(theme: theme(context), routerConfig: router),
    );
  }
}
