import 'dart:io';
import 'dart:typed_data';

import 'package:ldk_node/ldk_node.dart' as ldk;
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;
import 'package:path_provider/path_provider.dart';

/// Bitcoin network enum
enum Network {
  ///Classic Bitcoin
  Bitcoin,

  ///Bitcoin’s testnet
  Testnet,

  ///Bitcoin’s signet
  Signet,

  ///Bitcoin’s regtest
  Regtest,
}

// Extension to be able to map the exposed Network enum onto ldk_node's Network enum.
// This way the lightning_node_repository enum can be used in the app code without it needing to know about ldk_node.
extension NetworkX on Network {
  ldk.Network get ldkNetwork {
    switch (this) {
      case Network.Bitcoin:
        return ldk.Network.Bitcoin;
      case Network.Testnet:
        return ldk.Network.Testnet;
      case Network.Signet:
        return ldk.Network.Testnet;
      case Network.Regtest:
        return ldk.Network.Regtest;
    }
  }

  bdk.Network get bdkNetwork {
    switch (this) {
      case Network.Bitcoin:
        return bdk.Network.Bitcoin;
      case Network.Testnet:
        return bdk.Network.Testnet;
      case Network.Signet:
        return bdk.Network.Testnet;
      case Network.Regtest:
        return bdk.Network.Regtest;
    }
  }
}

class LightningNodeRepository {
  late ldk.Node _node;

  Future<String> get nodeId async {
    final publicKey = await _node.nodeId();
    return publicKey.keyHex;
  }

  Future<void> startNodeWithSeedBytes(
      {required List<int> seedBytes, Network network = Network.Regtest}) async {
    ldk.Builder builder = await _getNodeBuilder(network: network);
    await builder.setEntropySeedBytes(
        seedBytes: ldk.U8Array64(Uint8List.fromList(seedBytes)));
    _node = await builder.build();
    await _node.start();
  }

  Future<void> startNodeWithMnemonic(
      {required String mnemonic, Network network = Network.Regtest}) async {
    //final path = await _localPath();
    //final dir = Directory(path);
    //print("Path files Before: ${await dir.list().toList()}");
    ldk.Builder builder = await _getNodeBuilder(network: network);
    //print("Path files after builder: ${await dir.list().toList()}");
    await builder.setEntropyBip39Mnemonic(mnemonic: mnemonic);
    //print("Path files after entropy: ${await dir.list().toList()}");
    //print("Source: ${builder.entropySource}");
    _node = await builder.build();
    await _node.start();
    //print("Path files after start node: ${await dir.list().toList()}");
  }

  Future<void> stopNode() async {
    await _node.stop();
  }

  Future<bool> isNodeRunning() async {
    return Future.value(false);
  }

  Future<ldk.Builder> _getNodeBuilder(
      {Network network = Network.Regtest}) async {
    final config = await _getConfig(network: network);
    ldk.Builder builder = ldk.Builder.fromConfig(config: config);
    return builder;
  }

  Future<ldk.Config> _getConfig({Network network = Network.Regtest}) async {
    // Todo: Check if config is stored in shared preferences, if not, return default config
    final config = await _getDefaultConfig(network: network);
    return config;
  }

  Future<ldk.Config> _getDefaultConfig(
      {Network network = Network.Regtest}) async {
    String nodePath =
        await _localPath(); // Path where the node will store its data
    String esploraUrl; // Electrum RPC Api url
    ldk.SocketAddr address; // Lightning P2P listening address
    switch (network) {
      case Network.Bitcoin:
        address = const ldk.SocketAddr(ip: "0.0.0.0", port: 9735);
        esploraUrl = "https://blockstream.info/api";
      case Network.Testnet:
        address = const ldk.SocketAddr(ip: "0.0.0.0", port: 19735);
        esploraUrl = "https://blockstream.info/testnet/api";
      case Network.Signet:
        throw UnimplementedError();
      case Network.Regtest:
        address = const ldk.SocketAddr(ip: "0.0.0.0", port: 19846);
        esploraUrl = "http://127.0.0.1:18443";
      //esploraUrl = Platform.isAndroid ? "http://10.0.2.2:3002" : "http://0.0.0.0:3002"; // Please use 10.0.2.2, instead of 0.0.0.0
    }

    final config = ldk.Config(
        storageDirPath: nodePath,
        esploraServerUrl: esploraUrl,
        network: network.ldkNetwork,
        listeningAddress: address,
        defaultCltvExpiryDelta: 144);
    return config;
  }

  Future<void> _saveConfig({required ldk.Config config}) async {
    // Save config to shared preferences
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
