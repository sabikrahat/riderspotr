// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Subscription)
const subscriptionProvider = SubscriptionProvider._();

final class SubscriptionProvider
    extends $AsyncNotifierProvider<Subscription, SubscriptionTier> {
  const SubscriptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionHash();

  @$internal
  @override
  Subscription create() => Subscription();
}

String _$subscriptionHash() => r'b66bf4dc4b59e8ced631d14acb489800a134e375';

abstract class _$Subscription extends $AsyncNotifier<SubscriptionTier> {
  FutureOr<SubscriptionTier> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SubscriptionTier>, SubscriptionTier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubscriptionTier>, SubscriptionTier>,
              AsyncValue<SubscriptionTier>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
