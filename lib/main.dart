import 'package:flutter/material.dart';
import 'package:ldk_node_flutter_demo/app.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/network/network_cubit.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repositories
  final seedRepository = SeedRepository();
  final lightningNodeRepository = LightningNodeRepository();
  // Create BloCs
  final networkCubit = NetworkCubit(
      Network.regtest); // Change this to Network.Bitcoin in production
  final lightningNodeBloc = LightningNodeBloc(
    lightningNodeRepository: lightningNodeRepository,
    seedRepository: seedRepository,
  );

  // @dev The following line is just for testing purposes
  // Delete stored mnemonic to start with onboarding.
  // Comment it out to keep the already stored mnemonic and skip onboarding.
  await seedRepository.deleteMnemonic();

  runApp(App(
    seedRepository: seedRepository,
    lightningNodeRepository: lightningNodeRepository,
    networkCubit: networkCubit,
    lightningNodeBloc: lightningNodeBloc,
  ));

  // If mnemonic exists, start the node already
  if (await seedRepository.doesMnemonicExist()) {
    // Check if the node is already running before trying to start it
    if (!(await lightningNodeRepository.isNodeRunning())) {
      lightningNodeBloc.add(LightningNodeStarted(network: networkCubit.state));
    }
  }
}
