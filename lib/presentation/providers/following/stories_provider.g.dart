// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoriesNotifier)
const storiesProvider = StoriesNotifierProvider._();

final class StoriesNotifierProvider
    extends $AsyncNotifierProvider<StoriesNotifier, List<StoryUserModel>> {
  const StoriesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storiesNotifierHash();

  @$internal
  @override
  StoriesNotifier create() => StoriesNotifier();
}

String _$storiesNotifierHash() => r'a497cc08af1a48b04200be021dbdf02306cf93ec';

abstract class _$StoriesNotifier extends $AsyncNotifier<List<StoryUserModel>> {
  FutureOr<List<StoryUserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<StoryUserModel>>, List<StoryUserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<StoryUserModel>>,
                List<StoryUserModel>
              >,
              AsyncValue<List<StoryUserModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
