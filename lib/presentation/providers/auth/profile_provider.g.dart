// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileNotifier)
const profileProvider = ProfileNotifierFamily._();

final class ProfileNotifierProvider
    extends $AsyncNotifierProvider<ProfileNotifier, UserModel?> {
  const ProfileNotifierProvider._({
    required ProfileNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'profileProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @override
  String toString() {
    return r'profileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();

  @override
  bool operator ==(Object other) {
    return other is ProfileNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileNotifierHash() => r'0cbfe8c895eb6d0087aab20abe3a78a0e4260c47';

final class ProfileNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileNotifier,
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>,
          String?
        > {
  const ProfileNotifierFamily._()
    : super(
        retry: null,
        name: r'profileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ProfileNotifierProvider call(String? arg) =>
      ProfileNotifierProvider._(argument: arg, from: this);

  @override
  String toString() => r'profileProvider';
}

abstract class _$ProfileNotifier extends $AsyncNotifier<UserModel?> {
  late final _$args = ref.$arg as String?;
  String? get arg => _$args;

  FutureOr<UserModel?> build(String? arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<UserModel?>, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, UserModel?>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
