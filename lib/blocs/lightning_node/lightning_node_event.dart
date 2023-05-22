import 'package:ldk_node/ldk_node.dart' as ldk;

abstract class LightningNodeEvent {
  const LightningNodeEvent();
}

class LightningNodeStarted extends LightningNodeEvent {
  const LightningNodeStarted({required this.seedBytes, required this.address});
  final ldk.U8Array64 seedBytes;
  final ldk.SocketAddr address;
}

class LightningNodeStopped extends LightningNodeEvent {
  const LightningNodeStopped();
}
