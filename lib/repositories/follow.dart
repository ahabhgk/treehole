import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/profile.dart';

class FollowRepository {
  FollowRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<int> fetchPalsCountByUserId(String id) async {
    final res = await _supabaseClient.rpc('user_pals_id',
        params: {'user_id': id}).execute(count: CountOption.exact);
    if (res.data != null && res.error == null) {
      return res.count!;
    } else {
      throw PlatformException(
          code: 'get user posts count error', message: res.error?.message);
    }
  }

  Future<List<Profile>> fetchPalsProfileByUserId(String id) async {
    final res = await _supabaseClient
        .rpc('user_pals', params: {'user_id': id}).execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>)
          .map((e) => Profile.fromJson(e))
          .toList();
    } else {
      throw PlatformException(
          code: 'get user posts count error', message: res.error?.message);
    }
  }
}
