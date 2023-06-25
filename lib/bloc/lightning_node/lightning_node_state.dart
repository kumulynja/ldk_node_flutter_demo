import 'package:equatable/equatable.dart';
import 'package:ldk_node_flutter_demo/enums/app_network.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningNodeState extends Equatable {
  const LightningNodeState();

  @override
  List<Object?> get props => [];
}

class LightningNodeInitial extends LightningNodeState {
  const LightningNodeInitial();
}

class LightningNodeRunSuccess extends LightningNodeState {
  const LightningNodeRunSuccess({
    required this.network,
    required this.nodeId,
    required this.listeningIp,
    required this.listeningPort,
    required this.onChainBalance,
    required this.channels,
    required this.payments,
  });

  final AppNetwork network;
  final String nodeId;
  final String? listeningIp;
  final int? listeningPort;
  final Balance onChainBalance;
  final List<ChannelDetails> channels;
  final List<PaymentDetails> payments;

  LightningNodeRunSuccess copyWith({
    AppNetwork? network,
    String? nodeId,
    String? listeningIp,
    int? listeningPort,
    Balance? onChainBalance,
    List<ChannelDetails>? channels,
    List<PaymentDetails>? payments,
  }) {
    return LightningNodeRunSuccess(
      network: network ?? this.network,
      nodeId: nodeId ?? this.nodeId,
      listeningIp: listeningIp ?? this.listeningIp,
      listeningPort: listeningPort ?? this.listeningPort,
      onChainBalance: onChainBalance ?? this.onChainBalance,
      channels: channels ?? this.channels,
      payments: payments ?? this.payments,
    );
  }

  int get activeChannelCount =>
      channels.where((channel) => channel.isUsable).length;
  int get inactiveChannelCount =>
      channels.where((channel) => !channel.isUsable).length;
  int get totalOutBoundCapacityMsat => channels.fold(
        0,
        (sum, channel) =>
            channel.isUsable ? sum + channel.outboundCapacityMsat : sum,
      ); // To be spendable, the channel should be usable
  double get confirmedOnChainBalanceBtc =>
      onChainBalance.confirmed / 100000000; // 1 BTC = 100,000,000 sats
  double get trustedPendingOnChainBalanceBtc =>
      onChainBalance.trustedPending / 100000000; // 1 BTC = 100,000,000 sats
  double get untrustedPendingOnChainBalanceBtc =>
      onChainBalance.untrustedPending / 100000000; // 1 BTC = 100,000,000 sats
  double get immatureOnChainBalanceBtc =>
      onChainBalance.immature / 100000000; // 1 BTC = 100,000,000 sats
  double get totalOnChainBalanceBtc =>
      (onChainBalance.confirmed +
          onChainBalance.trustedPending +
          onChainBalance.untrustedPending +
          onChainBalance.immature) /
      100000000; // 1 BTC = 100,000,000 sats
  double get totalOutBoundCapacitySat =>
      totalOutBoundCapacityMsat / 1000; // 1 sat = 1000 msats

  @override
  List<Object?> get props => [
        network,
        nodeId,
        listeningIp,
        listeningPort,
        onChainBalance,
        channels,
        payments
      ];
}

class LightningNodeRunFailure extends LightningNodeState {
  const LightningNodeRunFailure();
}
