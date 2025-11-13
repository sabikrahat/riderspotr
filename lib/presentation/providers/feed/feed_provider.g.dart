// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Feed)
const feedProvider = FeedFamily._();

final class FeedProvider
    extends $AsyncNotifierProvider<Feed, List<CarSpotModel>> {
  const FeedProvider._({
    required FeedFamily super.from,
    required (FeedType, String?) super.argument,
  }) : super(
         retry: null,
         name: r'feedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$feedHash();

  @override
  String toString() {
    return r'feedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Feed create() => Feed();

  @override
  bool operator ==(Object other) {
    return other is FeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$feedHash() => r'070ca67a701f589b5a4c5eb734483fb90cf5e30d';

final class FeedFamily extends $Family
    with
        $ClassFamilyOverride<
          Feed,
          AsyncValue<List<CarSpotModel>>,
          List<CarSpotModel>,
          FutureOr<List<CarSpotModel>>,
          (FeedType, String?)
        > {
  const FeedFamily._()
    : super(
        retry: null,
        name: r'feedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FeedProvider call(FeedType feedType, String? userCountry) =>
      FeedProvider._(argument: (feedType, userCountry), from: this);

  @override
  String toString() => r'feedProvider';
}

abstract class _$Feed extends $AsyncNotifier<List<CarSpotModel>> {
  late final _$args = ref.$arg as (FeedType, String?);
  FeedType get feedType => _$args.$1;
  String? get userCountry => _$args.$2;

  FutureOr<List<CarSpotModel>> build(FeedType feedType, String? userCountry);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
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
