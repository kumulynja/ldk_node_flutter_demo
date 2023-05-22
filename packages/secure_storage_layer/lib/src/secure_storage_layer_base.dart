library secure_storage_layer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_storage_layer/src/models/secure_storage_item.dart';

// Todo: Add possible exceptions and error handling

class SecureStorageLayer {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(SecureStorageItem newItem) async {
    await _secureStorage.write(
        key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String?> readSecureData(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }
}
