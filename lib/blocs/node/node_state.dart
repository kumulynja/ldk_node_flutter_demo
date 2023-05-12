import 'package:equatable/equatable.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

abstract class NodeState extends Equatable {
  NodeState();
  final ldk.Node node;
  final ldk.PublicKey nodeId;

  @override
  List<Object> get props => [node];
}

class NodeInitial extends NodeState {
  NodeInitial();
}

// class NodeRunInProgress extends NodeState {}

class NodeRunSuccess extends NodeState {
  NodeRunSuccess();
}

class NodeRunFailure extends NodeState {
  NodeRunFailure();
}
