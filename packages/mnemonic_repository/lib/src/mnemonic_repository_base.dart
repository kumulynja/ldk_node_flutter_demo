// TODO: Put public facing types in this file.

import 'package:secure_storage_layer/secure_storage_layer.dart';

// Todo: Add possible exceptions and error handling

class MnemonicRepository {
  MnemonicRepository({SecureStorageLayer? secureStorageLayer})
      : _secureStorageLayer = secureStorageLayer ?? SecureStorageLayer();

  final SecureStorageLayer _secureStorageLayer;
  static const _mnemonicKey = 'mnemonic';

  Future<void> storeMnemonic(String mnemonic) async {
    await _secureStorageLayer
        .writeSecureData(SecureStorageItem(_mnemonicKey, mnemonic));
  }

  Future<bool> doesMnemonicExist() async {
    return await _secureStorageLayer.containsKeyInSecureData(_mnemonicKey);
  }

  Future<String> retrieveMnemonic() async {
    return await _secureStorageLayer.readSecureData(_mnemonicKey) ?? '';
  }

  Future<void> deleteMnemonic() async {
    await _secureStorageLayer.deleteSecureData(_mnemonicKey);
  }
}
