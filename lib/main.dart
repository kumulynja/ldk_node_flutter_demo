import 'package:flutter/material.dart';
import 'package:ldk_node_flutter_demo/app.dart';
import 'package:ldk_node_flutter_demo/enums/app_network.dart';
import 'package:ldk_node_flutter_demo/bloc/network/network_cubit.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_event.dart';
import 'package:seed_repository/seed_repository.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repositories
  final seedRepository = SeedRepository();
  final lightningNodeRepository = LightningNodeRepository();
  // Create BloCs
  final networkCubit = NetworkCubit(
    AppNetwork.testnet,
  ); // Change this to Network.Bitcoin in production
  final lightningNodeBloc = LightningNodeBloc(
    lightningNodeRepository: lightningNodeRepository,
    seedRepository: seedRepository,
  );

  // @dev The following line is just for testing purposes
  // Delete stored mnemonic to start with onboarding.
  // Comment it out to keep the already stored mnemonic and skip onboarding.
  // await seedRepository.deleteMnemonic();

  // If mnemonic exists, start the node already
  if (await seedRepository.doesMnemonicExist()) {
    // Todo: Check if the node is already running before trying to start it
    // Is this really necessarry? The node should be stopped only when the app is terminated.
    //if (!(await lightningNodeRepository.isNodeRunning())) {
    lightningNodeBloc.add(LightningNodeStarted(network: networkCubit.state));
    //}
  }

  runApp(App(
    seedRepository: seedRepository,
    lightningNodeRepository: lightningNodeRepository,
    networkCubit: networkCubit,
    lightningNodeBloc: lightningNodeBloc,
  ));
}
