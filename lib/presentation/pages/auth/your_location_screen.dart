import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/auth/user_model.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import 'search_address/components/google_maps_helper.dart';
import 'search_address/components/map_prediction_model.dart';
import 'search_address/k_maps_location_input_field.dart';

class YourLocationScreen extends ConsumerStatefulWidget {
  const YourLocationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YourLocationScreenState();
}

class _YourLocationScreenState extends ConsumerState<YourLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  LatLng? _selectedLatLng;

  Future<void> _submit(Future<void> Function() afterCheck) async {
    if (!_formKey.currentState!.validate()) return;
    await afterCheck.call();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(onPressed: () async => await notifier.signOut(context: context)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/onboarding/about.png',
            // fit: BoxFit.cover,
            width: double.infinity,
            height: context.height * 0.36,
          ),
          PagePadding(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('YOUR LOCATION', style: context.textTheme.headlineSmall),
                      Gap(4),
                      Text('Where are you baed?'),
                      Gap(24),
                      KMapLocationInputField(
                        hint: 'Search suburb',
                        optionsBuilder: (t) async {
                          _locationController.text = t.text;
                          return await GoogleMapsHelper().getLocations(t.text);
                        },
                        // initialValue: notifier.address,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your location';
                          }
                          if (_selectedLatLng == null) {
                            return 'Please enter a valid location';
                          }
                          return null;
                        },
                        displayStringForOption: (v) => v.description!,
                        onSelected: (MapPredictionModel v) async {
                          debugPrint('Selected Location: $v');
                          final data = await GoogleMapsHelper().getLocationBasedOnPlaceId(
                            v.placeId!,
                          );
                          debugPrint('Details Result: $data');
                          debugPrint('Latitude: ${data?.geometry?.location?.lat}');
                          debugPrint('Longitude: ${data?.geometry?.location?.lng}');

                          if (data == null) return;
                          if (data.geometry == null) return;
                          if (data.geometry!.location == null) return;

                          final latLng = LatLng(
                            data.geometry!.location!.lat!,
                            data.geometry!.location!.lng!,
                          );
                          debugPrint('LatLng: $latLng');

                          // final plmks = await placemarkFromCoordinates(
                          //     latLng.latitude, latLng.longitude);

                          // final address = placeMarksToAddress(plmks);
                          // debugPrint('Address: ${notifier.address}');

                          _selectedLatLng = latLng;
                          // _locationController.text = address;
                        },
                      ),
                      Gap(24),
                      LongButton(
                        text: 'Continue',
                        onPressed: () async => await _submit(() async {
                          await notifier.updateUser(
                            context: context,
                            user: notifier.user!.copyWith(
                              location: _locationController.text.trim(),
                              locationLatLng: _selectedLatLng,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
