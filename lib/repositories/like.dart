import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LikeRepository {
  LikeRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<void> likePost({
    required String userId,
    required String postId,
  }) async {
    final res = await _supabaseClient.from('likes').insert([
      {'user_id': userId, 'post_id': postId},
    ]).execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'like post error', message: res.error?.message);
    }
  }

  Future<void> unlikePost({
    required String userId,
    required String postId,
  }) async {
    final res = await _supabaseClient
        .from('likes')
        .delete()
        .match({'user_id': userId, 'post_id': postId}).execute();
    if (res.data != null && res.error == null) {
      return;
    } else {
      throw PlatformException(
          code: 'like post error', message: res.error?.message);
    }
  }
}
