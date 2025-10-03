import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'config/constants.dart';
import 'config/router.dart';
import 'config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(ProviderScope(child: const Ridespotr()));
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
