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

  Future<List<Post>> fetchPostsByAuthorId(String id) async {
    final res = await _supabaseClient
        .from('posts')
        .select('*')
        .eq('author_id', id)
        .execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>).map((e) => Post.fromJson(e)).toList();
    } else {
      throw PlatformException(
          code: 'fetch user posts error', message: res.error?.message);
    }
  }

  Future<int> fetchPostsCountByAuthorId(String id) async {
    final res = await _supabaseClient
        .from('posts')
        .select('')
        .eq('author_id', id)
        .execute(count: CountOption.exact);
    if (res.data != null && res.error == null) {
      return res.count!;
    } else {
      throw PlatformException(
          code: 'fetch user posts count error', message: res.error?.message);
    }
  }

  Future<List<Post>> fetchPalsPosts(String id) async {
    final res = await _supabaseClient
        .rpc('feed_posts', params: {'user_id': id}).execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>).map((e) => Post.fromJson(e)).toList();
    } else {
      throw PlatformException(
          code: 'fetch pals posts error', message: res.error?.message);
    }
  }
}
