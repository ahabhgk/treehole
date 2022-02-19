import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PalRepository {
  PalRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<int> fetchPalsCountByUserId(String id) async {
    final res = await _supabaseClient
        .from('pals')
        .select('')
        .or('left_id.eq.$id,right_id.eq.$id')
        .execute(count: CountOption.exact);
    if (res.data != null && res.error == null) {
      return res.count!;
    } else {
      throw PlatformException(
          code: 'get user posts count error', message: res.error?.message);
    }
  }
}
