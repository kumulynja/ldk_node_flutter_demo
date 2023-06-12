import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningChannelsEvent {}

class LightningChannelsStarted extends LightningChannelsEvent {}

class LightningChannelOpeningRequested extends LightningChannelsEvent {
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

class LightningChannelClosingRequested extends LightningChannelsEvent {
  final U8Array32 channelId;
  final String counterpartyPublicKey;

  LightningChannelClosingRequested({
    required this.channelId,
    required this.counterpartyPublicKey,
  });
}

class LightningChannelOpened extends LightningChannelsEvent {
  final Channel channel;

  LightningChannelOpened({required this.channel});
}

class LightningChannelClosed extends LightningChannelsEvent {
  final Channel channel;

  LightningChannelClosed({required this.channel});
}

class LightningChannelPending extends LightningChannelsEvent {
  final Channel channel;

  LightningChannelPending({required this.channel});
}
