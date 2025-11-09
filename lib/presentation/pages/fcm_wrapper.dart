import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth/user_provider.dart';

class FcmWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const FcmWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<FcmWrapper> createState() => _FcmWrapperState();
}

class _FcmWrapperState extends ConsumerState<FcmWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission for iOS - provisional allows user to choose notification type
    await messaging.requestPermission(provisional: true);

    // For Apple platforms, ensure APNS token is available before making FCM API calls
    final apnsToken = await messaging.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, proceed with FCM operations

      // Get FCM token
      final token = await messaging.getToken();
      if (token != null) {
        // Save token to database
        await ref.read(userProvider.notifier).saveFcmToken(token);
      }

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        ref.read(userProvider.notifier).saveFcmToken(newToken);
      });

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Message received');
      });
    } else {
      debugPrint('APNS token not available yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
