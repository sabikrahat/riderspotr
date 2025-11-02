// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_current_rank_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserCurrentRank)
const userCurrentRankProvider = UserCurrentRankFamily._();

final class UserCurrentRankProvider
    extends $AsyncNotifierProvider<UserCurrentRank, int?> {
  const UserCurrentRankProvider._({
    required UserCurrentRankFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userCurrentRankProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userCurrentRankHash();

  @override
  String toString() {
    return r'userCurrentRankProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserCurrentRank create() => UserCurrentRank();

  @override
  bool operator ==(Object other) {
    return other is UserCurrentRankProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userCurrentRankHash() => r'c2836d7368e50b20451a2781d3b487d5a09637ac';

final class UserCurrentRankFamily extends $Family
    with
        $ClassFamilyOverride<
          UserCurrentRank,
          AsyncValue<int?>,
          int?,
          FutureOr<int?>,
          String
        > {
  const UserCurrentRankFamily._()
    : super(
        retry: null,
        name: r'userCurrentRankProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserCurrentRankProvider call(String filter) =>
      UserCurrentRankProvider._(argument: filter, from: this);

  @override
  String toString() => r'userCurrentRankProvider';
}

abstract class _$UserCurrentRank extends $AsyncNotifier<int?> {
  late final _$args = ref.$arg as String;
  String get filter => _$args;

  FutureOr<int?> build(String filter);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<int?>, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int?>, int?>,
              AsyncValue<int?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
