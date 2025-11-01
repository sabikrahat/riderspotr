// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_stat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpotStat)
const spotStatProvider = SpotStatProvider._();

final class SpotStatProvider
    extends $AsyncNotifierProvider<SpotStat, SpotStatModel> {
  const SpotStatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotStatProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotStatHash();

  @$internal
  @override
  SpotStat create() => SpotStat();
}

String _$spotStatHash() => r'49c8388611c4c476d7bebb5d8957e6c8d312fa52';

abstract class _$SpotStat extends $AsyncNotifier<SpotStatModel> {
  FutureOr<SpotStatModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SpotStatModel>, SpotStatModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotStatModel>, SpotStatModel>,
              AsyncValue<SpotStatModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
