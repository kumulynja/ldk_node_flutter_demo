import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node/ldk_node.dart' as ldk;

import 'package:ldk_node_flutter_demo/blocs/node/node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/node/node_state.dart';
import 'package:ldk_node_flutter_demo/models/node.dart';

class NodeBloc extends Bloc<NodeEvent, NodeState> {
  late ldk.Node node;
  NodeConfig config;

  NodeBloc() : super(NodeInitial());

  @override
  Stream<NodeState> mapEventToState(NodeEvent event) async* {
    if (event is NodeStarted) {
      yield* _mapStartNodeToState();
    } else if (event is NodeStopped) {
      yield* _mapStopNodeToState();
    }
  }

  Stream<NodeState> _mapStartNodeToState() async* {
    try {
      config = NodeConfig(testnet: true);
      client = await LightningClient.connect(config);
      yield NodeStartedState(Node(client: client));
    } catch (e) {
      yield NodeErrorState(message: 'Error starting node: $e');
    }
  }

  Stream<NodeState> _mapStopNodeToState() async* {
    try {
      await client.shutdown();
      yield NodeStoppedState();
    } catch (e) {
      yield NodeErrorState(message: 'Error stopping node: $e');
    }
  }

  @override
  Future<void> close() {
    node.stop();
    return super.close();
  }
}
