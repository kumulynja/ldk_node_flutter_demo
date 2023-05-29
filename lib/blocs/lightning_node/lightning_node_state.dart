import 'package:equatable/equatable.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningNodeState extends Equatable {
  const LightningNodeState({this.alias});

  final String? alias;

  @override
  List<Object?> get props => [alias];
}

class LightningNodeInitial extends LightningNodeState {
  const LightningNodeInitial({String? alias}) : super(alias: alias);
}

class LightningNodeRunSuccess extends LightningNodeState {
  const LightningNodeRunSuccess({
    required this.network,
    required this.nodeId,
    String? alias,
  }) : super(alias: alias);

  final Network network;
  final String nodeId;

  @override
  List<Object?> get props => [network, nodeId, alias];
}

class LightningNodeRunFailure extends LightningNodeState {
  const LightningNodeRunFailure({String? alias}) : super(alias: alias);
}
