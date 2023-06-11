import 'package:lightning_node_repository/src/enums/network.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

// Extension to be able to map the exposed Network enum onto ldk_node's Network enum.
// This way the lightning_node_repository enum can be used in the app code without it needing to know about ldk_node.
extension LdkNetwork on Network {
  ldk.Network get ldkNetwork {
    switch (this) {
      case Network.bitcoin:
        return ldk.Network.bitcoin;
      case Network.testnet:
        return ldk.Network.testnet;
      case Network.signet:
        return ldk.Network.signet;
      case Network.regtest:
        return ldk.Network.regtest;
    }
  }
}
