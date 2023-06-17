import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningChannelEvent {}

class LightningChannelStarted extends LightningChannelEvent {}

class LightningChannelOpeningRequested extends LightningChannelEvent {
  final String addressIp;
  final int addressPort;
  final String counterpartyPublicKey;
  final int channelAmountSats;
  final bool announceChannel;

  LightningChannelOpeningRequested({
    required this.addressIp,
    required this.addressPort,
    required this.counterpartyPublicKey,
    required this.channelAmountSats,
    required this.announceChannel,
  });
}

class LightningChannelClosingRequested extends LightningChannelEvent {
  final U8Array32 channelId;
  final String counterpartyPublicKey;

  LightningChannelClosingRequested({
    required this.channelId,
    required this.counterpartyPublicKey,
  });
}

class LightningChannelOpened extends LightningChannelEvent {
  final Channel channel;

  LightningChannelOpened({required this.channel});
}

class LightningChannelClosed extends LightningChannelEvent {
  final Channel channel;

  LightningChannelClosed({required this.channel});
}

class LightningChannelPending extends LightningChannelEvent {
  final Channel channel;

  LightningChannelPending({required this.channel});
}
