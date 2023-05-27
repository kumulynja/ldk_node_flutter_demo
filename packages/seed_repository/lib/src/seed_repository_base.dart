// TODO: Put public facing types in this file.

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:secure_storage_layer/secure_storage_layer.dart';

// Todo: Add possible exceptions and error handling

class SeedRepository {
  SeedRepository({SecureStorageLayer? secureStorageLayer})
      : _secureStorageLayer = secureStorageLayer ?? SecureStorageLayer();

  final SecureStorageLayer _secureStorageLayer;
  static const _mnemonicKey = 'mnemonic';

  Future<Mnemonic> create24WordMnemonic() async {
    return Mnemonic.create(WordCount.Words24);
  }

  Future<void> storeMnemonic(String mnemonic) async {
    await _secureStorageLayer
        .writeSecureData(SecureStorageItem(_mnemonicKey, mnemonic));
  }

  Future<bool> doesMnemonicExist() async {
    return _secureStorageLayer.containsKeyInSecureData(_mnemonicKey);
  }

  Future<Mnemonic> retrieveMnemonic() async {
    final mnemonicWords =
        await _secureStorageLayer.readSecureData(_mnemonicKey);
    print('words: $mnemonicWords');
    if (mnemonicWords != null) {
      return Mnemonic.fromString(mnemonicWords);
    } else {
      throw MnemonicRetrievalFailure.fromCode('missing-mnemonic');
    }
  }

  Future<void> deleteMnemonic() async {
    await _secureStorageLayer.deleteSecureData(_mnemonicKey);
  }
}

extension UnifiedWallet on Mnemonic {
  Future<List<int>> toLightningSeed(Network network) async {
    final masterXprv =
        await DescriptorSecretKey.create(network: network, mnemonic: this);
    final derivedXprv =
        await masterXprv.derive(await DerivationPath.create(path: "m/535h"));
    return derivedXprv.secretBytes();
  }
}

class MnemonicRetrievalFailure implements Exception {
  const MnemonicRetrievalFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;

  factory MnemonicRetrievalFailure.fromCode(String code) {
    switch (code) {
      case 'missing-mnemonic':
        return const MnemonicRetrievalFailure(
          'Mnenomic is not found, please create or recover one first.',
        );
      default:
        return const MnemonicRetrievalFailure();
    }
  }
}
