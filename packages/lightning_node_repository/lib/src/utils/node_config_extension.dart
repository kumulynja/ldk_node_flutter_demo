import 'package:lightning_node_repository/src/models/node_config.dart';
import 'package:lightning_node_repository/src/utils/network_extension.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

// Extension to be able to map the exposed Network enum onto ldk_node's Network enum.
// This way the lightning_node_repository enum can be used in the app code without it needing to know about ldk_node.
extension LdkNodeConfigX on NodeConfig {
  ldk.Config get asLdkNodeConfig {
    return ldk.Config(
      storageDirPath: this.storageDirPath,
      esploraServerUrl: this.esploraServerUrl,
      network: this.network.asLdkNetwork,
      listeningAddress: ldk.SocketAddr(
        ip: this.listeningAddressIp,
        port: this.listeningAddressPort,
      ),
      defaultCltvExpiryDelta: this.defaultCltvExpiryDelta,
    );
  }
}
