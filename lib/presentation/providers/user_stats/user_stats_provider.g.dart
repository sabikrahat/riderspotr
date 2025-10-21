// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserStatsNotifier)
const userStatsProvider = UserStatsNotifierProvider._();

final class UserStatsNotifierProvider
    extends $AsyncNotifierProvider<UserStatsNotifier, List<UserStatsModel>> {
  const UserStatsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStatsNotifierHash();

  @$internal
  @override
  UserStatsNotifier create() => UserStatsNotifier();
}

String _$userStatsNotifierHash() => r'f874cf1b37c221067d5b9315c59e6d1467e36c7d';

abstract class _$UserStatsNotifier
    extends $AsyncNotifier<List<UserStatsModel>> {
  FutureOr<List<UserStatsModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<UserStatsModel>>, List<UserStatsModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserStatsModel>>,
                List<UserStatsModel>
              >,
              AsyncValue<List<UserStatsModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
