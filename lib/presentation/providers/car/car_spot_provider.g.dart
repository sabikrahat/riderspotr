// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_spot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CarSpotNotifier)
const carSpotProvider = CarSpotNotifierProvider._();

final class CarSpotNotifierProvider
    extends $AsyncNotifierProvider<CarSpotNotifier, List<CarSpotModel>> {
  const CarSpotNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'carSpotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$carSpotNotifierHash();

  @$internal
  @override
  CarSpotNotifier create() => CarSpotNotifier();
}

String _$carSpotNotifierHash() => r'c1b04b9512827c71742c47046db94970590cd0a6';

abstract class _$CarSpotNotifier extends $AsyncNotifier<List<CarSpotModel>> {
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
