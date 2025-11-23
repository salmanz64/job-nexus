// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApplicationViewModel)
const applicationViewModelProvider = ApplicationViewModelProvider._();

final class ApplicationViewModelProvider
    extends
        $NotifierProvider<
          ApplicationViewModel,
          AsyncValue<List<ApplicationModel>>
        > {
  const ApplicationViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationViewModelHash();

  @$internal
  @override
  ApplicationViewModel create() => ApplicationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ApplicationModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ApplicationModel>>>(
        value,
      ),
    );
  }
}

String _$applicationViewModelHash() =>
    r'c388d9452cbc4b86c36fe6b52f27647909d44386';

abstract class _$ApplicationViewModel
    extends $Notifier<AsyncValue<List<ApplicationModel>>> {
  AsyncValue<List<ApplicationModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ApplicationModel>>,
              AsyncValue<List<ApplicationModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ApplicationModel>>,
                AsyncValue<List<ApplicationModel>>
              >,
              AsyncValue<List<ApplicationModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
