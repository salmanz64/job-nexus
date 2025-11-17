import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/features/auth/models/user_model.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:jobnexus/features/auth/repository/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> initSharePreferences() async {
    await _authLocalRepository.init();
  }

  //Sign Up
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };

    print(val);
  }

  //Log In
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.logIn(
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };

    print(val);
  }

  //helpers
  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state = AsyncValue.data(user);
  }
}
