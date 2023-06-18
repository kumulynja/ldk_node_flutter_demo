import 'package:ldk_node_flutter_demo/enums/app_network.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart' as ln;
import 'package:seed_repository/seed_repository.dart' as seed;

extension AppNetworkX on AppNetwork {
  seed.Network get asSeedRepositoryNetwork {
    switch (this) {
      case AppNetwork.bitcoin:
        return seed.Network.bitcoin;
      case AppNetwork.testnet:
        return seed.Network.testnet;
      case AppNetwork.signet:
        return seed.Network.signet;
      case AppNetwork.regtest:
        return seed.Network.regtest;
    }
  }

  ln.Network get asLightningNodeRepositoryNetwork {
    switch (this) {
      case AppNetwork.bitcoin:
        return ln.Network.bitcoin;
      case AppNetwork.testnet:
        return ln.Network.testnet;
      case AppNetwork.signet:
        return ln.Network.signet;
      case AppNetwork.regtest:
        return ln.Network.regtest;
    }
  }
}
