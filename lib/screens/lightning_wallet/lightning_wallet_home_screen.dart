import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/widgets/transaction_history.dart';
import 'package:ldk_node_flutter_demo/widgets/wallet_info_container.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_funding_actions.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_payment_actions.dart';

class LightningWalletHomeScreen extends StatelessWidget {
  const LightningWalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            WalletInfoContainer(
              walletName: 'Lightning Wallet',
              containerColor: Theme.of(context).colorScheme.surface,
              isSyncing: state is! LightningNodeRunSuccess,
              balance: state is LightningNodeRunSuccess ? state.balance : null,
              unit: 'sats',
              balanceLabel: 'spendable',
              network:
                  state is LightningNodeRunSuccess ? state.network.name : null,
            ),
            const LightningFundingActions(),
            const LightningPaymentActions(),
            const TransactionHistory(),
          ],
        ),
      ),
    );
  }
}
