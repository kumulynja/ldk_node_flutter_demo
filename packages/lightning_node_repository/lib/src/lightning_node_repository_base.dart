import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:lightning_node_repository/src/enums/network.dart';
import 'package:lightning_node_repository/src/utils/node_config_extension.dart';
import 'package:lightning_node_repository/src/models/channel_events.dart';
import 'package:lightning_node_repository/src/models/node_config.dart';
import 'package:lightning_node_repository/src/models/payment_events.dart';

import 'package:path_provider/path_provider.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

class LightningNodeRepository {
  // Instance fields and properties
  late final ldk.Node _node;
  //bool _shouldListenToEvents = true;

  final StreamController<PaymentEvent> _paymentController =
      StreamController.broadcast();
  final StreamController<ChannelEvent> _channelController =
      StreamController.broadcast();

  Stream<PaymentEvent> get paymentStream => _paymentController.stream;
  Stream<ChannelEvent> get channelStream => _channelController.stream;

  // Instance methods
  Future<void> startNodeWithSeedBytes(
      {required List<int> seedBytes, Network network = Network.regtest}) async {
    ldk.Builder builder = await _getNodeBuilder(network: network);
    await builder.setEntropySeedBytes(
        seedBytes: ldk.U8Array64(Uint8List.fromList(seedBytes)));
    await _startNode(builder);
  }

  Future<void> startNodeWithMnemonic(
      {required String mnemonic, Network network = Network.regtest}) async {
    ldk.Builder builder = await _getNodeBuilder(network: network);
    await builder.setEntropyBip39Mnemonic(mnemonic: mnemonic);
    await _startNode(builder);
  }

  Future<void> stopNode() async {
    await _node.stop();
    //_shouldListenToEvents = false;
  }

  Future<void> setConfig(NodeConfig config) async {
    await _saveConfig(config);
  }

  Future<void> connectOpenChannel({
    required String addressIp,
    required int addressPort,
    required String counterpartyPublicKey,
    required int channelAmountSats,
    int? pushToCounterpartyMsat,
    required bool announceChannel,
  }) async {
    ldk.SocketAddr address = ldk.SocketAddr(ip: addressIp, port: addressPort);
    ldk.PublicKey nodeId = ldk.PublicKey(keyHex: counterpartyPublicKey);
    await _node.connectOpenChannel(
      address: address,
      nodeId: nodeId,
      channelAmountSats: channelAmountSats,
      announceChannel: announceChannel,
      pushToCounterpartyMsat: pushToCounterpartyMsat,
    );
  }

  Future<void> closeChannel({
    required ldk.U8Array32 channelId,
    required String counterpartyPublicKey,
    dynamic hint,
  }) async {
    ldk.PublicKey counterpartyNodeId =
        ldk.PublicKey(keyHex: counterpartyPublicKey);
    await _node.closeChannel(
        channelId: channelId, counterpartyNodeId: counterpartyNodeId);
  }

  Future<ldk.Invoice> generateInvoiceWithoutAmount({
    String description = '',
    int expirySecs = 3600, // 3600 seconds = 1 hour default
  }) async {
    return _node.receiveVariableAmountPayment(
        description: description, expirySecs: expirySecs);
  }

  Future<ldk.Invoice> generateInvoiceWithAmount({
    required int amountMsat,
    String description = '',
    int expirySecs = 3600, // 3600 seconds = 1 hour default
  }) async {
    return _node.receivePayment(
      amountMsat: amountMsat,
      description: description,
      expirySecs: expirySecs,
    );
  }

  Future<ldk.PaymentHash> sendInvoicePayment({
    required String invoice,
  }) async {
    return _node.sendPayment(
      invoice: ldk.Invoice(hex: invoice),
    );
  }

  Future<ldk.PaymentHash> sendInvoicePaymentUsingAmount({
    required String invoice,
    required int amountMsat,
  }) async {
    return _node.sendPaymentUsingAmount(
      invoice: ldk.Invoice(hex: invoice),
      amountMsat: amountMsat,
    );
  }

  // Getters
  Future<String> get nodeId async {
    final publicKey = await _node.nodeId();
    return publicKey.keyHex;
  }

  Future<String?> get listeningIp async {
    final listeningAddress = await _node.listeningAddress();
    return listeningAddress != null ? listeningAddress.ip : null;
  }

  Future<int?> get listeningPort async {
    final listeningAddress = await _node.listeningAddress();
    return listeningAddress != null ? listeningAddress.port : null;
  }

  Future<String> get newFundingAddress async {
    final address = await _node.newFundingAddress();
    return address.addressHex;
  }

  Future<ldk.Balance> get onChainBalance async {
    return await _node.onChainBalance();
  }

  Future<List<ldk.ChannelDetails>> get channels async {
    return await _node.listChannels();
  }

  // Private instance methods
  Future<ldk.Builder> _getNodeBuilder(
      {Network network = Network.regtest}) async {
    final config = await _getConfig(network: network);
    ldk.Builder builder =
        ldk.Builder.fromConfig(config: config.asLdkNodeConfig);
    return builder;
  }

  Future<void> _startNode(ldk.Builder builder) async {
    _node = await builder.build();
    await _node.start();
    // Start listening to node events
    //_listenToNodeEvents();
  }

  /**
  void _listenToNodeEvents() async {
    // Wrap the entire content of the method in a Future to run it in the background
    Future(() async {
      while (_shouldListenToEvents) {
        print("SHOULD LISTEN TO EVENTS");
        try {
          print('NEXT EVENT');
          final res = await _node.nextEvent();
          res.map(
            paymentSuccessful: (e) {
              _paymentController.sink
                  .add(PaymentSuccessful(e.paymentHash.field0));
            },
            paymentFailed: (e) {
              _paymentController.sink.add(PaymentFailed(e.paymentHash.field0));
            },
            paymentReceived: (e) {
              _paymentController.sink
                  .add(PaymentReceived(e.paymentHash.field0, e.amountMsat));
            },
            channelReady: (e) {
              _channelController.sink
                  .add(ChannelReady(e.channelId, e.userChannelId));
            },
            channelClosed: (e) {
              _channelController.sink
                  .add(ChannelClosed(e.channelId, e.userChannelId));
            },
            channelPending: (e) {
              _channelController.sink.add(ChannelPending(
                e.channelId,
                e.userChannelId,
                e.formerTemporaryChannelId,
                e.counterpartyNodeId.keyHex,
                e.fundingTxo.txid.field0,
                e.fundingTxo.vout,
              ));
            },
          );
          print('EVENT HANDLED');
          await _node.eventHandled();
          // Optionally, introduce a delay to avoid tight-loop polling
          print('Delaying...');
          await Future.delayed(Duration(milliseconds: 100));
        } catch (e) {
          // Handle or log the exception
          print('Error while listening to node events: $e');
          // Optionally, introduce a delay to avoid tight-loop polling
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
    });
  }
  */
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
        return NodeConfig.forRegtest(
            storageDirPath: nodePath,
            esploraServerUrl: Platform.isAndroid
                ? 'http://10.0.2.2:3002'
                : 'http://0.0.0.0:3002');
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
