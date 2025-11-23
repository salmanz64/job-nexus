// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_remote_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(applicationRemoteRepository)
const applicationRemoteRepositoryProvider =
    ApplicationRemoteRepositoryProvider._();

final class ApplicationRemoteRepositoryProvider
    extends
        $FunctionalProvider<
          ApplicationRemoteRepository,
          ApplicationRemoteRepository,
          ApplicationRemoteRepository
        >
    with $Provider<ApplicationRemoteRepository> {
  const ApplicationRemoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationRemoteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationRemoteRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApplicationRemoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApplicationRemoteRepository create(Ref ref) {
    return applicationRemoteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicationRemoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicationRemoteRepository>(value),
    );
  }
}

String _$applicationRemoteRepositoryHash() =>
    r'b00493d3ededa8cdcabf4ebcd1d04196b45fa60c';
