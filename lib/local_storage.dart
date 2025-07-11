// Define the custom LocalStorage implementation
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MkandoWalletSecureStorage extends LocalStorage {

  final storage = FlutterSecureStorage();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    return storage.read(key: supabasePersistSessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    return storage.containsKey(key: supabasePersistSessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    return storage.write(key: supabasePersistSessionKey, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    return storage.delete(key: supabasePersistSessionKey);
  }
}