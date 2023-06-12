import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_balance/lightning_balance_cubit.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/widgets/wallet_info_container.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class LightningWalletHomeScreen extends StatelessWidget {
  const LightningWalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lightningNodeBloc = BlocProvider.of<LightningNodeBloc>(context);
    final lightningNodeRepository =
        RepositoryProvider.of<LightningNodeRepository>(context);

    return Scaffold(
      body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
        bloc: lightningNodeBloc,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            WalletInfoContainer(
                lightningNodeState: state,
                lightningNodeRepository: lightningNodeRepository),
          ],
        ),
      ),
    );
  }
}
