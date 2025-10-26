// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_friend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFriendNotifier)
const searchFriendProvider = SearchFriendNotifierProvider._();

final class SearchFriendNotifierProvider
    extends $AsyncNotifierProvider<SearchFriendNotifier, List<UserModel>> {
  const SearchFriendNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFriendProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFriendNotifierHash();

  @$internal
  @override
  SearchFriendNotifier create() => SearchFriendNotifier();
}

String _$searchFriendNotifierHash() =>
    r'45000bb29439eeaf8b335367cb3bfd5f3c2e3bdd';

abstract class _$SearchFriendNotifier extends $AsyncNotifier<List<UserModel>> {
  FutureOr<List<UserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<UserModel>>, List<UserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserModel>>, List<UserModel>>,
              AsyncValue<List<UserModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
