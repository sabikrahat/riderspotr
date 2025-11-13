// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followers_following_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Followers)
const followersProvider = FollowersFamily._();

final class FollowersProvider
    extends $AsyncNotifierProvider<Followers, List<UserSimpleModel>> {
  const FollowersProvider._({
    required FollowersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'followersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$followersHash();

  @override
  String toString() {
    return r'followersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Followers create() => Followers();

  @override
  bool operator ==(Object other) {
    return other is FollowersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followersHash() => r'3de3716cb2a49a25537628382d29101b1359e6a7';

final class FollowersFamily extends $Family
    with
        $ClassFamilyOverride<
          Followers,
          AsyncValue<List<UserSimpleModel>>,
          List<UserSimpleModel>,
          FutureOr<List<UserSimpleModel>>,
          String
        > {
  const FollowersFamily._()
    : super(
        retry: null,
        name: r'followersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FollowersProvider call(String userId) =>
      FollowersProvider._(argument: userId, from: this);

  @override
  String toString() => r'followersProvider';
}

abstract class _$Followers extends $AsyncNotifier<List<UserSimpleModel>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<UserSimpleModel>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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

@ProviderFor(Following)
const followingProvider = FollowingFamily._();

final class FollowingProvider
    extends $AsyncNotifierProvider<Following, List<UserSimpleModel>> {
  const FollowingProvider._({
    required FollowingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'followingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$followingHash();

  @override
  String toString() {
    return r'followingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Following create() => Following();

  @override
  bool operator ==(Object other) {
    return other is FollowingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followingHash() => r'6a51a505d695298f5b5f77a7bb593d508cc3137d';

final class FollowingFamily extends $Family
    with
        $ClassFamilyOverride<
          Following,
          AsyncValue<List<UserSimpleModel>>,
          List<UserSimpleModel>,
          FutureOr<List<UserSimpleModel>>,
          String
        > {
  const FollowingFamily._()
    : super(
        retry: null,
        name: r'followingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FollowingProvider call(String userId) =>
      FollowingProvider._(argument: userId, from: this);

  @override
  String toString() => r'followingProvider';
}

abstract class _$Following extends $AsyncNotifier<List<UserSimpleModel>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<UserSimpleModel>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
