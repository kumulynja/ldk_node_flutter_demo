import 'package:ldk_node_flutter_demo/enums/app_network.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

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

class ChannelEventReceived extends LightningNodeEvent {
  final ChannelEvent channelEvent;

  ChannelEventReceived(this.channelEvent);
}

class PaymentEventReceived extends LightningNodeEvent {
  final PaymentEvent paymentEvent;

  PaymentEventReceived(this.paymentEvent);
}
