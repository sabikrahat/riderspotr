// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
// import '../../../models/auth/user_model.dart';

// import '../../providers/auth/user_provider.dart';
// import '../auth/about_you_screen.dart';
// import '../auth/your_experience_screen.dart';
// import '../auth/your_location_screen.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(userProvider);
//     final notifier = ref.read(userProvider.notifier);
//     if (notifier.user == null) {
//       Future.microtask(() async => await notifier.refreshUser());
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     if (!notifier.user!.isProfileComplete) return AboutYouScreen();
//     if (!notifier.user!.isExperienceComplete) return YourExperienceScreen();
//     if (!notifier.user!.isLocationComplete) return YourLocationScreen();
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Welcome to the Home Screen!'),
//             Gap(16),
//             ElevatedButton(
//               onPressed: () async => await notifier.signOut(context: context),
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/auth/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Welcome to the Home Screen!'),
          Gap(16),
          ElevatedButton(
            onPressed: () async => await notifier.signOut(context: context),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
