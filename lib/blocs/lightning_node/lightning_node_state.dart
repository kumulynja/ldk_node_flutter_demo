import 'package:equatable/equatable.dart';
import 'package:ldk_node_flutter_demo/enums/app_network.dart';

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
    required this.balance,
  });

  final AppNetwork network;
  final String nodeId;
  final int balance;

  LightningNodeRunSuccess copyWith({
    AppNetwork? network,
    String? nodeId,
    int? balance,
  }) {
    return LightningNodeRunSuccess(
      network: network ?? this.network,
      nodeId: nodeId ?? this.nodeId,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [network, nodeId, balance];
}

class LightningNodeRunFailure extends LightningNodeState {
  const LightningNodeRunFailure();
}
