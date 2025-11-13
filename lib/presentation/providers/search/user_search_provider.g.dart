// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSearch)
const userSearchProvider = UserSearchProvider._();

final class UserSearchProvider
    extends $AsyncNotifierProvider<UserSearch, List<UserSimpleModel>> {
  const UserSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSearchHash();

  @$internal
  @override
  UserSearch create() => UserSearch();
}

String _$userSearchHash() => r'495743d5bd5fa5065bab3001e6b7e6964f57e06a';

abstract class _$UserSearch extends $AsyncNotifier<List<UserSimpleModel>> {
  FutureOr<List<UserSimpleModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<UserSimpleModel>>, List<UserSimpleModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserSimpleModel>>,
                List<UserSimpleModel>
              >,
              AsyncValue<List<UserSimpleModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
