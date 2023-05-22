import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class LightningNodeBloc extends Bloc<LightningNodeEvent, LightningNodeState> {
  LightningNodeBloc({required LightningNodeRepository lightningNodeRepository})
      : _lightningNodeRepository = lightningNodeRepository,
        super(LightningNodeInitial()) {}

  final LightningNodeRepository _lightningNodeRepository;
  //late ldk.Node node;
  //ldk.Config config;

  @override
  Future<void> close() {
    //snode.stop();
    return super.close();
  }
}
