import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/post.dart';

class PostRepository {
  PostRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<Post> publishPost({
    required String authorId,
    required String content,
  }) async {
    final res = await _supabaseClient.from('posts').insert([
      {
        'author_id': authorId,
        'content': content,
      },
    ]).execute();
    if (res.data != null && res.error == null) {
      return Post.fromJson(res.data[0]);
    } else {
      throw PlatformException(
          code: 'publish post error', message: res.error?.message);
    }
  }
}
