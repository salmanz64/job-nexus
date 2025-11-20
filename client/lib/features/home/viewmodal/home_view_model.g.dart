// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeViewModel)
const homeViewModelProvider = HomeViewModelProvider._();

final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, AsyncValue<List<JobModel>>?> {
  const HomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<JobModel>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<JobModel>>?>(value),
    );
  }
}

String _$homeViewModelHash() => r'21a91379a4c77cf00c228fe357345f73b62e89ad';

abstract class _$HomeViewModel extends $Notifier<AsyncValue<List<JobModel>>?> {
  AsyncValue<List<JobModel>>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<JobModel>>?, AsyncValue<List<JobModel>>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<JobModel>>?,
                AsyncValue<List<JobModel>>?
              >,
              AsyncValue<List<JobModel>>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
