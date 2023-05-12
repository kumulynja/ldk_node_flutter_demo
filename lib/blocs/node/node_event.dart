import 'package:ldk_node/ldk_node.dart' as ldk;

abstract class NodeEvent {
  const NodeEvent();
}

class NodeStarted extends NodeEvent {
  const NodeStarted({required this.seedBytes, required this.address});
  final ldk.U8Array64 seedBytes;
  final ldk.SocketAddr address;
}

class NodeStopped extends NodeEvent {
  const NodeStopped();
}
