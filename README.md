# LDK Node Flutter Demo

A project to demonstrate and teach about the use of the Lightning Development Kit and the related Bitcoin Development Kit to create a Bitcoin Lightning wallet app in Flutter, facilitated by packages like ldk_node_flutter and bdk_flutter.

## Current progress

- [x] App setup and structure using the BLoC pattern and separate repository packages for good separation of concerns, reusability and flexibility.
- [x] BIP39 mnemonic generation and storage in secure storage.
- [x] LDK Node configuration and initialization.
- [x] Node info visualization.
- [x] On-chain wallet funding and balance display.
- [x] Lightning channel opening and spendable Lightning balance display.
- [x] Lightning invoice generation with or without amount.
- [x] Lightning invoice payment.
- [ ] Lightning payment history display.
- [ ] Handling events from the LDK Node.
- [ ] Lightning channel closing.
- [ ] Lightning keysend payment.
- [ ] Send the on-chain balance to a Bitcoin address.
- [ ] Lightning BOLT12 payment request generation and payment.
- [ ] Unified Bitcoin savings wallet with BDK.

[progress-ldk-node-flutter-demo.webm](https://github.com/kumulynja/ldk_node_flutter_demo/assets/92805150/e0a865d9-cc7e-4d5b-b773-388d29556ce6)

## Local development environment setup

### 1. Polar
Download and install [Polar](https://github.com/jamaljsr/polar).
Create a network in Polar that has at least one Lightning node and one Bitcoin core node. The networks run here will always be local `regtest` networks and not connected to the real Bitcoin or Lightning networks. The nodes will be accessible from the app through the local network. Testing on testnet is also possible, but not recommended for development since you will need to obtain testnet coins which are difficult to come by at times. With Polar on `regtest` you can generate as many test coins as you want for testing.

### 2. Esplora server
LDK Node in its current version is only compatible with an Esplora backend for blockhain info. So we need to set up a local Esplora server that connects to our Bitcoin Core node in Polar.

Clone the Github repository of [Esplora server](https://github.com/blockstream/electrs) and go into the directory to check out the branch to use like this:

```
git clone https://github.com/blockstream/electrs && cd electrs
git checkout new-index
```
Then run it pointing to the `.bitcoin` directory of your Bitcoin Core node in Polar and specify the network, which is `regtest`:

`cargo run --release --bin electrs -- -vvvv --daemon-dir $HOME/.polar/networks/1/volumes/bitcoind/backend1 --network regtest`

If you already created more networks in Polar, the 1 in the path of the `--daemon-dir` parameter might be different. To find the correct path, check out the `Mounts` in Docker for the Bitcoin Core (bitcoind) container. It should be the one mounted to the internal `/home/bitcoin/.bitcoin` path.

If it is the first time you run it, first some dependencies will be downloaded and installed, but then the server should start and you should see something like this:

```
DEBUG - Server listening on 127.0.0.1:24224
DEBUG - Running accept thread
...
INFO - Electrum RPC server running on 127.0.0.1:60401
INFO - REST server running on 127.0.0.1:3002
```

The HTTP REST server is what we need to connect to from the app, so in the example it is running on the default port 3002.

### 3. LDK Node Config

In the [lightning_node_repository_base.dart](packages/lightning_node_repository/lib/src/lightning_node_repository_base.dart) file you can change the port of the Espora server to connect to in case you are running it on another port then 3002.

```
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
```

Notice that for Android the address for localhost is `10.0.2.2` instead of 0.0.0.0. This is because of the way Android emulators work. You should also keep this in mind when opening channels to local Lightning nodes in Polar from the app, the IP to enter to open a channel to, will also need to be `10.0.2.2` instead of `127.0.0.1` or `0.0.0.0` on Android emulators.

## Lightning Development Kit

## Bitcoin Development Kit

## BIP39 Mnemonic

The application will use bdk_flutter to generate a BIP39 compliant mnemonic, also known as seed phrase. This is currently not required when using ldk_node, but it enables the creation and recovery of both the Lightning wallet and the on-chain wallet while having to backup only one mnemonic. It also makes the use of ldk_node more secure, since currently (version 0.1.0) the only other entropy sources that ldk_node can consume or generate have to be stored on the file system, which is insecure. By generating the mnemonic first, it can be stored in and retrieved from secure storage and then be used only in memory.

## Getting Started with Flutter development

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

