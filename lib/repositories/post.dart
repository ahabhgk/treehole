import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/post.dart';

class PostRepository {
  PostRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<void> publishPost({
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
      return;
    } else {
      throw PlatformException(
          code: 'publish post error', message: res.error?.message);
    }
  }

  Future<List<Post>> fetchPostsByAuthorId(String id) async {
    final res = await _supabaseClient
        .from('posts')
        .select('*, profiles(username, avatar_url)')
        .eq('author_id', id)
        .order('created_at', ascending: false)
        .execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>)
          .map((e) => Post.fromJson({...e, ...e['profiles']}))
          .toList();
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

  Future<List<Post>> fetchFeedPosts(String id) async {
    final res = await _supabaseClient
        .rpc('feed_posts', params: {'user_id': id}).execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>).map((e) => Post.fromJson(e)).toList();
    } else {
      throw PlatformException(
          code: 'fetch feed posts error', message: res.error?.message);
    }
  }

  Future<List<Post>> fetchFoundPosts(
    String id, {
    required OrderBy orderBy,
  }) async {
    var builder = _supabaseClient
        .from('posts')
        .select('*, profiles(username, avatar_url)')
        .order('created_at', ascending: false);
    if (orderBy == OrderBy.hot) {
      // TODO add likes table
      // builder.order('column');
    }
    final res = await builder.execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>)
          .map((e) => Post.fromJson({...e, ...e['profiles']}))
          .toList();
    } else {
      throw PlatformException(
          code: 'fetch feed posts error', message: res.error?.message);
    }
  }
}

enum OrderBy {
  suitability,
  hot,
  time,
}
