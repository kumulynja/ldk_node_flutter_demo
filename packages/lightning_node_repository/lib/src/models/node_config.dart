// node_config.dart

import 'dart:convert';

import 'package:lightning_node_repository/src/enums/network.dart';

class NodeConfig {
  final String storageDirPath; // Path where the node will store its data
  final String esploraServerUrl; // Electrum RPC Api url
  final Network network;
  final String listeningAddressIp; // IP of the Lightning P2P listening address
  final int listeningAddressPort; // Port of the Lightning P2P listening address
  final int defaultCltvExpiryDelta;

  NodeConfig({
    required this.storageDirPath,
    required this.esploraServerUrl,
    required this.network,
    required this.listeningAddressIp,
    required this.listeningAddressPort,
    required this.defaultCltvExpiryDelta,
  });

  NodeConfig.forBitcoin({
    required String storageDirPath,
    String esploraServerUrl = 'https://blockstream.info/api',
    String listeningAddressIp = '0.0.0.0',
    int listeningAddressPort = 9735,
    int defaultCltvExpiryDelta = 144,
  }) : this(
          storageDirPath: storageDirPath,
          esploraServerUrl: esploraServerUrl,
          network: Network.bitcoin,
          listeningAddressIp: listeningAddressIp,
          listeningAddressPort: listeningAddressPort,
          defaultCltvExpiryDelta: defaultCltvExpiryDelta,
        );

  NodeConfig.forTestnet({
    required String storageDirPath,
    String esploraServerUrl = 'https://blockstream.info/testnet/api',
    String listeningAddressIp = '0.0.0.0',
    int listeningAddressPort = 19735,
    int defaultCltvExpiryDelta = 144,
  }) : this(
          storageDirPath: storageDirPath,
          esploraServerUrl: esploraServerUrl,
          network: Network.testnet,
          listeningAddressIp: listeningAddressIp,
          listeningAddressPort: listeningAddressPort,
          defaultCltvExpiryDelta: defaultCltvExpiryDelta,
        );

  NodeConfig.forRegtest({
    required String storageDirPath,
    String esploraServerUrl = 'http://127.0.0.1:18444',
    String listeningAddressIp = '0.0.0.0',
    int listeningAddressPort = 19846,
    int defaultCltvExpiryDelta = 144,
  }) : this(
          storageDirPath: storageDirPath,
          esploraServerUrl: esploraServerUrl,
          network: Network.regtest,
          listeningAddressIp: listeningAddressIp,
          listeningAddressPort: listeningAddressPort,
          defaultCltvExpiryDelta: defaultCltvExpiryDelta,
        );

  factory NodeConfig.fromJson(Map<String, dynamic> json) {
    return NodeConfig(
      storageDirPath: json['storageDirPath'],
      esploraServerUrl: json['esploraServerUrl'],
      network: _stringToNetwork(json['network']),
      listeningAddressIp: json['listeningAddressIp'],
      listeningAddressPort: json['listeningAddressPort'],
      defaultCltvExpiryDelta: json['defaultCltvExpiryDelta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storageDirPath': storageDirPath,
      'esploraServerUrl': esploraServerUrl,
      'network': _networkToString(network),
      'listeningAddressIp': listeningAddressIp,
      'listeningAddressPort': listeningAddressPort,
      'defaultCltvExpiryDelta': defaultCltvExpiryDelta,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory NodeConfig.fromJsonString(String jsonString) {
    return NodeConfig.fromJson(jsonDecode(jsonString));
  }

  // Define conversion maps
  static const Map<String, Network> _stringToNetworkMap = {
    'bitcoin': Network.bitcoin,
    'testnet': Network.testnet,
    'signet': Network.signet,
    'regtest': Network.regtest,
  };

  static const Map<Network, String> _networkToStringMap = {
    Network.bitcoin: 'bitcoin',
    Network.testnet: 'testnet',
    Network.signet: 'signet',
    Network.regtest: 'regtest',
  };

  static Network _stringToNetwork(String networkString) {
    return _stringToNetworkMap[networkString] ??
        (throw ArgumentError('Unknown network string: $networkString'));
  }

  static String _networkToString(Network network) {
    return _networkToStringMap[network] ??
        (throw ArgumentError('Unknown network: $network'));
  }
}
