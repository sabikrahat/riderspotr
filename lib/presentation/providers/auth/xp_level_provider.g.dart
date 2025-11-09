// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_level_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(XpLevels)
const xpLevelsProvider = XpLevelsProvider._();

final class XpLevelsProvider
    extends $AsyncNotifierProvider<XpLevels, List<XpLevelModel>> {
  const XpLevelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xpLevelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xpLevelsHash();

  @$internal
  @override
  XpLevels create() => XpLevels();
}

String _$xpLevelsHash() => r'b12e11266cfc8513291b44d95dae0239676f650a';

abstract class _$XpLevels extends $AsyncNotifier<List<XpLevelModel>> {
  FutureOr<List<XpLevelModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<XpLevelModel>>, List<XpLevelModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<XpLevelModel>>, List<XpLevelModel>>,
              AsyncValue<List<XpLevelModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
