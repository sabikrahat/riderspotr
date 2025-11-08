import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'config/constants.dart';
import 'config/router.dart';
import 'config/subscription_constants.dart';
import 'config/theme.dart';
import 'services/subscription/subscription_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
  await SubscriptionService().initialize(
    userId: userId,
    iosApiKey: SubscriptionConstants.iosApiKey,
    androidApiKey: SubscriptionConstants.androidApiKey,
  );

  MapboxOptions.setAccessToken(mapBoxAccessToken);

  runApp(
    ProviderScope(
      retry: (retryCount, error) {
        if (retryCount > 1) return null;
        return Duration(seconds: retryCount * 2);
      },
      child: const Ridespotr(),
    ),
  );
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
