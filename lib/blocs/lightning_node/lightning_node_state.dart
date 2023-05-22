import 'package:equatable/equatable.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

abstract class LightningNodeState extends Equatable {
  LightningNodeState();
  //final ldk.Node node;
  //final ldk.PublicKey nodeId;

  @override
  List<Object> get props => [];
}

class LightningNodeInitial extends LightningNodeState {
  LightningNodeInitial();
}

// class NodeRunInProgress extends NodeState {}

class LightningNodeRunSuccess extends LightningNodeState {
  LightningNodeRunSuccess();
}

class LightningNodeRunFailure extends LightningNodeState {
  LightningNodeRunFailure();
}
