import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';

class LightningWalletHomeScreen extends StatelessWidget {
  const LightningWalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lightningNodeBloc = BlocProvider.of<LightningNodeBloc>(context);

    return Scaffold(
      body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
        bloc: lightningNodeBloc,
        builder: (context, state) => Text(state is LightningNodeRunSuccess
            ? 'Running node ${state.nodeId} on network ${state.network.toString()}'
            : 'Loading...'),
      ),
    );
  }
}
