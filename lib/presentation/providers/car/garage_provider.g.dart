// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GarageNotifier)
const garageProvider = GarageNotifierFamily._();

final class GarageNotifierProvider
    extends $AsyncNotifierProvider<GarageNotifier, List<CarSpotModel>> {
  const GarageNotifierProvider._({
    required GarageNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'garageProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$garageNotifierHash();

  @override
  String toString() {
    return r'garageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GarageNotifier create() => GarageNotifier();

  @override
  bool operator ==(Object other) {
    return other is GarageNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$garageNotifierHash() => r'c086263e43db536870840d45681ff2c1b3fd0abf';

final class GarageNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          GarageNotifier,
          AsyncValue<List<CarSpotModel>>,
          List<CarSpotModel>,
          FutureOr<List<CarSpotModel>>,
          String?
        > {
  const GarageNotifierFamily._()
    : super(
        retry: null,
        name: r'garageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GarageNotifierProvider call(String? arg) =>
      GarageNotifierProvider._(argument: arg, from: this);

  @override
  String toString() => r'garageProvider';
}

abstract class _$GarageNotifier extends $AsyncNotifier<List<CarSpotModel>> {
  late final _$args = ref.$arg as String?;
  String? get arg => _$args;

  FutureOr<List<CarSpotModel>> build(String? arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
