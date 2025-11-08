// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LeaderboardProvider)
const leaderboardProviderProvider = LeaderboardProviderProvider._();

final class LeaderboardProviderProvider
    extends
        $AsyncNotifierProvider<
          LeaderboardProvider,
          List<UserLeaderboardModel>
        > {
  const LeaderboardProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardProviderHash();

  @$internal
  @override
  LeaderboardProvider create() => LeaderboardProvider();
}

String _$leaderboardProviderHash() =>
    r'35bf2c005cbd76b95e7bdcbcd9844558554d668c';

abstract class _$LeaderboardProvider
    extends $AsyncNotifier<List<UserLeaderboardModel>> {
  FutureOr<List<UserLeaderboardModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UserLeaderboardModel>>,
              List<UserLeaderboardModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserLeaderboardModel>>,
                List<UserLeaderboardModel>
              >,
              AsyncValue<List<UserLeaderboardModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
