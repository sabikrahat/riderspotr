// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rank_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserRankNotifier)
const userRankProvider = UserRankNotifierProvider._();

final class UserRankNotifierProvider
    extends $AsyncNotifierProvider<UserRankNotifier, int> {
  const UserRankNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRankProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRankNotifierHash();

  @$internal
  @override
  UserRankNotifier create() => UserRankNotifier();
}

String _$userRankNotifierHash() => r'7413157c6b3850934266c1d7d4a541220567ff66';

abstract class _$UserRankNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
