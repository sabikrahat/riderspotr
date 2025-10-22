// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapNotifier)
const mapProvider = MapNotifierProvider._();

final class MapNotifierProvider
    extends $AsyncNotifierProvider<MapNotifier, List<CarSpotModel>> {
  const MapNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapNotifierHash();

  @$internal
  @override
  MapNotifier create() => MapNotifier();
}

String _$mapNotifierHash() => r'75aed9f5d26b4d0e456c0359aa08bd382220dcf0';

abstract class _$MapNotifier extends $AsyncNotifier<List<CarSpotModel>> {
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
