import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/user/user_model.dart';
import '../../../models/google_maps/map_prediction_model.dart';
import '../../../services/google_maps/google_maps_service.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/address_text_field.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import '../home/home_screen.dart';

class YourLocationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/your-location';
  const YourLocationScreen({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YourLocationScreenState();
}

class _YourLocationScreenState extends ConsumerState<YourLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  LatLng? _selectedLatLng;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(userProvider.future);
      final notifier = ref.read(userProvider.notifier);
      _locationController.text = notifier.user?.address ?? '';
      if (notifier.user?.location != null) {
        _selectedLatLng = LatLng(
          notifier.user!.location!.latitude,
          notifier.user!.location!.longitude,
        );
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Back(),
        ),
        extendBodyBehindAppBar: true,
        body: CarbonBackground(
          imgPath: 'assets/carbon/49.jpg',
          heightPercent: 0.36,
          child: PagePadding(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR LOCATION',
                        style: context.textTheme.headlineSmall,
                      ),
                      Gap(4),
                      Text('Where are you baed?'),
                      Gap(24),
                      AddressTextField(
                        labelText: 'Search suburb',
                        initialValue: notifier.user?.address,
                        optionsBuilder: (t) async {
                          _locationController.text = t.text;
                          return await GoogleMapsService().getLocations(
                            t.text,
                          );
                        },
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
                          final data = await GoogleMapsService()
                              .getLocationBasedOnPlaceId(
                                v.placeId!,
                              );

                          if (data == null) return;
                          if (data.geometry == null) return;
                          if (data.geometry!.location == null) return;

                          final latLng = LatLng(
                            data.geometry!.location!.lat!,
                            data.geometry!.location!.lng!,
                          );
                          _selectedLatLng = latLng;
                          _locationController.text = v.description!;
                        },
                      ),
                      Gap(24),
                      LongButton(
                        text: 'Continue',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });

                              // Get location details (country, state, etc.)
                              final locationDetails = await GoogleMapsService()
                                  .getLocationDetails(_selectedLatLng!);

                              if (locationDetails == null) {
                                showErrorMessage(
                                  'Unable to determine country and state. Please try again.',
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }

                              await notifier.updateUser(
                                user: notifier.user!.copyWith(
                                  address: _locationController.text.trim(),
                                  location: Location(
                                    latitude: _selectedLatLng!.latitude,
                                    longitude: _selectedLatLng!.longitude,
                                  ),
                                  country: locationDetails.country,
                                  countryCode: locationDetails.countryCode,
                                  state: locationDetails.state,
                                ),
                              );
                              if (widget.fromUpdateProfile) {
                                if (context.mounted) context.pop();
                                return;
                              }
                              if (context.mounted) {
                                // Navigate to home screen with flag to show payment
                                context.pushReplacement(
                                  HomeScreen.routeName,
                                  extra: true, // isFinishRegister flag
                                );
                              }
                            } on KException catch (e) {
                              showErrorMessage(e.message);
                            } catch (e) {
                              showErrorMessage(e.toString());
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
