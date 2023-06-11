import 'package:ldk_node_flutter_demo/enums/app_network.dart';

abstract class LightningNodeEvent {
  const LightningNodeEvent();
}

class LightningNodeStarted extends LightningNodeEvent {
  const LightningNodeStarted({required this.network, this.password});
  final AppNetwork network;
  final String? password;
}

class LightningNodeStopped extends LightningNodeEvent {
  const LightningNodeStopped();
}
