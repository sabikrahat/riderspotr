import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'config/constants.dart';
import 'config/router.dart';
import 'config/theme.dart';

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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        theme: theme(context),
        routerConfig: router,
      ),
    );
  }
}
