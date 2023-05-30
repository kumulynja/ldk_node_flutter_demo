import 'package:ldk_node/ldk_node.dart' as ldk;
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;

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
  Future<bool> isNodeRunning() {
    return Future.value(false);
  }
}
