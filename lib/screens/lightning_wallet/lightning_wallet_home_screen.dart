import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/blocs/network/network_cubit.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

class LightningWalletHomeScreen extends StatelessWidget {
  const LightningWalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LightningNodeBloc(
        lightningNodeRepository:
            RepositoryProvider.of<LightningNodeRepository>(context),
        seedRepository: RepositoryProvider.of<SeedRepository>(context),
      )..add(LightningNodeStarted(network: context.read<NetworkCubit>().state)),
      child: Scaffold(
        body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
          builder: (context, state) => const Text("WELCOME TO YOUR COIN PURSE"),
        ),
      ),
    );
  }
}
