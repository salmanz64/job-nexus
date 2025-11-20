// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileViewModel)
const profileViewModelProvider = ProfileViewModelProvider._();

final class ProfileViewModelProvider
    extends
        $NotifierProvider<
          ProfileViewModel,
          AsyncValue<RecruiterProfileModel>?
        > {
  const ProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileViewModelHash();

  @$internal
  @override
  ProfileViewModel create() => ProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RecruiterProfileModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RecruiterProfileModel>?>(
        value,
      ),
    );
  }
}

String _$profileViewModelHash() => r'd934be7cfc0170aaa97769980f6b7b0129e719ee';

abstract class _$ProfileViewModel
    extends $Notifier<AsyncValue<RecruiterProfileModel>?> {
  AsyncValue<RecruiterProfileModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<RecruiterProfileModel>?,
              AsyncValue<RecruiterProfileModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RecruiterProfileModel>?,
                AsyncValue<RecruiterProfileModel>?
              >,
              AsyncValue<RecruiterProfileModel>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
