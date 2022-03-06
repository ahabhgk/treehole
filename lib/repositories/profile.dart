import 'dart:math';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/emotion.dart';
import 'package:treehole/models/profile.dart';

class ProfileRepository {
  ProfileRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<Profile> fetchUserProfile(String id) async {
    final res = await _supabaseClient
        .from('profiles')
        .select('id, username, avatar_url')
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

  Future<Emotion> fetchUserEmotion(String userId) async {
    final res = await _supabaseClient
        .from('profiles')
        .select('joy, mild, disgust, depressed, anger')
        .eq('id', userId)
        .single()
        .execute();
    if (res.data != null && res.error == null) {
      return Emotion.fromJson(res.data);
    } else {
      throw PlatformException(
          code: 'fetch user profile error', message: res.error?.message);
    }
  }

  Future<void> updateUserEomtion(
    String userId,
    Emotion cur,
    int postCount,
  ) async {
    final acc = await fetchUserEmotion(userId);
    // acc * ((n - 1) / n) + cur / n
    final emotion = acc * ((postCount - 1) / postCount) + cur / postCount;
    final res = await _supabaseClient
        .from('profiles')
        .update(emotion.toJson())
        .eq('id', userId)
        .execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'fetch user profile error', message: res.error?.message);
    }
  }

  Future<Profile> fetchMatchedPal(String userId) async {
    final res = await _supabaseClient
        .rpc('match_pal', params: {'user_id': userId}).execute();
    if (res.data != null && res.error == null) {
      final index = Random().nextInt((res.data as List<dynamic>).length);
      return Profile.fromJson(res.data[index]);
    } else {
      throw PlatformException(
        code: 'fetch matched user profile error',
        message: res.error?.message,
      );
    }
  }
}
