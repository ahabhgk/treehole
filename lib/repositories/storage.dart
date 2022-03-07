import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepository {
  StorageRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Future<String> uploadAvatar(
    String userId,
    XFile imageFile,
  ) async {
    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.name.split('.').last;
    final fileName = '$userId-${DateTime.now().toIso8601String()}.$fileExt';

    final res = await _supabaseClient.storage
        .from('avatars')
        .uploadBinary(fileName, bytes);
    if (res.data != null && res.error == null) {
      final urlRes =
          _supabaseClient.storage.from('avatars').getPublicUrl(fileName);
      return urlRes.data!;
    } else {
      throw PlatformException(
          code: 'upload avatar error', message: res.error?.message);
    }
  }
}
