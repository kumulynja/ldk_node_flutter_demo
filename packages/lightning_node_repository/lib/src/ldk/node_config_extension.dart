import 'package:lightning_node_repository/src/models/node_config.dart';
import 'package:lightning_node_repository/src/ldk/network_extension.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

// Extension to be able to map the exposed Network enum onto ldk_node's Network enum.
// This way the lightning_node_repository enum can be used in the app code without it needing to know about ldk_node.
extension LdkNodeConfig on NodeConfig {
  ldk.Config get ldkNodeConfig {
    return ldk.Config(
      storageDirPath: this.storageDirPath,
      esploraServerUrl: this.esploraServerUrl,
      network: this.network.ldkNetwork,
      listeningAddress: ldk.SocketAddr(
        ip: this.listeningAddressIp,
        port: this.listeningAddressPort,
      ),
      defaultCltvExpiryDelta: this.defaultCltvExpiryDelta,
    );
  }
}
