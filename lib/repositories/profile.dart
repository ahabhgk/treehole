import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/profile.dart';

class ProfileRepository {
  ProfileRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<Profile> fetchUserProfile(String id) async {
    final res = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .execute();
    if (res.data != null && res.error == null) {
      return Profile.fromJson(res.data);
    } else {
      throw PlatformException(
          code: 'fetch user profile error', message: res.error?.message);
    }
  }

  Future<void> saveUserProfile(Profile profile) async {
    final res = await _supabaseClient
        .from('profiles')
        .upsert(profile.toJson())
        .execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'get user profile error', message: res.error?.message);
    }
  }
}
