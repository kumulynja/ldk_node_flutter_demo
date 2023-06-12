// Channel Events
import 'package:ldk_node/ldk_node.dart';

abstract class ChannelEvent {
  final U8Array32 channelId;
  final int userChannelId;

  ChannelEvent(this.channelId, this.userChannelId);
}

class ChannelReady extends ChannelEvent {
  ChannelReady(U8Array32 channelId, int userChannelId)
      : super(channelId, userChannelId);
}

class ChannelClosed extends ChannelEvent {
  ChannelClosed(U8Array32 channelId, int userChannelId)
      : super(channelId, userChannelId);
}

class ChannelPending extends ChannelEvent {
  final U8Array32 formerTemporaryChannelId;
  final String counterpartyNodeId;
  final String fundingTxId;
  final int fundingTxOutputIndex;

  ChannelPending(
    U8Array32 channelId,
    int userChannelId,
    this.formerTemporaryChannelId,
    this.counterpartyNodeId,
    this.fundingTxId,
    this.fundingTxOutputIndex,
  ) : super(channelId, userChannelId);
}
