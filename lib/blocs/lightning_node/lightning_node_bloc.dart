import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

class LightningNodeBloc extends Bloc<LightningNodeEvent, LightningNodeState> {
  LightningNodeBloc(
      {required LightningNodeRepository lightningNodeRepository,
      required SeedRepository seedRepository})
      : _lightningNodeRepository = lightningNodeRepository,
        _seedRepository = seedRepository,
        super(const LightningNodeInitial()) {
    on<LightningNodeStarted>(_onLightningNodeStarted);
  }

  final LightningNodeRepository _lightningNodeRepository;
  final SeedRepository _seedRepository;
  //late ldk.Node node;
  //ldk.Config config;

  @override
  Future<void> close() {
    //snode.stop();
    return super.close();
  }

  FutureOr<void> _onLightningNodeStarted(
    LightningNodeStarted event,
    Emitter<LightningNodeState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.retrieveMnemonic();
      final seed = await mnemonic.toLightningSeed(
          event.network.bdkNetwork, event.password);
      print("seed: $seed");
      // Todo: Use _lightningNodeRepository to start the node with the seed
      emit(LightningNodeRunSuccess(network: event.network, nodeId: '<nodeId>'));
    } catch (e) {
      emit(const LightningNodeRunFailure());
    }
  }
}
