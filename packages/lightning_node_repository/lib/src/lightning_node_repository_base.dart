import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:lightning_node_repository/src/enums/network.dart';
import 'package:lightning_node_repository/src/ldk/channel_details_extension.dart';
import 'package:lightning_node_repository/src/ldk/node_config_extension.dart';
import 'package:lightning_node_repository/src/models/channel.dart';
import 'package:lightning_node_repository/src/models/node_config.dart';
import 'package:lightning_node_repository/src/models/balance.dart';

import 'package:path_provider/path_provider.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

class LightningNodeRepository {
  // Instance fields and properties
  late final ldk.Node _node;

  // Instance methods
  Future<void> startNodeWithSeedBytes(
      {required List<int> seedBytes, Network network = Network.regtest}) async {
    ldk.Builder builder = await _getNodeBuilder(network: network);
    await builder.setEntropySeedBytes(
        seedBytes: ldk.U8Array64(Uint8List.fromList(seedBytes)));
    _node = await builder.build();
    await _node.start();
  }

  Future<void> startNodeWithMnemonic(
      {required String mnemonic, Network network = Network.regtest}) async {
    ldk.Builder builder = await _getNodeBuilder(network: network);
    await builder.setEntropyBip39Mnemonic(mnemonic: mnemonic);
    _node = await builder.build();
    await _node.start();
  }

  Future<void> stopNode() async {
    await _node.stop();
  }

  Future<void> setConfig(NodeConfig config) async {
    await _saveConfig(config);
  }

  // Getters
  Future<String> get nodeId async {
    final publicKey = await _node.nodeId();
    return publicKey.keyHex;
  }

  Future<String> get newFundingAddress async {
    final address = await _node.newFundingAddress();
    return address.addressHex;
  }

  Future<Balance> get balance async {
    final onChainBalance = await _node.onChainBalance();
    final channels = await _node.listChannels();
    final totalOutboundCapacity = channels.fold(
      0,
      (summedOutboundCapacity, channel) =>
          summedOutboundCapacity + channel.outboundCapacityMsat,
    );
    return Balance(
      totalOutboundCapacity: totalOutboundCapacity,
      confirmed: onChainBalance.confirmed,
      untrustedPending: onChainBalance.untrustedPending,
      immature: onChainBalance.immature,
      trustedPending: onChainBalance.trustedPending,
    );
  }

  Future<List<Channel>> get channels async {
    final channels = await _node.listChannels();
    return channels.map((channel) => channel.asChannel).toList();
  }

  // Private instance methods
  Future<ldk.Builder> _getNodeBuilder(
      {Network network = Network.regtest}) async {
    final config = await _getConfig(network: network);
    ldk.Builder builder =
        ldk.Builder.fromConfig(config: config.asLdkNodeConfig);
    return builder;
  }

  Future<NodeConfig> _getConfig({Network network = Network.regtest}) async {
    final file = await _getConfigFile();

    if (file.existsSync()) {
      try {
        // Read from file
        String serializedJsonStringConfig = await file.readAsString();
        // Deserialize JSON to Config object
        return NodeConfig.fromJsonString(serializedJsonStringConfig);
      } catch (e) {
        // Log the error or handle it appropriately
        print('Config file could not be read: $e');
      }
    }

    // If the file does not exist or there was an error reading/deserializing,
    // fallback to the default config
    return _getDefaultConfig(network: network);
  }

  Future<NodeConfig> _getDefaultConfig({
    Network network = Network.regtest,
  }) async {
    String nodePath =
        await _localPath(); // Path where the node will store its data
    switch (network) {
      case Network.bitcoin:
        return NodeConfig.forBitcoin(storageDirPath: nodePath);
      case Network.testnet:
        return NodeConfig.forTestnet(storageDirPath: nodePath);
      case Network.signet:
        throw UnimplementedError('Signet network is not supported yet.');
      case Network.regtest:
        return NodeConfig.forRegtest(storageDirPath: nodePath);
      //esploraUrl = Platform.isAndroid ? "http://10.0.2.2:3002" : "http://0.0.0.0:3002"; // Please use 10.0.2.2, instead of 0.0.0.0
      default:
        throw ArgumentError('Invalid network: $network');
    }
  }

  Future<void> _saveConfig(NodeConfig config) async {
    // Serialize config to JSON
    String serializedConfig = jsonEncode(config.toJson());
    // Write JSON to file
    final file = await _getConfigFile();
    await file.writeAsString(serializedConfig);
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _getConfigFile() async {
    return File('${await _localPath()}/config.json');
  }
}
