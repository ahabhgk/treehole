import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/profile.dart';

class FollowRepository {
  FollowRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<int> fetchPalsCountByUserId(String id) async {
    final res = await _supabaseClient
        .from('pals')
        .select('user_id')
        .eq('user_id', id)
        .execute(count: CountOption.exact);
    if (res.data != null && res.error == null) {
      return res.count!;
    } else {
      throw PlatformException(
          code: 'get user posts count error', message: res.error?.message);
    }
  }

  Future<List<Profile>> fetchPalsProfileByUserId(String id) async {
    final res = await _supabaseClient
        .from('pals')
        .select('profiles:pal_id ( id, username, avatar_url )')
        .eq('user_id', id)
        .execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>)
          .map((e) => Profile.fromJson(e['profiles']))
          .toList();
    } else {
      throw PlatformException(
          code: 'get user posts count error', message: res.error?.message);
    }
  }

  Future<void> followUser(String followingId, String followedId) async {
    final res = await _supabaseClient.from('follow').insert([
      {
        'following_id': followingId,
        'followed_id': followedId,
      }
    ]).execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'follow user error', message: res.error?.message);
    }
  }

  Future<void> unfollowUser(String followingId, String followedId) async {
    final res = await _supabaseClient.from('follow').delete().match({
      'following_id': followingId,
      'followed_id': followedId,
    }).execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'unfollow user error', message: res.error?.message);
    }
  }
}
