import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/utils/constants.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required SupabaseClient supabaseClient,
    required FlutterSecureStorage localStorage,
  })  : _supabaseClient = supabaseClient,
        _localStorage = localStorage;

  final SupabaseClient _supabaseClient;
  final FlutterSecureStorage _localStorage;

  Future<String> signup({
    required String email,
    required String password,
  }) async {
    final res = await _supabaseClient.auth.signUp(email, password);
    if (res.data != null && res.error == null) {
      return res.data!.persistSessionString;
    } else {
      throw PlatformException(
          code: 'signup error', message: res.error?.message);
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final res =
        await _supabaseClient.auth.signIn(email: email, password: password);
    if (res.data != null && res.error == null) {
      return res.data!.persistSessionString;
    } else {
      throw PlatformException(code: 'login error', message: res.error?.message);
    }
  }

  Future<String?> recoverSession() async {
    final session = await getSession();
    if (session != null) {
      final res = await _supabaseClient.auth.recoverSession(session);
      if (res.data != null && res.error == null) {
        return res.data!.persistSessionString;
      } else {
        throw PlatformException(
            code: 'recover session error', message: res.error?.message);
      }
    }
    return null;
  }

  void setSession(String session) {
    _localStorage.write(key: persistentSessionKey, value: session);
  }

  Future<String?> getSession() {
    return _localStorage.read(key: persistentSessionKey);
  }

  String? userId() {
    return _supabaseClient.auth.user()?.id;
  }
}
