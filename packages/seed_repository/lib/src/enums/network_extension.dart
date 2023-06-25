import 'package:seed_repository/src/enums/network.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;

// Extension to be able to map the exposed Network enum onto ldk_node's Network enum.
// This way the lightning_node_repository enum can be used in the app code without it needing to know about ldk_node.
extension NetworkX on Network {
  bdk.Network get asBdkNetwork {
    switch (this) {
      case Network.bitcoin:
        return bdk.Network.Bitcoin;
      case Network.testnet:
        return bdk.Network.Testnet;
      case Network.signet:
        return bdk.Network.Testnet;
      case Network.regtest:
        return bdk.Network.Regtest;
    }
  }
}
