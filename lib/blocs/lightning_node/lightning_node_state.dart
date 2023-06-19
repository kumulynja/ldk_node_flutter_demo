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
    required this.onChainBalance,
    required this.channels,
  });

  final AppNetwork network;
  final String nodeId;
  final Balance onChainBalance;
  final List<ChannelDetails> channels;

  LightningNodeRunSuccess copyWith({
    AppNetwork? network,
    String? nodeId,
    Balance? onChainBalance,
    List<ChannelDetails>? channels,
  }) {
    return LightningNodeRunSuccess(
      network: network ?? this.network,
      nodeId: nodeId ?? this.nodeId,
      onChainBalance: onChainBalance ?? this.onChainBalance,
      channels: channels ?? this.channels,
    );
  }

  int get activeChannelCount =>
      channels.where((channel) => channel.isUsable).length;
  int get inactiveChannelCount =>
      channels.where((channel) => !channel.isUsable).length;
  int get totalOutBoundCapacityMsat =>
      channels.fold(0, (sum, channel) => sum + channel.outboundCapacityMsat);
  double get confirmedOnChainBalanceBtc =>
      onChainBalance.confirmed / 100000000; // 1 BTC = 100,000,000 sats
  double get totalOutBoundCapacitySat =>
      totalOutBoundCapacityMsat / 1000; // 1 sat = 1000 msats

  @override
  List<Object?> get props => [network, nodeId, onChainBalance, channels];
}

class LightningNodeRunFailure extends LightningNodeState {
  const LightningNodeRunFailure();
}
