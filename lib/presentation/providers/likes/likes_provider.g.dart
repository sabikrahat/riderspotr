// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for like state of a specific car spot

@ProviderFor(Like)
const likeProvider = LikeFamily._();

/// Provider for like state of a specific car spot
final class LikeProvider extends $AsyncNotifierProvider<Like, LikeState> {
  /// Provider for like state of a specific car spot
  const LikeProvider._({
    required LikeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'likeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$likeHash();

  @override
  String toString() {
    return r'likeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Like create() => Like();

  @override
  bool operator ==(Object other) {
    return other is LikeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$likeHash() => r'29d4868020eafc9c3ff3428e800808eb97d25bf5';

/// Provider for like state of a specific car spot

final class LikeFamily extends $Family
    with
        $ClassFamilyOverride<
          Like,
          AsyncValue<LikeState>,
          LikeState,
          FutureOr<LikeState>,
          String
        > {
  const LikeFamily._()
    : super(
        retry: null,
        name: r'likeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for like state of a specific car spot

  LikeProvider call(String carSpotId) =>
      LikeProvider._(argument: carSpotId, from: this);

  @override
  String toString() => r'likeProvider';
}

/// Provider for like state of a specific car spot

abstract class _$Like extends $AsyncNotifier<LikeState> {
  late final _$args = ref.$arg as String;
  String get carSpotId => _$args;

  FutureOr<LikeState> build(String carSpotId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<LikeState>, LikeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LikeState>, LikeState>,
              AsyncValue<LikeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
