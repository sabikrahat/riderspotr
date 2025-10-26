import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'config/constants.dart';
import 'config/router.dart';
import 'config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  MapboxOptions.setAccessToken(mapBoxAccessToken);

  runApp(ProviderScope(
    retry: (retryCount, error) {
        if (retryCount > 1) return null;
        return Duration(seconds: retryCount * 2);
      },
    child: const Ridespotr()));
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
        builder: EasyLoading.init(),
      ),
    );
  }
}
