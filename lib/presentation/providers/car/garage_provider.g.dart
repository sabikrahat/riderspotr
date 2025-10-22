// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GarageNotifier)
const garageProvider = GarageNotifierProvider._();

final class GarageNotifierProvider
    extends $AsyncNotifierProvider<GarageNotifier, List<CarSpotModel>> {
  const GarageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'garageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$garageNotifierHash();

  @$internal
  @override
  GarageNotifier create() => GarageNotifier();
}

String _$garageNotifierHash() => r'3cd36fc97b0c2286b6e2d853821208e0375b1410';

abstract class _$GarageNotifier extends $AsyncNotifier<List<CarSpotModel>> {
  FutureOr<List<CarSpotModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<CarSpotModel>>, List<CarSpotModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CarSpotModel>>, List<CarSpotModel>>,
              AsyncValue<List<CarSpotModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
