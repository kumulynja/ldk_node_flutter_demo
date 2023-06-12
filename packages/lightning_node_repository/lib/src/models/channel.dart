import 'package:ldk_node/ldk_node.dart';

class Channel {
  const Channel(
      {required this.channelId,
      required this.outboundCapacityMsat,
      required this.inboundCapacityMsat});

  /// The channel's ID as a Hex String (prior to funding transaction generation, this is a random 32 bytes,
  /// thereafter this is the txid of the funding transaction xor the funding transaction output).
  /// Note that this means this value is *not* persistent - it can change once during the
  /// lifetime of the channel.
  final U8Array32 channelId;

  /// The available outbound capacity for sending HTLCs to the remote peer. This does not include
  /// any pending HTLCs which are not yet fully resolved (and, thus, whose balance is not
  /// available for inclusion in new outbound HTLCs). This further does not include any pending
  /// outgoing HTLCs which are awaiting some other resolution to be sent.
  ///
  /// This value is not exact. Due to various in-flight changes, feerate changes, and our
  /// conflict-avoidance policy, exactly this amount is not likely to be spendable. However, we
  /// should be able to spend nearly this amount.
  final int outboundCapacityMsat;

  /// The available inbound capacity for the remote peer to send HTLCs to us. This does not
  /// include any pending HTLCs which are not yet fully resolved (and, thus, whose balance is not
  /// available for inclusion in new inbound HTLCs).
  /// Note that there are some corner cases not fully handled here, so the actual available
  /// inbound capacity may be slightly higher than this.
  ///
  /// This value is not exact. Due to various in-flight changes, feerate changes, and our
  /// counterparty's conflict-avoidance policy, exactly this amount is not likely to be spendable.
  /// However, our counterparty should be able to spend nearly this amount.
  final int inboundCapacityMsat;
}
