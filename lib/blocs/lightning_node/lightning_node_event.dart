import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningNodeEvent {
  const LightningNodeEvent();
}

class LightningNodeStarted extends LightningNodeEvent {
  const LightningNodeStarted({required this.network, this.password});
  final Network network;
  final String? password;
}

class LightningNodeStopped extends LightningNodeEvent {
  const LightningNodeStopped();
}
