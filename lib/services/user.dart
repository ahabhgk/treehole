import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/profile.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoad extends UserState {}

class UserSigningUp extends UserState {}

class UserLogingIn extends UserState {}

class UserError extends UserState {
  UserError({required this.message});

  final String message;
}

class UserLoaded extends UserState {
  UserLoaded({
    required this.profile,
  });

  final Profile profile;
}

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required AuthenticationRepository authRepo,
    required ProfileRepository profileRepo,
  })  : _authRepo = authRepo,
        _profileRepo = profileRepo,
        super(UserInitial());

  final AuthenticationRepository _authRepo;
  final ProfileRepository _profileRepo;

  Future<Profile> loadProfile() async {
    final id = _authRepo.userId();
    return _profileRepo.getUserProfile(id);
  }

  Future<void> saveProfile({
    required String username,
    String? avatarUrl,
  }) async {
    final id = _authRepo.userId();
    final profile = Profile(id: id, username: username, avatarUrl: avatarUrl);
    await _profileRepo.saveUserProfile(profile);
  }

  Future<void> recover() async {
    try {
      final session = await _authRepo.recoverSession();
      if (session == null) {
        emit(UserLoad());
      } else {
        _authRepo.setSession(session);
        final profile = await loadProfile();
        emit(UserLoaded(profile: profile));
      }
    } catch (err) {
      emit(UserLoad());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(UserLogingIn());
      final session = await _authRepo.login(
        email: email,
        password: password,
      );
      _authRepo.setSession(session);
      final profile = await loadProfile();
      emit(UserLoaded(profile: profile));
    } on PlatformException catch (err) {
      emit(UserError(message: err.message ?? 'Error loging in'));
    } catch (err) {
      emit(UserError(message: 'Error loging in'));
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      emit(UserSigningUp());
      final session = await _authRepo.signup(
        email: email,
        password: password,
      );
      _authRepo.setSession(session);
      await saveProfile(username: username);
      emit(UserLoad());
    } on PlatformException catch (err) {
      emit(UserError(message: err.message ?? 'Error signing in'));
    } catch (err) {
      emit(UserError(message: 'Error signing in'));
    }
  }
}
