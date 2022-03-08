import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/notification.dart';

class NotificationRepository {
  NotificationRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<List<Notification>> fetchNotificationsByUserId(
    String userId,
    int page,
  ) async {
    final res = await _supabaseClient.rpc('paged_notifications', params: {
      'user_id': userId,
      'page': page,
    }).execute();
    if (res.data != null && res.error == null) {
      return (res.data as List<dynamic>).map((e) {
        print(e);
        final a = Notification.fromJson(e);
        print(a);
        return a;
      }).toList();
    } else {
      throw PlatformException(
          code: 'fetch user notifications error', message: res.error?.message);
    }
  }
}
